# Catalog Repository & Local Data Source — Comprehensive Walkthrough & Developer Guide

## 1. Overview & Conceptual Background

### 1.1 The Engineering Problem: The Token & Latency Bottleneck
The AI Coach feature integrates Google's **Gemma 4** model (served locally via Ollama) into the mobile app to provide personalized conversational fitness workouts and meal planning.

To ground the AI's recommendations in verified, actionable app data, two pre-populated SQLite databases are installed on the user's device:
1. `exercises.db`: Contains 2,988 exercises with difficulty levels, target muscle groups, primary equipment, video demonstration links, and mechanics.
2. `meals.db`: Contains 792 curated meals with macronutrients (calories, protein, carbs, fats), dietary flags (vegetarian, vegan, gluten-free), and preparation instructions.

#### Why We Cannot Dump Databases Directly into the LLM Prompt:
- **Token Overload**: Feeding 2,988 exercises and 792 meals into the LLM system prompt consumes **over 400,000 tokens** per conversational turn.
- **Context Window Exhaustion**: Even large-context models degrade significantly in attention retrieval when flooded with hundreds of thousands of irrelevant catalog tokens.
- **Latency & Resource Drain**: Processing hundreds of thousands of input tokens on a mobile device or local edge server takes 30–60+ seconds per response, making real-time chatting impossible.

### 1.2 The Solution: Two-Tier Local Catalog Architecture
To solve this bottleneck, the application implements a **Two-Tier Local Catalog Architecture**:

1. **Tier 1: Minimal Vocabulary Injection (~400 tokens)**:
   - At session startup, the app extracts only the unique, discrete categorical values (`DISTINCT`) across difficulty levels, muscle groups, equipment types, meal categories, and cuisines.
   - This compact vocabulary (~400 tokens total) is injected into Gemma 4's system prompt so the model knows the exact filter terms accepted by the database without seeing the catalog items themselves.
2. **Tier 2: On-Demand Tool Querying (~2 ms execution)**:
   - When the user asks a question (e.g., *"Suggest a high-protein dinner under 500 kcal"*), Gemma 4 generates a structured tool call (`get_meals(min_protein: 30, max_kcal: 500)`).
   - The app intercepts this function call, executes a targeted, parameterized SQLite query against local storage in ~2 ms, and returns only the top 8 matching candidate DTOs back to the model.
3. **Tier 3: Entity Resolution & Interactive UI Cards**:
   - Once the LLM formulates its conversational answer citing chosen meal or exercise IDs, the UI retrieves the complete entity models (`getMealsByIds` / `getExercisesByIds`) to display interactive, rich preview cards directly in the chat feed.

### 1.3 Clean Architecture & Alignment with Existing Features
To maintain architectural consistency across the entire codebase, the local catalog data access layer strictly replicates the flow pattern of the Meals feature (`MealsRemoteDataSource` -> `MealsDatabaseResponse` -> `MealsRepoImpl` via `.then((r) => r.toEntity())`):
- **Pure Domain Entities**: Entities in the domain layer (`ExerciseEntity`, `MealEntity`, `CatalogFilterMetadata`) contain business properties and optional extended fields from SQLite.
- **Typed Response DTOs**: `ExerciseDatabaseDTO` / `ExercisesDatabaseResponse` and `MealDatabaseDTO` / `MealsDatabaseResponse` represent raw SQLite table rows.
- **Extension Mappers**: Dedicated extension mappers (`exercises_database_response_mapper.dart` and `meals_database_response_mapper.dart`) handle all transformations between DTO responses and domain entities.
- **Repository Delegation**: `CatalogRepositoryImpl` delegates database calls to `CatalogLocalDataSource` and maps DTO responses to domain entities using reactive `Future.then` chains.
- **Typed Database Wrappers**: Dedicated, injectable singleton wrappers (`ExercisesDatabase`, `MealsDatabase`) lazily initialize database connections on demand.

