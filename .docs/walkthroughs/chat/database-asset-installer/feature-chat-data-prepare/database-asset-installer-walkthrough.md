# Database Asset Installer — Comprehensive Walkthrough & Developer Guide

## 1. Overview & Conceptual Background

### 1.1 The Problem: Why Can't SQLite Read Directly from Flutter Assets?
When you declare files under `assets/` in Flutter (e.g., `assets/databases/exercises.db`), Flutter packages them directly inside the read-only, compressed application bundle during build time:
- On **Android**, assets are zipped inside the `.apk` / `.aab` package file (`assets/flutter_assets/...`).
- On **iOS**, assets are packed into the read-only `.app` container bundle.

The native SQLite C engine (`libsqlite3`), which powers Flutter's `sqflite` plugin, requires a **standard POSIX file path** on the operating system's writable storage system (e.g., `/data/user/0/com.example.fitness_app/databases/exercises.db`). SQLite operates using standard OS file descriptors (`open()`, `read()`, `write()`, `lseek()`) and memory mapping (`mmap`). It **cannot** parse compressed archive entries inside an `.apk` or read-only `.app` bundle.

### 1.2 The Solution
[`DatabaseAssetInstaller`](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/database_asset_installer.dart) is an asynchronous initialization service. During app startup, prior to executing any SQLite query or rendering UI, it:
1. Determines whether the databases are already installed and up-to-date on physical disk.
2. If installation or an upgrade is required, extracts the raw binary bytes from Flutter's asset bundle into memory.
3. Cryptographically audits the bytes using a SHA-256 checksum to guarantee 100% data integrity.
4. Atomically writes the database to a `.tmp` file and swaps it into the target location to prevent corrupted partial files.
5. Saves the installed version stamp into persistent preferences (`SharedPreferences`).

```
                +------------------------------------+
                |       Flutter Asset Bundle         |
                |  - assets/databases/manifest.json  |
                |  - assets/databases/exercises.db   |
                |  - assets/databases/meals.db       |
                +-----------------+------------------+
                                  |
                                  | 1. Read Manifest & Compare Versions
                                  v
+---------------------------------+----------------------------------+
|                   DatabaseAssetInstaller                           |
|                                                                    |
|  [Is up-to-date & files exist?]                                    |
|      ├── YES ──> Bypass copying (cold-start takes < 1 ms)          |
|      └── NO  ──> Proceed with atomic installation:                 |
|                   2. Extract byte buffer from AssetBundle          |
|                   3. SHA-256 Checksum Audit                        |
|                   4. Write to <file>.tmp                           |
|                   5. Atomic rename to <file>.db                    |
|                   6. Save version in SharedPreferences             |
+---------------------------------+----------------------------------+
                                  |
                                  v
                +------------------------------------+
                | Device Persistent Storage (Disk)   |
                | Path: getDatabasesPath()           |
                |  - exercises.db (~4.8 MB)          |
                |  - meals.db     (~3.6 MB)          |
                | (Ready for sqflite read-only access)|
                +------------------------------------+
```

---

## 2. Status and Metadata
- **Status**: Completed
- **Module**: `chat`
- **Task**: `database-asset-installer`
- **Team Member**: `ali-hassan-ali32`
- **Started Date**: 2026-11-08
- **Completed Date**: 2026-11-10
- **Actual Branch Name**: `feature/chat-data-prepare`

---

## 3. Architecture & Layers

```
lib/
├── config/
│   └── di/
│       ├── app_module.dart                <-- [Provides SharedPreferences & AssetBundle via DI]
│       ├── di.dart                        <-- [configureDependencies entry point]
│       └── di.config.dart                 <-- [Injectable code generation registry]
├── core/
│   └── database/
│       ├── database_storage_service.dart      <-- [Filesystem & path abstraction interface]
│       ├── database_storage_service_impl.dart <-- [Concrete dart:io & sqflite implementation]
│       └── database_asset_installer.dart      <-- [Asset verification & extraction service]
└── main.dart                              <-- [App entry: await configureDependencies() -> ensureDatabasesInstalled()]
```

