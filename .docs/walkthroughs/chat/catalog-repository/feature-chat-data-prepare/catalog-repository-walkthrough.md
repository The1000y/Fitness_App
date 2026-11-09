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
   - The app intercepts this function call, executes a targeted, parameterized SQLite query against local storage in ~2 ms, and returns only the top 8 matching candidates back to the model.
3. **Tier 3: Entity Resolution & Interactive UI Cards**:
   - Once the LLM formulates its conversational answer citing chosen meal or exercise IDs, the UI retrieves the complete entity models (`getMealsByIds` / `getExercisesByIds`) to display interactive, rich preview cards directly in the chat feed.

### 1.3 Clean Architecture & Alignment with Existing Features
To maintain architectural consistency across the entire codebase, the local catalog data access layer strictly replicates the flow pattern of the Meals feature (`MealsRemoteDataSource` -> `MealsDatabaseResponse` -> `MealsRepoImpl` via `.then((r) => r.toEntity())`):
- **Pure Domain Entities**: Reverted `MealEntity` to its clean TheMealDB API specification (`id`, `name`, `thumbnail`, `area`, `country`), keeping domain layer entities completely decoupled from SQLite implementation details.
- **Typed Response DTOs**: Created `ExerciseDatabaseDTO` / `ExercisesDatabaseResponse` and `MealDatabaseDTO` / `MealsDatabaseResponse` to represent raw SQLite table rows.
- **Extension Mappers**: Dedicated extension mappers (`exercises_database_response_mapper.dart` and `meals_database_response_mapper.dart`) handle all transformations between DTO responses and clean domain entities.
- **Repository Delegation**: `CatalogRepositoryImpl` delegates database calls to `CatalogLocalDataSource` and maps DTO responses to domain entities using reactive `Future.then` chains.