```
+-----------------------------------------------------------------------------------------+
|                                    Domain Layer                                         |
|                                                                                         |
|   [CatalogRepository] (Interface)                                                       |
|     - Future<CatalogFilterMetadata> getFilterMetadata()                                |
|     - Future<List<ExerciseEntity>> getExercisesForTool(...)                             |
|     - Future<List<MealEntity>> getMealsForTool(...)                                     |
|     - Future<List<ExerciseEntity>> getExercisesByIds(List<String> ids)                 |
|     - Future<List<MealEntity>> getMealsByIds(List<String> ids)                         |
+-------------------------------------------+---------------------------------------------+
                                            ▲
                                            │ implements
+-------------------------------------------+---------------------------------------------+
|                                     Data Layer                                          |
|                                                                                         |
|   [CatalogRepositoryImpl]                                                               |
|      │                                                                                  |
|      │ maps via .then((r) => r.toEntity())                                              |
|      ▼                                                                                  |
|   [CatalogLocalDataSource] (Interface)                                                  |
|     - Future<CatalogFilterMetadata> getFilterMetadata()                                |
|     - Future<ExercisesDatabaseResponse> getExercisesForTool(...)                       |
|     - Future<MealsDatabaseResponse> getMealsForTool(...)                               |
|     - Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids)            |
|     - Future<MealsDatabaseResponse> getMealsByIds(List<String> ids)                    |
|          ▲                                                                              |
|          │ implements                                                                   |
|   [CatalogLocalDataSourceImpl]                                                          |
|     - Injected with ExercisesDatabase & MealsDatabase wrappers                          |
|     - Future-caching concurrency guard on getFilterMetadata                             |
|     - sqlite_master introspection for table resolution (no blind try/catch)            |
|     - Parameterized SQL execution & typed DTO mapping                                   |
+-------------------------------------------+---------------------------------------------+
                                            │
                                            ▼ queries SQLite (readOnly: true)
+-------------------------------------------+---------------------------------------------+
|                            Persistent Storage (Disk)                                    |
|                                                                                         |
|      exercises.db (exercise_card)                meals.db (meal_card)                   |
+-----------------------------------------------------------------------------------------+
```

---

## 2. Status and Metadata
- **Status**: Completed
- **Module**: `chat`
- **Task**: `catalog-repository`
- **Team Member**: `ali-hassan-ali32`
- **Started Date**: 2026-11-08
- **Completed Date**: 2026-11-10
- **Actual Branch Name**: `feature/chat-data-prepare`

---

## 3. Architecture & File Structure

```
lib/
├── core/
│   └── database/
│       ├── database_storage_service.dart      <-- Storage abstraction
│       ├── exercises_database.dart            <-- Typed Exercises database wrapper
│       └── meals_database.dart                <-- Typed Meals database wrapper
├── features/
│   ├── chat/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── catalog_entities.dart            <-- Barrel file re-exporting entities
│   │   │   │   └── catalog_filter_metadata.dart     <-- Vocabulary filter metadata
│   │   │   └── repository/
│   │   │       └── catalog_repository.dart          <-- [Domain Contract]
│   │   └── data/
│   │       ├── datasource/
│   │       │   └── local/
│   │       │       ├── catalog_local_data_source.dart      <-- [Data Source Interface]
│   │       │       └── catalog_local_data_source_impl.dart <-- [Data Source Implementation]
│   │       ├── models/
│   │       │   └── responses/
│   │       │       ├── exexercises_database_response/
│   │       │       │   ├── exercise_database_dto.dart      <-- SQLite exercise row DTO
│   │       │       │   └── exercises_database_response.dart<-- Response wrapper from SQLite
│   │       │       ├── meals_database_response/
│   │       │       │   ├── meal_database_dto.dart          <-- SQLite meal row DTO
│   │       │       │   └── meals_database_response.dart    <-- Response wrapper from SQLite
│   │       │       └── mappers/
│   │       │           ├── exercises_database_response_mapper.dart <-- Exercise mapper
│   │       │           └── meals_database_response_mapper.dart     <-- Meal mapper
│   │       └── repository/
│   │           └── catalog_repository_impl.dart     <-- [Repository Implementation]
test/
└── features/
    └── chat/
        ├── data/
        │   ├── datasource/
        │   │   └── local/
        │   │       └── catalog_local_data_source_impl_test.dart <-- Unit tests for data source
        │   └── repository/
        │       └── catalog_repository_impl_test.dart            <-- Unit tests for repository
        └── models/responses/mappers/
            ├── exercises_database_response_mapper_test.dart
            └── meals_database_response_mapper_test.dart
```

---

## 4. Detailed Data Flow & Execution Steps

### 4.1 Tier 1: System Prompt Vocabulary Extraction (`getFilterMetadata`)
```
UI / ChatCubit
     │
     ▼ 1. Call getFilterMetadata()
CatalogRepositoryImpl
     │
     ▼ 2. Delegate to CatalogLocalDataSourceImpl
CatalogLocalDataSourceImpl
     │
     ├──> Check _metadataFuture != null?
     │     ├── YES: Return existing Future (prevents race conditions)
     │     └── NO:  Assign _metadataFuture = _fetchFilterMetadata()
     │
     ├──> Step 1: Query distinct muscle_group, difficulty, equipment from exercise_card
     ├──> Step 2: Query distinct category, area from meal_card
     │
     ▼ 3. Construct CatalogFilterMetadata & resolve Future
Prompt Builder (Inject into Gemma 4 System Prompt)
```

