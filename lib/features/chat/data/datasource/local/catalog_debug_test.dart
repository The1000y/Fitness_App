import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/chat/data/datasource/local/catalog_local_data_source.dart';
import 'package:fitness_app/features/chat/domain/repository/catalog_repository.dart';
import 'package:flutter/foundation.dart';

/// Test runner function that executes calls across [CatalogRepository] and
/// [CatalogLocalDataSource] and prints formatted diagnostic outputs to the terminal.
///
/// Executes only in [kDebugMode].
Future<void> debugTestCatalog() async {
  if (!kDebugMode) return;

  debugPrint('\n============================================================');
  debugPrint(
    '🚀 [CATALOG TEST] Starting CatalogRepository & LocalDataSource Diagnostic...',
  );
  debugPrint('============================================================');

  try {
    final catalogRepo = getIt<CatalogRepository>();
    final localDataSource = getIt<CatalogLocalDataSource>();

    // ──────────────────────────────────────────────────────────────────────────
    // 1. Test getFilterMetadata
    // ──────────────────────────────────────────────────────────────────────────
    debugPrint('\n👉 [1/6] Testing CatalogRepository.getFilterMetadata()...');
    final metadata = await catalogRepo.getFilterMetadata();
    debugPrint('   ✅ Metadata loaded successfully:');
    debugPrint(
      '      • Muscle Groups (${metadata.muscleGroups.length}): ${metadata.muscleGroups.take(6).toList()}...',
    );
    debugPrint(
      '      • Difficulties   (${metadata.difficulties.length}): ${metadata.difficulties.toList()}',
    );
    debugPrint(
      '      • Equipments     (${metadata.equipments.length}): ${metadata.equipments.take(6).toList()}...',
    );
    debugPrint(
      '      • Meal Categories(${metadata.mealCategories.length}): ${metadata.mealCategories.take(6).toList()}...',
    );
    debugPrint(
      '      • Meal Areas     (${metadata.mealAreas.length}): ${metadata.mealAreas.take(6).toList()}...',
    );

    // ──────────────────────────────────────────────────────────────────────────
    // 2. Test getExercisesForTool
    // ──────────────────────────────────────────────────────────────────────────
    debugPrint('\n👉 [2/6] Testing CatalogRepository.getExercisesForTool()...');
    final sampleMuscle = metadata.muscleGroups.isNotEmpty
        ? metadata.muscleGroups.first
        : 'Chest';
    debugPrint(
      '   🔍 Querying exercises with muscleGroup: "$sampleMuscle", limit: 3',
    );
    final toolExercises = await catalogRepo.getExercisesForTool(
      muscleGroup: sampleMuscle,
      limit: 3,
    );
    debugPrint('   ✅ Returned ${toolExercises.length} tool exercise rows:');
    for (var i = 0; i < toolExercises.length; i++) {
      final ex = toolExercises[i];
      debugPrint(
        '      [$i] id: ${ex['id']}, name: "${ex['name']}", difficulty: ${ex['difficulty']}, muscle: ${ex['muscle_group']}',
      );
    }

    // ──────────────────────────────────────────────────────────────────────────
    // 3. Test getMealsForTool
    // ──────────────────────────────────────────────────────────────────────────
    debugPrint('\n👉 [3/6] Testing CatalogRepository.getMealsForTool()...');
    final sampleCategory = metadata.mealCategories.isNotEmpty
        ? metadata.mealCategories.first
        : 'Chicken';
    debugPrint(
      '   🔍 Querying meals with category: "$sampleCategory", limit: 3',
    );
    final toolMeals = await catalogRepo.getMealsForTool(
      category: sampleCategory,
      limit: 3,
    );
    debugPrint('   ✅ Returned ${toolMeals.length} tool meal rows:');
    for (var i = 0; i < toolMeals.length; i++) {
      final m = toolMeals[i];
      debugPrint(
        '      [$i] id: ${m['id']}, name: "${m['name']}", kcal: ${m['kcal']}, protein: ${m['protein_g']}g, category: ${m['category']}',
      );
    }

    // ──────────────────────────────────────────────────────────────────────────
    // 4. Test getExercisesByIds (Testing Repository -> Response DTO -> ExerciseEntity Mapper flow)
    // ──────────────────────────────────────────────────────────────────────────
    debugPrint('\n👉 [4/6] Testing CatalogRepository.getExercisesByIds()...');
    final exerciseIds = toolExercises
        .map((e) => e['id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (exerciseIds.isNotEmpty) {
      debugPrint(
        '   🔍 Resolving ExerciseEntity objects for IDs: $exerciseIds',
      );
      final exerciseEntities = await catalogRepo.getExercisesByIds(exerciseIds);
      debugPrint(
        '   ✅ Successfully mapped ${exerciseEntities.length} ExerciseEntity objects:',
      );
      for (var i = 0; i < exerciseEntities.length; i++) {
        final e = exerciseEntities[i];
        debugPrint('      [$i] ExerciseEntity:');
        debugPrint('          • id:                           ${e.id}');
        debugPrint('          • exercise:                     "${e.exercise}"');
        debugPrint(
          '          • difficultyLevel:              ${e.difficultyLevel}',
        );
        debugPrint(
          '          • targetMuscleGroup:            ${e.targetMuscleGroup}',
        );
        debugPrint(
          '          • primeMoverMuscle:             ${e.primeMoverMuscle}',
        );
        debugPrint(
          '          • primaryEquipment:             ${e.primaryEquipment}',
        );
        debugPrint('          • mechanics:                    ${e.mechanics}');
        debugPrint('          • nameAr:                       ${e.nameAr}');
        debugPrint('          • forceType:                    ${e.forceType}');
        debugPrint('          • popularity:                   ${e.popularity}');
        debugPrint(
          '          • shortYoutubeDemonstrationLink: ${e.shortYoutubeDemonstrationLink}',
        );
      }
    } else {
      debugPrint('   ⚠️ No exercise IDs retrieved to test getExercisesByIds');
    }

    // ──────────────────────────────────────────────────────────────────────────
    // 5. Test getMealsByIds (Testing Repository -> Response DTO -> MealEntity Mapper flow)
    // ──────────────────────────────────────────────────────────────────────────
    debugPrint('\n👉 [5/6] Testing CatalogRepository.getMealsByIds()...');
    final mealIds = toolMeals
        .map((m) => m['id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (mealIds.isNotEmpty) {
      debugPrint('   🔍 Resolving MealEntity objects for IDs: $mealIds');
      final mealEntities = await catalogRepo.getMealsByIds(mealIds);
      debugPrint(
        '   ✅ Successfully mapped ${mealEntities.length} MealEntity objects:',
      );
      for (var i = 0; i < mealEntities.length; i++) {
        final m = mealEntities[i];
        debugPrint('      [$i] MealEntity:');
        debugPrint('          • id:        ${m.id}');
        debugPrint('          • name:      "${m.name}"');
        debugPrint('          • area:      ${m.area}');
        debugPrint('          • category:  ${m.category}');
        debugPrint('          • nameAr:    ${m.nameAr}');
        debugPrint('          • kcal:      ${m.kcal}');
        debugPrint('          • proteinG:  ${m.proteinG}g');
        debugPrint('          • thumbnail: ${m.thumbnail}');
      }
    } else {
      debugPrint('   ⚠️ No meal IDs retrieved to test getMealsByIds');
    }

    // ──────────────────────────────────────────────────────────────────────────
    // 6. Direct CatalogLocalDataSource verification (inspecting raw Response DTOs)
    // ──────────────────────────────────────────────────────────────────────────
    debugPrint(
      '\n👉 [6/6] Directly Testing CatalogLocalDataSource raw DTO responses...',
    );
    if (exerciseIds.isNotEmpty) {
      final exResponse = await localDataSource.getExercisesByIds([
        exerciseIds.first,
      ]);
      debugPrint(
        '   ✅ CatalogLocalDataSource.getExercisesByIds: ExercisesDatabaseResponse loaded',
      );
      debugPrint('      • DTO count: ${exResponse.exercises?.length ?? 0}');
      if (exResponse.exercises != null && exResponse.exercises!.isNotEmpty) {
        final dto = exResponse.exercises!.first;
        debugPrint(
          '      • DTO[0]: id: ${dto.id}, name: "${dto.name}", muscleGroupId: ${dto.muscleGroupId}, difficultyId: ${dto.difficultyId}',
        );
      }
    }

    if (mealIds.isNotEmpty) {
      final mlResponse = await localDataSource.getMealsByIds([mealIds.first]);
      debugPrint(
        '   ✅ CatalogLocalDataSource.getMealsByIds: MealsDatabaseResponse loaded',
      );
      debugPrint('      • DTO count: ${mlResponse.meals?.length ?? 0}');
      if (mlResponse.meals != null && mlResponse.meals!.isNotEmpty) {
        final dto = mlResponse.meals!.first;
        debugPrint(
          '      • DTO[0]: id: ${dto.id}, name: "${dto.name}", categoryId: ${dto.categoryId}, kcal: ${dto.kcal}, protein: ${dto.proteinG}g',
        );
      }
    }

    debugPrint(
      '\n============================================================',
    );
    debugPrint(
      '🎉 [CATALOG TEST] ALL 6 DIAGNOSTIC CHECKS COMPLETED SUCCESSFULLY!',
    );
    debugPrint(
      '============================================================\n',
    );
  } catch (e, stackTrace) {
    debugPrint(
      '\n❌ [CATALOG TEST ERROR] Diagnostic check threw an exception: $e',
    );
    debugPrint('$stackTrace\n');
  }
}