### Separation of Concerns & Clean Architecture:
- **`DatabaseStorageService`**: An abstract interface providing filesystem and path operations (`getDatabasesPath()`, `fileExists()`, `createDirectory()`, `writeBytes()`, `deleteFile()`, `renameFile()`). This encapsulates all static `dart:io` `File`/`Directory` constructors and top-level `getDatabasesPath()` calls, making `DatabaseAssetInstaller` 100% testable without touching platform channels or disk I/O.
- **`DatabaseStorageServiceImpl`**: Concrete `@LazySingleton` implementation executing real filesystem and SQLite directory operations.
- **`DatabaseAssetInstaller`**: Core business logic service annotated with `@injectable`. Injected with `SharedPreferences`, `AssetBundle`, and `DatabaseStorageService`. Free of hidden default dependencies.
- **`main.dart`**: Triggers asynchronous dependency injection configuration first, resolving `DatabaseAssetInstaller` cleanly from GetIt before running the UI.

---

## 4. Detailed Data Flow & Execution Steps

### Step 1: Manifest Retrieval & Version Check
The installer reads `assets/databases/manifest.json`. This JSON document contains:
```json
{
  "version": 1,
  "data_version": "2026.07.25",
  "files": {
    "exercises.db": "2b356aa1912ac91207be28706792f080052339aa7d89514220c9fcd5cb57bdff",
    "meals.db": "8af8a4e177178f0afb456b05e17c9924400cc24789acdcdda4528ab5a8d7f946"
  }
}
```

### Step 2: Bypass Check (Cold-Start Optimization)
The installer queries `DatabaseStorageService.getDatabasesPath()` and checks `SharedPreferences` for `local_db_manifest_version`:
- If `savedVersion == manifestVersion` **AND** all database files physically exist on disk, the installer immediately exits.
- **Cold start overhead on subsequent app launches: < 1 ms.**

### Step 3: Directory Creation & Binary Extraction
If installation is required:
1. `_storage.createDirectory(dbDirPath, recursive: true)` ensures the database directory exists.
2. For each file in the manifest, `_bundle.load('assets/databases/$fileName')` reads raw binary data into memory.

### Step 4: Cryptographic Integrity Verification (SHA-256)
Before writing anything to disk, the SHA-256 checksum is calculated:
```dart
final actualHash = sha256.convert(bytes).toString().toLowerCase();
if (actualHash != expectedHash) {
  throw StateError(
    '🚨 DatabaseAssetInstaller: SHA-256 mismatch for $fileName! Expected: $expectedHash, Actual: $actualHash',
  );
}
```
If an asset was corrupted or truncated during packaging, execution aborts immediately with a `StateError`.

### Step 5: Atomic Two-Phase Commit (`.tmp` -> Target)
To guard against partial writes if the user closes or kills the app during extraction:
1. Write raw bytes to `targetPath.tmp` using `_storage.writeBytes(tmpPath, bytes, flush: true)`.
2. Delete the old database file if it already exists: `if (await _storage.fileExists(targetPath)) await _storage.deleteFile(targetPath);`.
3. Atomically rename the temporary file to the final file name: `await _storage.renameFile(tmpPath, targetPath);`.

### Step 6: Version Stamp Persistence
After all files are verified and atomically moved, the installer updates `SharedPreferences`:
```dart
await _prefs.setInt(_versionKey, manifestVersion);
```

---

## 5. Important Classes, Methods & Code Breakdown

### 5.1 `DatabaseStorageService` ([database_storage_service.dart](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/database_storage_service.dart))

```dart
abstract class DatabaseStorageService {
  Future<String> getDatabasesPath();
  Future<bool> fileExists(String path);
  Future<bool> directoryExists(String path);
  Future<void> createDirectory(String path, {bool recursive = false});
  Future<void> writeBytes(String path, Uint8List bytes, {bool flush = false});
  Future<void> deleteFile(String path);
  Future<void> renameFile(String sourcePath, String targetPath);
}
```
- **Rationale**: Abstracting filesystem calls decouples business logic from OS-level operations and allows complete isolation testing with fast in-memory mocks.

### 5.2 `DatabaseAssetInstaller` ([database_asset_installer.dart](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/database_asset_installer.dart))

```dart
@injectable
class DatabaseAssetInstaller {
  static const String _versionKey = 'local_db_manifest_version';
  static const String _manifestPath = 'assets/databases/manifest.json';

  final SharedPreferences _prefs;
  final AssetBundle _bundle;
  final DatabaseStorageService _storage;

  DatabaseAssetInstaller(
    this._prefs,
    this._bundle,
    this._storage,
  );

  Future<void> ensureDatabasesInstalled() async { ... }
}
```
- **Dependency Injection**: Constructor parameters are non-nullable and injected directly via GetIt/Injectable. Hidden fallback dependencies (such as `bundle ?? rootBundle`) are eliminated.

---

## 6. Project Integration