### 4.2 Tier 2: LLM Tool Calls (`getExercisesForTool` / `getMealsForTool`)
```
Gemma 4 Tool Call: get_exercises(muscle_group: "Chest", difficulty: "Beginner")
     │
     ▼
CatalogRepositoryImpl.getExercisesForTool(...)
     │
     ▼ Delegates to
CatalogLocalDataSourceImpl.getExercisesForTool(...)
     │
     ├──> Prepare parameterized WHERE clauses & arguments
     ├──> Execute SELECT on exercise_card with limit (default 8)
     ├──> Map raw SQLite rows to ExercisesDatabaseResponse
     │
     ▼ Returns ExercisesDatabaseResponse
CatalogRepositoryImpl
     │
     ▼ Maps via .then((r) => r.toEntity())
Returns List<ExerciseEntity> to Chat/Tool execution layer
```

### 4.3 Tier 3: Complete Entity Resolution (`getExercisesByIds` / `getMealsByIds`)
```
Gemma 4 response mentions exercise IDs: ["push-up", "incline-dumbbell-press"]
     │
     ▼
CatalogRepositoryImpl.getExercisesByIds(["push-up", "incline-dumbbell-press"])
     │
     ▼ Delegates to
CatalogLocalDataSourceImpl.getExercisesByIds(...)
     │
     ├──> Guard: ids.isEmpty? Return ExercisesDatabaseResponse(exercises: [])
     ├──> Resolve table name via sqlite_master: "exercise" (or "exercise_card")
     ├──> Execute SELECT * FROM <table> WHERE id IN (?, ?) with parameters
     ├──> Map rows to ExercisesDatabaseResponse
     │
     ▼ Returns ExercisesDatabaseResponse
CatalogRepositoryImpl
     │
     ▼ Maps via .then((r) => r.toEntity())
Returns List<ExerciseEntity> with full biomechanics, video URLs, and descriptions
     │
     ▼
UI displays interactive Exercise Cards in chat feed
```

---

## 5. Important Classes, Methods & Code Breakdown

### 5.1 Typed Database Wrappers ([exercises_database.dart](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/exercises_database.dart), [meals_database.dart](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/meals_database.dart))

```dart
@lazySingleton
class ExercisesDatabase {
  final DatabaseStorageService _storageService;
  Database? _db;

  ExercisesDatabase(this._storageService);

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    return _db = await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    final dir = await _storageService.getDatabasesPath();
    final dbPath = p.join(dir, 'exercises.db');
    return openDatabase(dbPath, readOnly: true);
  }
}
```
- **Responsibility**: Manages the single SQLite connection lifecycle for `exercises.db` and `meals.db`.
- **Lazy Initialization**: Connection opens only on first query and stays open for subsequent reads.
- **Dependency Injection**: Injected via GetIt/Injectable into `CatalogLocalDataSourceImpl`, removing the need for testing constructors.

### 5.2 Concurrency & Race Condition Guard on `getFilterMetadata`

```dart
Future<CatalogFilterMetadata>? _metadataFuture;

@override
Future<CatalogFilterMetadata> getFilterMetadata() {
  _metadataFuture ??= _fetchFilterMetadata();
  return _metadataFuture!;
}

Future<CatalogFilterMetadata> _fetchFilterMetadata() async {
  try {
    // Execute SQLite queries across both databases...
    return CatalogFilterMetadata(...);
  } catch (e) {
    _metadataFuture = null; // Clear so subsequent retries can re-attempt
    rethrow;
  }
}
```
- **Problem Prevented**: If two asynchronous callers execute `getFilterMetadata()` concurrently before the first finishes, both would see a `null` cache and trigger parallel SQLite queries.
- **Solution**: Storing the `Future<CatalogFilterMetadata>` itself guarantees that all concurrent callers await the exact same in-flight task, eliminating redundant disk I/O.
- **Resilience**: If the initial query fails, `_metadataFuture` is reset to `null` so future attempts can retry.

### 5.3 Safe Table Name Resolution via `sqlite_master`

```dart
Future<String> _getExerciseTableName(Database db) async {
  if (_cachedExerciseTableName != null) return _cachedExerciseTableName!;
  final rows = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'",
  );
  _cachedExerciseTableName = rows.isNotEmpty ? 'exercise' : 'exercise_card';
  return _cachedExerciseTableName!;
}
```
- **Problem Prevented**: Broad `try/catch` blocks catch unexpected runtime errors (disk faults, database locks, malformed IDs) rather than cleanly checking table existence.
- **Solution**: Explicitly inspects `sqlite_master` once for table `'exercise'`, falls back to `'exercise_card'` if absent, and caches the resolved name for subsequent queries.

