# Domain Entities Setup — Comprehensive Walkthrough & Developer Guide

## 1. Overview & Conceptual Background

### 1.1 The Problem & Engineering Context
In Clean Architecture, **Entities** represent the purest core business models of the application. They reside inside the `domain/` layer and must remain completely decoupled from:
- Networking libraries (e.g., `dio`, `retrofit`, JSON serialization annotations).
- Database plugins (e.g., `sqflite`, SQLite column names).
- Presentation frameworks (e.g., Flutter widgets, `BuildContext`).

Prior to implementing the local SQLite catalog data sources and AI Chat messaging loop (Ollama Gemma 4 + Cloud Firestore), the domain models across the affected modules (`meals`, `exercise`, and `chat`) needed to be consolidated:
1. **`MealEntity`** existed in [`lib/features/meals/domain/entities/meal_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/meals/domain/entities/meal_entity.dart), but was designed solely for TheMealDB remote API, containing only `id`, `name`, `thumbnail`, `area`, and `country`. It lacked the nutritional and metadata attributes required by the SQLite database view (`meal_card`), such as `nameAr`, `category`, `kcal`, `proteinG`, `carbsG`, `fatG`, `vegetarian`, `vegan`, `containsGluten`, `youtube`, and `popularity`.
2. **`ExerciseEntity`** did not exist yet because the `exercise` feature was an empty scaffold. A domain entity mirroring the `exercise_card` SQLite view was required.
3. **`ChatMessageEntity`** and **`CatalogFilterMetadata`** were required by the `chat` module to hold conversational history and cached SQLite filter values (muscles, equipment, categories) for dynamic AI prompt injection.

### 1.2 The Solution
We harmonized the entities across their respective feature packages:
- Extended [`MealEntity`](file:///d:/ali/flutter_project/Fitness_App/lib/features/meals/domain/entities/meal_entity.dart) with all SQLite `meal_card` fields while preserving 100% backward compatibility with existing remote API mappers, Cubits, and 400+ unit tests.
- Created [`ExerciseEntity`](file:///d:/ali/flutter_project/Fitness_App/lib/features/exercise/domain/entities/exercise_entity.dart) under `features/exercise/domain/entities/`.
- Created [`ChatMessageEntity`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/chat_message_entity.dart) and [`CatalogFilterMetadata`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/catalog_filter_metadata.dart) under `features/chat/domain/entities/`.
- Unified catalog access via a barrel file [`catalog_entities.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/catalog_entities.dart) so upcoming chat data sources and use cases can import their catalog dependencies with a single clean import.

```
                   Clean Domain Entities Boundary
                   ==============================

  features/meals/                     features/exercise/
  └── domain/entities/                └── domain/entities/
      └── MealEntity (Updated)            └── ExerciseEntity (Created)
              │                                   │
              └───────────────┬───────────────────┘
                              │ Re-exported via
                              v
                      features/chat/
                      └── domain/entities/
                          ├── catalog_entities.dart (Barrel)
                          ├── catalog_filter_metadata.dart (Created)
                          └── chat_message_entity.dart (Created)
```

---

## 2. Status and Metadata
- **Status**: Completed
- **Module**: `chat` (with integration into `meals` and `exercise`)
- **Task**: `entities-setup`
- **Team Member**: `ali-hassan-ali32`
- **Started Date**: 2026-11-08
- **Completed Date**: 2026-11-08
- **Actual Branch Name**: `feature/chat-data-prepare`

---

## 3. Architecture & Layers

```
lib/
├── features/
│   ├── meals/
│   │   └── domain/
│   │       └── entities/
│   │           └── meal_entity.dart  <-- [Updated with SQLite & nutritional fields]
│   ├── exercise/
│   │   └── domain/
│   │       └── entities/
│   │           └── exercise_entity.dart  <-- [Created for exercise_card view]
│   └── chat/
│       └── domain/
│           └── entities/
│               ├── chat_message_entity.dart  <-- [Created for Firestore conversation messages]
│               ├── catalog_filter_metadata.dart  <-- [Created for dynamic LLM prompt metadata]
│               └── catalog_entities.dart  <-- [Catalog Barrel exporting MealEntity, ExerciseEntity, CatalogFilterMetadata]
```