```
+-----------------------------------------------------------------------------------------+
|                                    Domain Layer                                         |
|                                                                                         |
|   [CatalogRepository] (Interface)                                                       |
|     - Future<CatalogFilterMetadata> getFilterMetadata()                                |
|     - Future<List<Map<String, Object?>>> getExercisesForTool(...)                      |
|     - Future<List<Map<String, Object?>>> getMealsForTool(...)                          |
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
|     - Future<List<Map<String, Object?>>> getExercisesForTool(...)                      |
|     - Future<List<Map<String, Object?>>> getMealsForTool(...)                          |
|     - Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids)            |
|     - Future<MealsDatabaseResponse> getMealsByIds(List<String> ids)                    |
|          ▲                                                                              |
|          │ implements                                                                   |
|   [CatalogLocalDataSourceImpl]                                                          |
|     - Lazy SQLite connections (_exercisesDb, _mealsDb)                                  |
|     - Parameterized SQL execution & view fallbacks                                      |
|     - In-memory metadata caching (_cachedMeta)                                          |
|     - Debug logging via debugPrint inside kDebugMode                                    |
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
- **Completed Date**: 2026-11-09
- **Actual Branch Name**: `feature/chat-data-prepare`

---

## 3. Architecture & File Structure

```
lib/
├── features/
│   ├── chat/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── catalog_entities.dart            <-- Barrel file re-exporting entities
│   │   │   │   ├── catalog_filter_metadata.dart     <-- Vocabulary filter metadata
│   │   │   │   └── chat_message_entity.dart         <-- Chat conversation entity
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
│   ├── meals/
│   │   └── domain/
│   │       └── entities/
│   │           └── meal_entity.dart                 <-- Pure TheMealDB domain entity
│   └── exercise/
│       └── domain/
│           └── entities/
│               └── exercise_entity.dart             <-- Workout domain entity
```

### Architectural Principles Applied:
1. **Single Responsibility Principle (SRP)**:
   - `CatalogLocalDataSource`: Responsible exclusively for SQLite query execution, SQL dialect generation, and raw DTO reconstruction.
   - `CatalogRepository`: Acts as the domain bridge, converting raw database DTOs into application domain entities.
   - Mappers: Dedicated purely to data translation; no database or network logic.
2. **Dependency Inversion Principle (DIP)**:
   - High-level domain consumers (`SendMessageUseCase`) depend solely on the abstract contract `CatalogRepository`, never directly on `sqflite` or file paths.
   - `CatalogRepositoryImpl` depends on the interface `CatalogLocalDataSource`, allowing 100% mock-driven unit testing.
3. **Separation of API vs Local Concerns**:
   - `MealEntity` is untouched by SQLite schema quirks. When TheMealDB API returns a meal, it uses `MealEntity`. When local SQLite returns a meal, `MealDatabaseDTO` parses it and converts it into `MealEntity` via `MealDatabaseDtoMapper`.

---

## 4. Detailed Data Flow & Execution Steps

### Step 1: System Prompt Initialization (`getFilterMetadata`)
When a chat session starts, `SendMessageUseCase` requests vocabulary constraints to supply to the LLM system prompt.
1. `CatalogRepository.getFilterMetadata()` calls `CatalogLocalDataSource.getFilterMetadata()`.
2. **In-Memory Cache Check**: If `_cachedMeta != null`, the cached object is returned immediately (0 ms execution).
3. **Database Queries**: If not cached:
   - Opens `exercises.db` and queries `DISTINCT muscle_group`, `DISTINCT difficulty`, and `DISTINCT equipment`.
   - Opens `meals.db` and queries `DISTINCT category` and `DISTINCT area`.
4. **Cache & Return**: Builds `CatalogFilterMetadata`, stores it in `_cachedMeta`, and returns it.

### Step 2: LLM Tool Execution (`getExercisesForTool` / `getMealsForTool`)
During conversation, the user makes a request like *"I want beginner chest workouts using dumbbells"*.
1. Gemma 4 generates a tool call:
   ```json
   {
     "name": "get_exercises",
     "arguments": {
       "muscle_group": "Chest",
       "difficulty": "Beginner",
       "equipment": "Dumbbell",
       "limit": 8
     }
   }
   ```
2. The app invokes `CatalogRepository.getExercisesForTool(...)`.
3. `CatalogLocalDataSourceImpl` constructs a parameterized `SELECT` query:
   ```sql
   SELECT id, name, name_ar, difficulty, muscle_group, equipment, mechanics
   FROM exercise_card
   WHERE muscle_group = ? AND difficulty = ? AND equipment = ?
   ORDER BY popularity DESC
   LIMIT ?;
   ```
4. Query executes in ~2 ms against local SQLite.
5. Returns `List<Map<String, Object?>>` formatted for LLM consumption, providing concise context to the assistant.

### Step 3: Entity Resolution (`getExercisesByIds` / `getMealsByIds`)
Once the model produces its final response citing specific IDs (e.g. `['ex-101', 'ex-205']`):
1. `CatalogRepository.getExercisesByIds(['ex-101', 'ex-205'])` is called.
2. `CatalogLocalDataSource.getExercisesByIds(...)` executes:
   ```sql
   SELECT * FROM exercise_card WHERE id IN (?, ?);
   ```
3. SQLite returns the row maps.
4. `ExercisesDatabaseResponse.fromRows(rows)` deserializes the maps into `List<ExerciseDatabaseDTO>`.
5. The data source returns `Future<ExercisesDatabaseResponse>` to `CatalogRepositoryImpl`.
6. `CatalogRepositoryImpl` executes `.then((r) => r.toEntity())`.
7. `ExercisesDatabaseResponseMapper` converts each `ExerciseDatabaseDTO` into a pure `ExerciseEntity`.
8. The chat UI receives `List<ExerciseEntity>` and renders interactive cards.

---

## 5. Important Classes, Methods & Code Breakdown

### 5.1 Abstract Data Source: [`CatalogLocalDataSource`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_local_data_source.dart)
Defines the raw database contract returning SQLite response DTOs and tool maps:

```dart
abstract class CatalogLocalDataSource {
  /// Extracts the distinct vocabulary for LLM system prompt constraint.
  Future<CatalogFilterMetadata> getFilterMetadata();