### 5.4 Tool Queries Returning DTOs from DataSource and Entities from Repository

In `CatalogLocalDataSourceImpl`:
```dart
@override
Future<ExercisesDatabaseResponse> getExercisesForTool({
  String? muscleGroup,
  String? difficulty,
  String? equipment,
  int limit = 8,
}) async {
  final db = await _exercisesDatabase.database;
  // Build parameterized WHERE clause...
  final results = await db.query(
    'exercise_card',
    columns: [
      'id',
      'name',
      'name_ar',
      'muscle_group AS muscle_group_id',
      'difficulty AS difficulty_id',
      'equipment AS primary_equipment_id',
      'body_region AS body_region_id',
      'mechanics',
    ],
    where: where.isEmpty ? null : where.join(' AND '),
    whereArgs: args,
    orderBy: 'popularity DESC, difficulty_rank ASC, name ASC',
    limit: limit,
  );
  return ExercisesDatabaseResponse.fromRows(results);
}
```

In `CatalogRepositoryImpl`:
```dart
@override
Future<List<ExerciseEntity>> getExercisesForTool({
  String? muscleGroup,
  String? difficulty,
  String? equipment,
  int limit = 8,
}) => _localDataSource
    .getExercisesForTool(
      muscleGroup: muscleGroup,
      difficulty: difficulty,
      equipment: equipment,
      limit: limit,
    )
    .then((r) => r.toEntity());
```
- **Clean Architecture Purity**: The data source produces strongly-typed DTOs (`ExercisesDatabaseResponse`, `MealsDatabaseResponse`), and the repository maps them to domain entities (`ExerciseEntity`, `MealEntity`).

---

## 6. Implementation Decisions & Trade-Offs

| Decision | Why It Was Chosen | Trade-Off / Alternative Considered |
| --- | --- | --- |
| **Typed Database Wrappers (`ExercisesDatabase`, `MealsDatabase`)** | Separates database connection management from query execution; removes testing constructors in data sources. | Requires two small wrapper classes registered in DI. |
| **Future-Based In-Memory Caching** | Prevents concurrent call race conditions while eliminating redundant disk I/O. | Storing `Future<T>` instead of raw `T` requires error handling to clear the cached future on failure. |
| **`sqlite_master` Introspection** | Explicitly determines table availability without suppressing genuine SQLite exceptions. | Minor initial query; cached in memory after first call. |
| **DTOs from DataSource -> Entities in Repository** | Follows strict Clean Architecture; data source never returns domain entities or raw Maps. | Requires extension mappers to map DTOs to entities. |
| **Removal of `catalog_debug_test.dart`** | Production codebases should not contain ad-hoc test scripts or debug routines in `lib/`. | Unit tests in `test/` provide robust, automated test coverage. |

---

## 7. Testing & Verification

1. **Data Source Unit Tests (`catalog_local_data_source_impl_test.dart`)**:
   - `getFilterMetadata` fetches distinct values and caches the Future preventing race conditions.
   - `getFilterMetadata` resets future cache on error allowing subsequent retries.
   - `getExercisesForTool` queries `exercise_card` and returns `ExercisesDatabaseResponse`.
   - `getExercisesForTool` handles filter criteria and custom limits.
   - `getMealsForTool` queries `meal_card` and returns `MealsDatabaseResponse`.
   - `getExercisesByIds` handles empty ID lists with fast-path early return.
   - `getExercisesByIds` checks `sqlite_master` and queries `exercise` table when present.
   - `getExercisesByIds` falls back to `exercise_card` when `exercise` table is absent.
   - `getMealsByIds` checks `sqlite_master` and queries `meal` table when present.
   - `getMealsByIds` falls back to `meal_card` when `meal` table is absent.
   - **Result: 11/11 tests passed in 5 seconds.**

2. **Repository Unit Tests (`catalog_repository_impl_test.dart`)**:
   - `getFilterMetadata` delegates to `CatalogLocalDataSource`.
   - `getExercisesForTool` delegates and maps `ExercisesDatabaseResponse` to `List<ExerciseEntity>`.
   - `getMealsForTool` delegates and maps `MealsDatabaseResponse` to `List<MealEntity>`.
   - `getExercisesByIds` maps response to `ExerciseEntity` list.
   - `getMealsByIds` maps response to `MealEntity` list.
   - **Result: 5/5 tests passed.**