### Clean Architecture Principles Observed:
- **Plain Dart & Equatable**: No JSON annotations or third-party serialization libraries exist in `domain/entities/`. Value equality is powered by `Equatable`.
- **Feature Ownership**: `MealEntity` is owned by `features/meals`, `ExerciseEntity` is owned by `features/exercise`, and chat-specific structures are owned by `features/chat`.
- **Barrel Unification**: `catalog_entities.dart` in `chat` bridges cross-feature catalog entities cleanly without polluting other modules.

---

## 4. Data Flow & Execution Steps

### 4.1 SQLite Row to Entity Mapping
When local database queries run in `CatalogLocalDataSource`:
1. `sqflite` queries return `List<Map<String, Object?>>`.
2. Each map represents a raw database row from the `exercise_card` or `meal_card` views.
3. The dedicated `fromRow` factory parses types defensively (e.g. `(r['kcal'] as num?)?.toDouble()`, `r['id'].toString()`).
4. An immutable, type-safe entity is produced and propagated up through the repository to the UI/Cubit layer.

### 4.2 Chat Conversation Flow
When chat turns execute:
1. `ChatMessageEntity` holds conversation turns with roles: `'system'`, `'user'`, `'assistant'`, or `'tool'`.
2. Output exercise and meal IDs chosen by the LLM are held in `exerciseIds` and `mealIds`.
3. Total tokens consumed during each turn are tracked via `tokensUsed`.

---

## 5. Important Classes, Methods & Code Breakdown

### 5.1 Updated [`MealEntity`](file:///d:/ali/flutter_project/Fitness_App/lib/features/meals/domain/entities/meal_entity.dart)
```dart
class MealEntity extends Equatable {
  final String id;
  final String name;
  final String thumbnail;
  final String? area;
  final String? country;

  // New SQLite & AI Chat properties from meal_card
  final String? nameAr;
  final String? category;
  final String? mealType;
  final double? kcal;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final bool? nutritionIsEstimate;
  final bool? vegetarian;
  final bool? vegan;
  final bool? containsGluten;
  final String? thumb;
  final String? youtube;
  final int? popularity;

  const MealEntity({
    required this.id,
    required this.name,
    this.thumbnail = '',
    this.area,
    this.country,
    this.nameAr,
    this.category,
    this.mealType,
    this.kcal,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.nutritionIsEstimate,
    this.vegetarian,
    this.vegan,
    this.containsGluten,
    this.thumb,
    this.youtube,
    this.popularity,
  });

  factory MealEntity.fromRow(Map<String, Object?> r) => MealEntity(
    id: r['id'].toString(),
    name: r['name'] as String,
    nameAr: r['name_ar'] as String?,
    category: r['category'] as String?,
    area: r['area'] as String?,
    mealType: r['meal_type'] as String?,
    kcal: (r['kcal'] as num?)?.toDouble(),
    proteinG: (r['protein_g'] as num?)?.toDouble(),
    carbsG: (r['carbs_g'] as num?)?.toDouble(),
    fatG: (r['fat_g'] as num?)?.toDouble(),
    nutritionIsEstimate: r['nutrition_is_estimate'] == 1 || r['nutrition_is_estimate'] == true,
    vegetarian: r['vegetarian'] == 1 || r['vegetarian'] == true,
    vegan: r['vegan'] == 1 || r['vegan'] == true,
    containsGluten: r['contains_gluten'] == 1 || r['contains_gluten'] == true,
    thumb: r['thumb'] as String?,
    thumbnail: (r['thumb'] as String?) ?? '',
    youtube: r['youtube'] as String?,
    popularity: (r['popularity'] as num?)?.toInt(),
  );
  ...
}
```
*Why `thumbnail` defaults to `''`*: Guarantees that callers only passing `thumb` (or constructing via `fromRow`) never trigger null pointer exceptions in existing UI widgets expecting a non-nullable `thumbnail`.

---