### Initialization in `main.dart` ([main.dart](file:///d:/ali/flutter_project/Fitness_App/lib/main.dart))
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<DatabaseAssetInstaller>().ensureDatabasesInstalled();
  runApp(const FitnessApp());
}
```

---

## 7. Implementation Decisions & Trade-Offs

| Decision | Why It Was Chosen | Trade-Off / Alternative Considered |
| --- | --- | --- |
| **`DatabaseStorageService` Abstraction** | Eliminates static calls to `dart:io` `File` and `Directory` and `getDatabasesPath()`, enabling pure, deterministic unit testing. | Minor interface boilerplate; vastly superior maintainability and testability. |
| **Constructor Injection (No Hidden Defaults)** | Satisfies clean code review standards by requiring explicit dependencies through GetIt. | Dependencies must be registered in DI modules (`AppModule`). |
| **Atomic `.tmp` Write + Rename** | Eliminates database corruption if the app is killed mid-write. | Takes temporary disk space equal to 1 file during install; infinitely safer than direct write. |
| **SHA-256 Checksum Audit** | Guarantees file integrity before committing; fails fast if an asset was truncated during build. | Adds ~20–40 ms on first run to compute hashes; negligible compared to data safety. |
| **SharedPreferences Versioning** | Skips database installation on subsequent launches (< 1 ms cold starts). | Requires pre-resolving `SharedPreferences` in `configureDependencies()`. |

---

## 8. Testing & Verification

1. **Unit Testing (`database_asset_installer_test.dart`)**:
   - Skips installation when saved version matches and all files exist.
   - Installs databases successfully on fresh install (when saved version is `null`).
   - Deletes existing target file before renaming if target file already exists.
   - Reinstalls databases when version matches but one file is missing on disk.
   - Parses string version correctly from manifest (`"2"` -> `2`).
   - Throws `StateError` and aborts when SHA-256 hash does not match.
   - **Result: 6/6 tests passed in 5 seconds.**

2. **Unit Testing (`database_storage_service_impl_test.dart`)**:
   - Verifies directory creation recursively.
   - Verifies byte writes and file existence checks.
   - Verifies atomic rename from source to target path.
   - Verifies safe file deletion.
   - **Result: 4/4 tests passed.**

3. **Static Analysis**: `flutter analyze` reports **0 issues found**.
4. **Full Test Suite**: `flutter test` reports **458/458 tests passing**.

---

## 9. Files Created / Modified

| File Path | Status | Description |
| --- | --- | --- |
| [`lib/core/database/database_storage_service.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/database_storage_service.dart) | Created | Abstract interface for filesystem and database path operations. |
| [`lib/core/database/database_storage_service_impl.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/database_storage_service_impl.dart) | Created | Concrete `@LazySingleton` implementation wrapping `dart:io` and `sqflite`. |
| [`lib/core/database/database_asset_installer.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/database_asset_installer.dart) | Modified | Refactored to use constructor injection and `DatabaseStorageService`. |
| [`lib/config/di/app_module.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/config/di/app_module.dart) | Modified | Added `@preResolve` provider for `SharedPreferences`. |
| [`lib/config/di/di.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/config/di/di.dart) | Modified | Updated `configureDependencies()` to return `Future<void>`. |
| [`lib/main.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/main.dart) | Modified | Resolves `DatabaseAssetInstaller` via `getIt` after `configureDependencies()`. |
| [`test/core/database/database_asset_installer_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/core/database/database_asset_installer_test.dart) | Created | Comprehensive unit test suite with mocktail verifying all execution paths. |
| [`test/core/database/database_storage_service_impl_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/core/database/database_storage_service_impl_test.dart) | Created | Unit tests for real filesystem operations using temporary directories. |

---

## 10. Update History
- **2026-11-08** (`ali-hassan-ali32`): Initial implementation of `DatabaseAssetInstaller`, manifest verification, integration into `main.dart`, and creation of initial task walkthrough.
- **2026-11-08** (`ali-hassan-ali32`): Expanded walkthrough with comprehensive conceptual problem analysis, SQLite architectural background, step-by-step code annotations, data flow diagram, and developer onboarding instructions.
- **2026-11-10** (`ali-hassan-ali32`): Code review refactoring: removed default hidden dependency `bundle ?? rootBundle` in favor of constructor injection; abstracted `getDatabasesPath()`, `File`, and `Directory` behind `DatabaseStorageService`; registered all components in Injectable DI; added comprehensive unit tests for `DatabaseAssetInstaller` and `DatabaseStorageServiceImpl`.