3. **Static Analysis**: `flutter analyze` reports **0 issues found**.
4. **Full Test Suite**: `flutter test` reports **458/458 tests passing**.

---

## 8. Files Created / Modified

| File Path | Status | Description |
| --- | --- | --- |
| [`lib/core/database/exercises_database.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/exercises_database.dart) | Created | Typed singleton wrapper managing lazy connection to `exercises.db`. |
| [`lib/core/database/meals_database.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/core/database/meals_database.dart) | Created | Typed singleton wrapper managing lazy connection to `meals.db`. |
| [`lib/features/chat/domain/repository/catalog_repository.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/repository/catalog_repository.dart) | Modified | Updated tool methods to return `List<ExerciseEntity>` and `List<MealEntity>`. |
| [`lib/features/chat/data/datasource/local/catalog_local_data_source.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_local_data_source.dart) | Modified | Updated tool methods to return `ExercisesDatabaseResponse` and `MealsDatabaseResponse`. |
| [`lib/features/chat/data/datasource/local/catalog_local_data_source_impl.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_local_data_source_impl.dart) | Modified | Injected database wrappers, Future-cached metadata, DTO responses, and `sqlite_master` table checks. |
| [`lib/features/chat/data/repository/catalog_repository_impl.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/repository/catalog_repository_impl.dart) | Modified | Mapped tool query DTO responses to domain entities via `.then((r) => r.toEntity())`. |
| [`lib/features/chat/data/datasource/local/catalog_debug_test.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_debug_test.dart) | Deleted | Removed debug test runner script from production library. |
| [`lib/main.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/main.dart) | Modified | Removed `catalog_debug_test.dart` import and `debugTestCatalog()` invocation. |
| [`test/features/chat/data/datasource/local/catalog_local_data_source_impl_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/datasource/local/catalog_local_data_source_impl_test.dart) | Created | Comprehensive unit test suite covering all data source methods, caching, and fallback paths. |
| [`test/features/chat/data/repository/catalog_repository_impl_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/repository/catalog_repository_impl_test.dart) | Modified | Updated tests to verify tool queries returning mapped domain entities. |

---

## 9. Update History
- **2026-11-08** (`ali-hassan-ali32`): Implemented `CatalogLocalDataSource`, `CatalogRepository`, `CatalogRepositoryImpl`, corresponding unit tests, and comprehensive walkthrough documentation.
- **2026-11-08** (`ali-hassan-ali32`): Separated `CatalogLocalDataSource` into an abstract interface and concrete implementation (`CatalogLocalDataSourceImpl`), and added `debugPrint` diagnostics wrapped in `kDebugMode` for query testing.
- **2026-11-09** (`ali-hassan-ali32`): Decoupled `MealEntity` from SQLite specifics; introduced `meals_database_response_mapper.dart` and `exercises_database_response_mapper.dart`; aligned `CatalogLocalDataSource` and `CatalogRepositoryImpl` with the response-to-entity flow pattern of `MealsRepoImpl` (`.then((r) => r.toEntity())`); added comprehensive mapper and entity test suites with 100% test pass rate.
- **2026-11-09** (`ali-hassan-ali32`): Significantly expanded walkthrough documentation with deep technical code breakdowns, architectural flowcharts, annotated code snippets, step-by-step query pipelines, and trade-off rationales.
- **2026-11-09** (`ali-hassan-ali32`): Enhanced `MealEntity`, `DetailsMealEntity`, and `ExerciseEntity` with optional nullable extended fields from SQLite database DTOs, updating response mappers to populate all rich database attributes during entity conversion while maintaining full compatibility with remote API calls.
- **2026-11-10** (`ali-hassan-ali32`): Code review refactoring:
  1. Created typed singleton wrappers `ExercisesDatabase` and `MealsDatabase` (`@lazySingleton`) and injected them via DI into `CatalogLocalDataSourceImpl`, eliminating secondary testing constructors.
  2. Implemented Future-based caching (`_metadataFuture`) on `getFilterMetadata()` to prevent race conditions during concurrent calls.
  3. Refactored tool queries (`getExercisesForTool`, `getMealsForTool`) to return strongly-typed DTO responses from `CatalogLocalDataSource` and domain entities (`ExerciseEntity`, `MealEntity`) from `CatalogRepositoryImpl`.
  4. Replaced broad `try/catch` table checks with explicit `sqlite_master` introspection in `_getExerciseTableName` and `_getMealTableName`.
  5. Deleted `catalog_debug_test.dart` from `lib/` and removed debug test calls from `main.dart`.
  6. Added comprehensive unit tests in `catalog_local_data_source_impl_test.dart` and verified all 458 tests passing.