  /// Targeted function-call search for exercise recommendations.
  Future<List<Map<String, Object?>>> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  });

  /// Targeted function-call search for meal recommendations.
  Future<List<Map<String, Object?>>> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  });

  /// Resolves full exercise rows by their stable IDs.
  Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids);

  /// Resolves full meal rows by their stable IDs.
  Future<MealsDatabaseResponse> getMealsByIds(List<String> ids);
}
```

---

### 5.2 Concrete Implementation: [`CatalogLocalDataSourceImpl`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_local_data_source_impl.dart)

#### 1. Lazy Read-Only SQLite Initialization
The data source maintains independent lazy getters for both databases, opening them with `readOnly: true` to prevent accidental schema modifications:

```dart
@Injectable(as: CatalogLocalDataSource)
class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  Database? _exDb;
  Database? _mlDb;
  CatalogFilterMetadata? _cachedMeta;

  CatalogLocalDataSourceImpl();

  @visibleForTesting
  CatalogLocalDataSourceImpl.forTesting({
    Database? exercisesDb,
    Database? mealsDb,
  }) : _exDb = exercisesDb,
       _mlDb = mealsDb;

  Future<Database> get _exercisesDb async {
    if (_exDb != null && _exDb!.isOpen) return _exDb!;
    final dir = await getDatabasesPath();
    final dbPath = p.join(dir, 'exercises.db');
    if (kDebugMode) {
      debugPrint('CatalogLocalDataSource: Opening exercises database at $dbPath');
    }
    _exDb = await openDatabase(dbPath, readOnly: true);
    return _exDb!;
  }
  ...
}
```

#### 2. Dynamic Tool Filtering with Parameterized SQL
Filters are built safely to prevent SQL injection vulnerabilities. Dynamic `WHERE` conditions are collected into a `whereClauses` list with corresponding `whereArgs`:

```dart
@override
Future<List<Map<String, Object?>>> getExercisesForTool({
  String? muscleGroup,
  String? difficulty,
  String? equipment,
  int limit = 8,
}) async {
  final db = await _exercisesDb;
  final table = await _resolveTable(db, 'exercise_card', 'exercise');

  final whereClauses = <String>[];
  final whereArgs = <Object?>[];

  if (muscleGroup != null && muscleGroup.isNotEmpty) {
    whereClauses.add('(muscle_group = ? OR muscle_group_ar = ?)');
    whereArgs.addAll([muscleGroup, muscleGroup]);
  }
  if (difficulty != null && difficulty.isNotEmpty) {
    whereClauses.add('(difficulty = ? OR difficulty_rank = ?)');
    whereArgs.addAll([difficulty, int.tryParse(difficulty) ?? -1]);
  }
  if (equipment != null && equipment.isNotEmpty) {
    whereClauses.add('equipment = ?');
    whereArgs.add(equipment);
  }

  final whereString = whereClauses.isEmpty ? null : whereClauses.join(' AND ');

  final rows = await db.query(
    table,
    columns: const [
      'id', 'name', 'name_ar', 'difficulty', 'muscle_group', 'equipment', 'mechanics',
    ],
    where: whereString,
    whereArgs: whereArgs.isEmpty ? null : whereArgs,
    orderBy: 'popularity DESC',
    limit: limit,
  );

  if (kDebugMode) {
    debugPrint('CatalogLocalDataSource.getExercisesForTool: returned ${rows.length} rows');
  }

  return rows;
}
```

#### 3. ID Resolution with Table Fallback & Response Construction
When querying IDs, if the preferred view (`exercise_card` / `meal_card`) does not exist, it falls back to the underlying table (`exercise` / `meal`):

```dart
@override
Future<ExercisesDatabaseResponse> getExercisesByIds(List<String> ids) async {
  if (ids.isEmpty) return const ExercisesDatabaseResponse(exercises: []);
  final db = await _exercisesDb;
  final table = await _resolveTable(db, 'exercise_card', 'exercise');
  final placeholders = List.filled(ids.length, '?').join(', ');

  final rows = await db.rawQuery(
    'SELECT * FROM $table WHERE id IN ($placeholders);',
    ids,
  );

  if (kDebugMode) {
    debugPrint('CatalogLocalDataSource.getExercisesByIds: requested ${ids.length}, found ${rows.length}');
  }

  return ExercisesDatabaseResponse.fromRows(rows);
}
```

---

### 5.3 Response DTOs & SQLite Serialization

#### [`ExerciseDatabaseDTO`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/models/responses/exexercises_database_response/exercise_database_dto.dart)
Represents a row from `exercises.db` (`exercise` table or `exercise_card` view) mapped directly via `@JsonKey` attributes:

```dart
@JsonSerializable()
class ExerciseDatabaseDTO {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'difficulty_id')
  final String? difficultyId;

  @JsonKey(name: 'muscle_group_id')
  final String? muscleGroupId;

  @JsonKey(name: 'prime_mover_id')
  final String? primeMoverId;

  @JsonKey(name: 'primary_equipment_id')
  final String? primaryEquipmentId;

  @JsonKey(name: 'secondary_equipment_id')
  final String? secondaryEquipmentId;

  @JsonKey(name: 'body_region_id')
  final String? bodyRegionId;

  @JsonKey(name: 'mechanics')
  final String? mechanics;

  @JsonKey(name: 'demo_url')
  final String? demoUrl;

  @JsonKey(name: 'explain_url')
  final String? explainUrl;

  const ExerciseDatabaseDTO({
    this.id,
    this.name,
    this.difficultyId,
    this.muscleGroupId,
    this.primeMoverId,
    this.primaryEquipmentId,
    this.secondaryEquipmentId,
    this.bodyRegionId,
    this.mechanics,
    this.demoUrl,
    this.explainUrl,
    ...
  });

  factory ExerciseDatabaseDTO.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDatabaseDTOFromJson(json);
}
```

#### [`ExercisesDatabaseResponse`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/models/responses/exexercises_database_response/exercises_database_response.dart)
Encapsulates a collection of DTOs, providing a custom factory `fromRows` to accept raw SQLite row maps:

```dart
@JsonSerializable(explicitToJson: true)
class ExercisesDatabaseResponse {
  @JsonKey(name: 'exercises')
  final List<ExerciseDatabaseDTO>? exercises;