### 5.2 Created [`ExerciseEntity`](file:///d:/ali/flutter_project/Fitness_App/lib/features/exercise/domain/entities/exercise_entity.dart)
```dart
class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String? nameAr;
  final String? muscleGroup;
  final String? muscleGroupAr;
  final String? primeMover;
  final String? primeMoverAr;
  final String? difficulty;
  final int? difficultyRank;
  final String? equipment;
  final String? bodyRegion;
  final String? mechanics;
  final String? demoUrl;
  final String? explainUrl;
  final int? popularity;

  const ExerciseEntity({...});

  factory ExerciseEntity.fromRow(Map<String, Object?> r) => ExerciseEntity(
    id: r['id'] as String,
    name: r['name'] as String,
    nameAr: r['name_ar'] as String?,
    muscleGroup: r['muscle_group'] as String?,
    muscleGroupAr: r['muscle_group_ar'] as String?,
    primeMover: r['prime_mover'] as String?,
    primeMoverAr: r['prime_mover_ar'] as String?,
    difficulty: r['difficulty'] as String?,
    difficultyRank: (r['difficulty_rank'] as num?)?.toInt(),
    equipment: r['equipment'] as String?,
    bodyRegion: r['body_region'] as String?,
    mechanics: r['mechanics'] as String?,
    demoUrl: r['demo_url'] as String?,
    explainUrl: r['explain_url'] as String?,
    popularity: (r['popularity'] as num?)?.toInt(),
  );
  ...
}
```

---

### 5.3 Created [`ChatMessageEntity`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/chat_message_entity.dart)
```dart
class ChatMessageEntity extends Equatable {
  final String id;
  final String role; // 'system' | 'user' | 'assistant' | 'tool'
  final String content;
  final List<String> exerciseIds;
  final List<String> mealIds;
  final int tokensUsed;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    this.exerciseIds = const [],
    this.mealIds = const [],
    this.tokensUsed = 0,
    required this.createdAt,
  });
  ...
}
```

---

### 5.4 Created [`CatalogFilterMetadata`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/catalog_filter_metadata.dart)
```dart
class CatalogFilterMetadata extends Equatable {
  final List<String> muscleGroups;
  final List<String> difficulties;
  final List<String> equipments;
  final List<String> mealCategories;
  final List<String> mealAreas;

  const CatalogFilterMetadata({
    required this.muscleGroups,
    required this.difficulties,
    required this.equipments,
    required this.mealCategories,
    required this.mealAreas,
  });
  ...
}
```

---

### 5.5 Barrel File [`catalog_entities.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/catalog_entities.dart)
```dart
export 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
export 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
export 'catalog_filter_metadata.dart';
```

---

## 6. State Management
- **Status**: `Not applicable`
- Pure domain models with no direct state transitions.

---

## 7. UI Implementation & Interactions
- **Status**: `Not applicable`
- Consumed by future presentation widgets (e.g. `AssistantMessageBubble` cards).

---

## 8. Project Integration
- **`features/meals`**: Backward-compatible enhancement; all existing TheMealDB endpoints and screens (`details_food_view`, `meals_view`) remain fully operational.
- **`features/exercise`**: Established the initial domain model foundation for the exercise feature.
- **`features/chat`**: Prepares the exact entity contracts required by `CatalogLocalDataSource`, `ChatMessageDto`, and `SendMessageUseCase`.

---

## 9. Implementation Decisions & Trade-Offs

| Decision | Why It Was Chosen | Trade-Off / Alternative Considered |
| --- | --- | --- |
| **Enhancing existing `MealEntity` vs duplicate `ChatMealEntity`** | Unifies the meal concept across the app, avoiding duplicate models for the same business entity. | Requires preserving non-nullable `thumbnail` with default fallback to avoid breaking existing code. |
| **Placing `ExerciseEntity` in `features/exercise`** | Adheres to feature ownership and Clean Architecture conventions. | Required creating the `exercise/domain/entities/` folder hierarchy. |
| **`catalog_entities.dart` Barrel in `chat`** | Satisfies the architecture roadmap from the PDF where chat components import a single `catalog_entities.dart` file. | Exposes meals and exercise entities to chat via explicit exports. |
| **Defensive `fromRow` Type Casting** | Handles numeric values safely (`(r['kcal'] as num?)?.toDouble()`). | Slightly more verbose mapping, but prevents `int is not a subtype of double` SQLite runtime crashes. |