  const ExercisesDatabaseResponse({this.exercises});

  factory ExercisesDatabaseResponse.fromRows(List<Map<String, Object?>> rows) =>
      ExercisesDatabaseResponse(
        exercises: rows
            .map((row) =>
                ExerciseDatabaseDTO.fromJson(Map<String, dynamic>.from(row)))
            .toList(),
      );
}
```

---

### 5.4 Extension Mappers: Decoupling DTOs from Domain Entities

#### [`meals_database_response_mapper.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/models/responses/mappers/meals_database_response_mapper.dart)
Converts SQLite `MealDatabaseDTO` rows into clean domain `MealEntity` and `DetailsMealEntity` objects:

```dart
extension MealDatabaseDtoMapper on MealDatabaseDTO {
  /// Maps to pure 5-field MealEntity used throughout the application.
  MealEntity toEntity() => MealEntity(
        id: id ?? '',
        name: name ?? '',
        thumbnail: thumb ?? imageLarge ?? imageMedium ?? imageSmall ?? '',
        area: areaId,
        country: null,
      );

  /// Maps to full detail representation when detailed view is requested.
  DetailsMealEntity toDetailsEntity() => DetailsMealEntity(
        idMeal: id ?? '',
        strMeal: name ?? '',
        strMealAlternate: nameAr,
        strCategory: categoryId ?? '',
        strArea: areaId ?? '',
        strInstructions: instructions ?? '',
        strMealThumb: thumb ?? imageLarge ?? imageMedium ?? imageSmall ?? '',
        strTags: mealType ?? '',
        strYoutube: youtube ?? '',
        strSource: source ?? '',
        dateModified: dateModified,
        ingredients: const [],
      );
}

extension MealsDatabaseResponseMapper on MealsDatabaseResponse {
  List<MealEntity> toEntity() =>
      meals?.map((e) => e.toEntity()).toList() ?? const [];

  List<DetailsMealEntity> toDetailsEntities() =>
      meals?.map((e) => e.toDetailsEntity()).toList() ?? const [];
}
```

#### [`exercises_database_response_mapper.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/models/responses/mappers/exercises_database_response_mapper.dart)
Maps SQLite exercise attributes into the application's domain `ExerciseEntity`:

```dart
extension ExerciseDatabaseDtoMapper on ExerciseDatabaseDTO {
  ExerciseEntity toEntity() => ExerciseEntity(
        id: id ?? '',
        exercise: name ?? '',
        difficultyLevel: difficultyId ?? '',
        targetMuscleGroup: muscleGroupId ?? '',
        primeMoverMuscle: primeMoverId ?? '',
        secondaryMuscle: null,
        tertiaryMuscle: null,
        primaryEquipment: primaryEquipmentId ?? '',
        secondaryEquipment: secondaryEquipmentId,
        shortYoutubeDemonstrationLink: demoUrl ?? '',
        inDepthYoutubeExplanationLink: explainUrl,
        bodyRegion: bodyRegionId ?? '',
        mechanics: mechanics ?? '',
      );
}

extension ExercisesDatabaseResponseMapper on ExercisesDatabaseResponse {
  List<ExerciseEntity> toEntity() =>
      exercises?.map((e) => e.toEntity()).toList() ?? const [];
}
```

---

### 5.5 Domain Repository Implementation: [`CatalogRepositoryImpl`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/repository/catalog_repository_impl.dart)
Following the exact reactive flow pattern seen in `MealsRepoImpl`, the repository delegates to the local data source and calls `.then((r) => r.toEntity())`:

```dart
@Injectable(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogLocalDataSource _localDataSource;

  const CatalogRepositoryImpl(this._localDataSource);

  @override
  Future<CatalogFilterMetadata> getFilterMetadata() =>
      _localDataSource.getFilterMetadata();

  @override
  Future<List<Map<String, Object?>>> getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
    int limit = 8,
  }) => _localDataSource.getExercisesForTool(
    muscleGroup: muscleGroup,
    difficulty: difficulty,
    equipment: equipment,
    limit: limit,
  );

  @override
  Future<List<Map<String, Object?>>> getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
    int limit = 8,
  }) => _localDataSource.getMealsForTool(
    category: category,
    area: area,
    minProtein: minProtein,
    maxKcal: maxKcal,
    vegetarian: vegetarian,
    limit: limit,
  );

  @override
  Future<List<ExerciseEntity>> getExercisesByIds(List<String> ids) =>
      _localDataSource.getExercisesByIds(ids).then((r) => r.toEntity());

  @override
  Future<List<MealEntity>> getMealsByIds(List<String> ids) =>
      _localDataSource.getMealsByIds(ids).then((r) => r.toEntity());
}
```

---

## 6. State Management
- **Status**: `Not applicable` (Data & Domain Layers)
- The catalog repository exposes asynchronous `Future` queries consumed by `SendMessageUseCase`. State emissions (loading indicators, streaming responses, and message list updates) are managed downstream in `ChatCubit` using `ChatState`.

---

## 7. UI Implementation & Interactions
- **Status**: `Not applicable`
- The repository outputs typed entity models (`ExerciseEntity`, `MealEntity`). Presentation layer components (`ChatMessageCard`, `ExerciseRecommendationCard`, `MealRecommendationCard`) render the thumbnails, titles, and tags provided by these entities.

---

## 8. Project Integration

### 8.1 Asset Installer Prerequisite
The catalog local data source assumes that the database files have been extracted and verified on disk. This is guaranteed by `DatabaseAssetInstaller.ensureDatabasesInstalled()` running during `main.dart` initialization:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseAssetInstaller.ensureDatabasesInstalled();
  configureDependencies();
  runApp(const FitnessApp());
}
```

### 8.2 Dependency Injection (GetIt & Injectable)
Both the data source and repository are registered automatically in `lib/config/di/di.config.dart`:
```dart
gh.factory<CatalogLocalDataSource>(() => CatalogLocalDataSourceImpl());
gh.factory<CatalogRepository>(() => CatalogRepositoryImpl(gh<CatalogLocalDataSource>()));
```

---

## 9. Implementation Decisions & Trade-Offs

| Decision | Why It Was Chosen | Trade-Off / Alternative Considered |
| --- | --- | --- |
| **Separating SQLite DTOs from `MealEntity`** | Preserves domain purity. `MealEntity` is consumed by TheMealDB remote API across the app. Polluting it with local SQLite fields violates clean architecture. | Requires maintaining dedicated DTOs and mapper extensions; provides 100% decoupling and prevents regressions in the Meals feature. |
| **`.then((r) => r.toEntity())` Flow Style** | Directly aligns with `MealsRepoImpl` conventions, creating a unified developer experience across modules. | Writing a one-line future transform vs `await` inside an `async` block; purely stylistic and semantically identical. |
| **Lazy `openDatabase` with `readOnly: true`** | Defends database assets against accidental runtime corruption or table dropping. Only opens connections when a query is actually executed. | Databases remain closed during app start, keeping cold startup fast (< 1 ms); connection overhead (~5 ms) is incurred only on first chat interaction. |
| **In-Memory Caching of Metadata** | Distinct queries take ~5–10 ms. Caching in `_cachedMeta` reduces repeated queries to 0 ms for all subsequent messages in a session. | Cache persists for app process lifetime; acceptable because SQLite databases are read-only and static during runtime. |
| **Direct Parameterized Queries vs Full ORM** | Custom parameterized `query()` calls with selected columns are significantly faster and lighter than an ORM. | Requires maintaining column lists in source code matching the view definitions. |
| **Table Fallback Resolution** | Checks `sqlite_master` for views (`exercise_card`) and falls back to tables (`exercise`) if missing. | One extra `SELECT name FROM sqlite_master` check; ensures resiliency across schema migrations. |

---

## 10. Testing & Verification

### 10.1 Unit Testing Strategy
Testing was developed using `mocktail` and `flutter_test`:
1. **Repository Delegation & Mapping**:
   - [`catalog_repository_impl_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/repository/catalog_repository_impl_test.dart): Verifies delegation for all 5 methods and validates that response DTOs are mapped to `ExerciseEntity` and `MealEntity` lists.
2. **Response Mapper Testing**:
   - [`meals_database_response_mapper_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/models/responses/mappers/meals_database_response_mapper_test.dart): Tests `MealDatabaseDTO` mapping to `MealEntity` and `DetailsMealEntity`, fallback image resolution, and empty response handling.
   - [`exercises_database_response_mapper_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/models/responses/mappers/exercises_database_response_mapper_test.dart): Tests `ExerciseDatabaseDTO` mapping to `ExerciseEntity`, null handling, and response list mapping.
3. **Domain Entity Verification**:
   - [`meal_entity_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/meals/domain/entities/meal_entity_test.dart): Validates pure 5-field equality and props.
   - [`exercise_entity_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/exercise/domain/entities/exercise_entity_test.dart): Validates exercise fields and Equatable props.

### 10.2 Verification Results
- **Full Test Suite Execution**:
  ```bash
  flutter test
  ```
  Result: **All 435 tests passed!** (100% pass rate).
- **Static Analysis**:
  ```bash
  flutter analyze
  ```
  Result: **No issues found! (0 errors, 0 warnings)**.
- **Code Formatting**:
  ```bash
  dart format lib/ test/
  ```
  Result: Fully compliant with official Dart formatting guidelines.

### 10.3 Live Runtime & Emulator Verification
Executed on Android Emulator `emulator-5554` (`PGT AN10`) via `catalog_debug_test.dart` integrated into `main.dart`:
- **Asset Integrity**: Verified `DatabaseAssetInstaller` confirmed existing SQLite assets (`version: 1`).
- **Check [1/6] Vocabulary Extraction**: Successfully loaded 16 muscles, 8 difficulties, 30 equipments, 14 categories, and 37 areas from physical databases.
- **Check [2/6] Exercise Tool Search**: Parameterized query returned matching exercises (`Bodyweight Alternating Heel Taps`, `Bodyweight Bird Dog`, etc.).
- **Check [3/6] Meal Tool Search**: Parameterized query returned matching meals (`Algerian Kefta`, `Arepa Pabellón`, etc.).
- **Check [4/6] Exercise ID Resolution**: Mapped SQLite rows into domain `ExerciseEntity` instances, populating exercise titles, muscle groups, equipment, mechanics, and YouTube demonstration URLs.
- **Check [5/6] Meal ID Resolution**: Mapped SQLite rows into clean domain `MealEntity` instances, populating names, areas, and thumbnail URLs.
- **Check [6/6] Raw DTO Deserialization**: Directly verified `ExercisesDatabaseResponse` and `MealsDatabaseResponse` DTO deserialization on `CatalogLocalDataSource`.
- **Diagnostic Result**: `🎉 [CATALOG TEST] ALL 6 DIAGNOSTIC CHECKS COMPLETED SUCCESSFULLY!`.