---

## 10. Testing & Verification

1. **Unit Testing**:
   - `test/features/meals/domain/entities/meal_entity_test.dart` (Tested value equality, props, and `fromRow` parsing).
   - `test/features/exercise/domain/entities/exercise_entity_test.dart` (Tested value equality, props, and `fromRow` parsing).
   - `test/features/chat/domain/entities/chat_entities_test.dart` (Tested `ChatMessageEntity` defaults and `CatalogFilterMetadata` equality).
   - Result: **All 6 entity tests passed**.
2. **Regression Testing**:
   - Ran full project test suite (`flutter test`): **All 415+ existing tests passed with zero failures**.
3. **Static Analysis**:
   - Ran `flutter analyze` on all affected files: **No issues found! (0 errors, 0 warnings)**.
4. **Formatting**:
   - Executed `dart format` across all new and updated files.

---

## 11. Dependencies
- **`equatable: ^2.1.0`**: Used for value equality without code generation.

---

## 12. Known Limitations & Edge Cases
- `MealEntity` now accommodates both TheMealDB properties (`thumbnail`, `country`) and local SQLite properties (`thumb`, `kcal`, `proteinG`). If a meal is fetched solely from TheMealDB, SQLite-specific nutritional fields will naturally be `null`.

---

## 13. Future Improvements & Next Steps
- Implement `ChatMessageDto` with Firestore `withConverter` and mapper to/from `ChatMessageEntity`.
- Implement `CatalogLocalDataSource` using `ExerciseEntity.fromRow` and `MealEntity.fromRow`.

---

## 14. Files Created / Modified

| File Path | Status | Description |
| --- | --- | --- |
| [`lib/features/meals/domain/entities/meal_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/meals/domain/entities/meal_entity.dart) | Modified | Added SQLite `meal_card` fields and `fromRow` factory while retaining backward compatibility. |
| [`lib/features/exercise/domain/entities/exercise_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/exercise/domain/entities/exercise_entity.dart) | Created | Domain model representing exercise catalog items and `fromRow` factory. |
| [`lib/features/chat/domain/entities/chat_message_entity.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/chat_message_entity.dart) | Created | Domain model representing a chat message turn with roles, token usage, and item IDs. |
| [`lib/features/chat/domain/entities/catalog_filter_metadata.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/catalog_filter_metadata.dart) | Created | Domain model holding distinct filter options for dynamic LLM prompt generation. |
| [`lib/features/chat/domain/entities/catalog_entities.dart`](file:///d:/ali/flutter_project/Fitness_App/lib/features/chat/domain/entities/catalog_entities.dart) | Created | Catalog barrel exporting `ExerciseEntity`, `MealEntity`, and `CatalogFilterMetadata`. |
| [`test/features/meals/domain/entities/meal_entity_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/meals/domain/entities/meal_entity_test.dart) | Created | Unit test for updated `MealEntity`. |
| [`test/features/exercise/domain/entities/exercise_entity_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/exercise/domain/entities/exercise_entity_test.dart) | Created | Unit test for `ExerciseEntity`. |
| [`test/features/chat/domain/entities/chat_entities_test.dart`](file:///d:/ali/flutter_project/Fitness_App/test/features/chat/domain/entities/chat_entities_test.dart) | Created | Unit test for `ChatMessageEntity` and `CatalogFilterMetadata`. |
| [`.docs/walkthroughs/chat/entities-setup/feature-chat-data-prepare/entities-setup-walkthrough.md`](file:///d:/ali/flutter_project/Fitness_App/.docs/walkthroughs/chat/entities-setup/feature-chat-data-prepare/entities-setup-walkthrough.md) | Created | Detailed task walkthrough and developer guide. |

---

## 15. Git References
- **Branch**: `feature/chat-data-prepare`
- **Related Commit Hashes**: `Not available (uncommitted working tree)`
- **PR URL**: `Not available`

---

## 16. Update History
- **2026-11-08** (`ali-hassan-ali32`): Initial implementation of domain entities across `meals`, `exercise`, and `chat`, corresponding unit tests, and comprehensive walkthrough documentation.