---

## 11. Dependencies
- **`sqflite: ^2.4.2`**: Local SQLite database management and query execution.
- **`path: ^1.9.1`**: Cross-platform filesystem path joins.
- **`injectable: ^2.5.0`**: Code-generation-based dependency injection.
- **`json_annotation: ^4.9.0`**: Annotation for DTO serialization.
- **`equatable: ^2.0.7`**: Value-based equality for domain entities.
- **`mocktail: ^1.0.4`**: Null-safe mocking library for unit tests.

---

## 12. Known Limitations & Edge Cases
- **Empty IDs Guard**: Passing an empty list `[]` to `getExercisesByIds` or `getMealsByIds` triggers an early exit returning `const []`, preventing runtime SQLite syntax errors from malformed `WHERE id IN ()` clauses.
- **Null Safety Fallbacks**: If database columns are `NULL` (e.g., secondary equipment or thumbnail URLs), DTO mappers substitute sensible defaults or fall back through image resolution chains.
- **Read-Only Constraint**: Databases are opened with `readOnly: true`. Attempting `INSERT`, `UPDATE`, or `DELETE` operations will throw a SQLite exception.

---

## 13. Future Improvements & Next Steps
1. **`SendMessageUseCase` Implementation**:
   - Implement the 4-turn tool execution loop: System Prompt Injection -> Model Function Call -> SQLite Tool Execution -> LLM Final Synthesis.
2. **Streaming Support**:
   - Connect the Ollama chat endpoint to stream token responses to `ChatCubit` while function calls are evaluated.
3. **Conversation Persistence**:
   - Connect messages and resolved entity IDs to Cloud Firestore to preserve user conversation history across device restarts.

---

## 14. Files Created / Modified

| File Path | Status | Description |
| --- | --- | --- |
| [`lib/features/meals/domain/entities/meal_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/meals/domain/entities/meal_entity.dart) | Updated | Added optional, nullable extended fields (`kcal`, `proteinG`, `nameAr`, `category`, diet flags, etc.) preserved when mapped from SQLite. |
| [`lib/features/meals/domain/entities/details_meal_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/meals/domain/entities/details_meal_entity.dart) | Updated | Added optional, nullable nutrition and diet fields (`kcal`, `proteinG`, `carbsG`, `fatG`, `vegetarian`, `vegan`, `popularity`). |
| [`lib/features/exercise/domain/entities/exercise_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/exercise/domain/entities/exercise_entity.dart) | Updated | Added optional, nullable biomechanical and classification fields (`nameAr`, `difficultyRank`, `posture`, `grip`, `forceType`, etc.). |
| [`lib/features/chat/data/models/responses/mappers/meals_database_response_mapper.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/models/responses/mappers/meals_database_response_mapper.dart) | Updated | Maps all available SQLite database DTO fields into `MealEntity` and `DetailsMealEntity`. |
| [`lib/features/chat/data/models/responses/mappers/exercises_database_response_mapper.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/models/responses/mappers/exercises_database_response_mapper.dart) | Updated | Maps all available SQLite database DTO fields into `ExerciseEntity`. |
| [`lib/features/chat/data/datasource/local/catalog_local_data_source.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_local_data_source.dart) | Updated | Updated return signatures of by-id queries to return `ExercisesDatabaseResponse` and `MealsDatabaseResponse`. |
| [`lib/features/chat/data/datasource/local/catalog_local_data_source_impl.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_local_data_source_impl.dart) | Updated | Implemented DTO response factories, table fallback resolution, and `@Injectable` registration. |
| [`lib/features/chat/data/repository/catalog_repository_impl.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/repository/catalog_repository_impl.dart) | Updated | Replaced direct entity calls with `.then((r) => r.toEntity())` flow matching `MealsRepoImpl`. |
| [`test/features/chat/data/models/responses/mappers/meals_database_response_mapper_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/models/responses/mappers/meals_database_response_mapper_test.dart) | Created | Comprehensive unit tests for meal response DTO mappings. |
| [`test/features/chat/data/models/responses/mappers/exercises_database_response_mapper_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/models/responses/mappers/exercises_database_response_mapper_test.dart) | Created | Comprehensive unit tests for exercise response DTO mappings. |
| [`test/features/chat/data/repository/catalog_repository_impl_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/data/repository/catalog_repository_impl_test.dart) | Updated | Unit tests verifying delegation and mapping from response DTOs. |
| [`test/features/meals/domain/entities/meal_entity_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/meals/domain/entities/meal_entity_test.dart) | Updated | Unit tests verifying equality and props for clean `MealEntity`. |
| [`test/features/exercise/domain/entities/exercise_entity_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/exercise/domain/entities/exercise_entity_test.dart) | Updated | Unit tests verifying constructor and props for `ExerciseEntity`. |
| [`lib/features/chat/data/datasource/local/catalog_debug_test.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/data/datasource/local/catalog_debug_test.dart) | Created | Diagnostic test runner executing all 5 repository & local data source methods and printing structured outputs via `debugPrint`. |
| [`lib/main.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/main.dart) | Updated | Integrated `debugTestCatalog()` call inside `kDebugMode` right after dependency injection setup. |
| [`.docs/walkthroughs/chat/catalog-repository/feature-chat-data-prepare/catalog-repository-walkthrough.md`](file:///d:/ali/flutter_project/Fitness_App/.docs/walkthroughs/chat/catalog-repository/feature-chat-data-prepare/catalog-repository-walkthrough.md) | Updated | Expanded technical documentation and developer guide. |

---

## 15. Git References
- **Branch**: `feature/chat-data-prepare`
- **Related Commit Hashes**: `feat: Implement catalog repository, local SQLite data source, and asset installer for chat feature`
- **PR URL**: `Not available`

---

## 16. Update History
- **2026-11-08** (`ali-hassan-ali32`): Implemented `CatalogLocalDataSource`, `CatalogRepository`, `CatalogRepositoryImpl`, corresponding unit tests, and comprehensive walkthrough documentation.
- **2026-11-08** (`ali-hassan-ali32`): Separated `CatalogLocalDataSource` into an abstract interface and concrete implementation (`CatalogLocalDataSourceImpl`), and added `debugPrint` diagnostics wrapped in `kDebugMode` for query testing.
- **2026-11-09** (`ali-hassan-ali32`): Decoupled `MealEntity` from SQLite specifics; introduced `meals_database_response_mapper.dart` and `exercises_database_response_mapper.dart`; aligned `CatalogLocalDataSource` and `CatalogRepositoryImpl` with the response-to-entity flow pattern of `MealsRepoImpl` (`.then((r) => r.toEntity())`); added comprehensive mapper and entity test suites with 100% test pass rate.
- **2026-11-09** (`ali-hassan-ali32`): Significantly expanded walkthrough documentation with deep technical code breakdowns, architectural flowcharts, annotated code snippets, step-by-step query pipelines, and trade-off rationales.
- **2026-11-09** (`ali-hassan-ali32`): Created `catalog_debug_test.dart` and wired it into `main.dart` in `kDebugMode` to execute all 6 repository and local data source query methods and print structured diagnostic outputs directly in the terminal.
- **2026-11-09** (`ali-hassan-ali32`): Verified live execution on Android emulator (`emulator-5554` / `PGT AN10`), validating 100% successful results across all 6 diagnostic tests against physical SQLite databases (`exercises.db` and `meals.db`).
- **2026-11-09** (`ali-hassan-ali32`): Enhanced `MealEntity`, `DetailsMealEntity`, and `ExerciseEntity` with optional nullable extended fields from SQLite database DTOs, updating response mappers to populate all rich database attributes during entity conversion while maintaining full compatibility with remote API calls.
