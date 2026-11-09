import 'package:fitness_app/features/chat/domain/entities/catalog_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalogFilterMetadata', () {
    test('supports value equality via Equatable', () {
      const meta1 = CatalogFilterMetadata(
        muscleGroups: ['Chest', 'Back'],
        difficulties: ['Beginner', 'Advanced'],
        equipments: ['Dumbbell', 'Barbell'],
        mealCategories: ['High Protein', 'Keto'],
        mealAreas: ['Italian', 'Middle Eastern'],
      );
      const meta2 = CatalogFilterMetadata(
        muscleGroups: ['Chest', 'Back'],
        difficulties: ['Beginner', 'Advanced'],
        equipments: ['Dumbbell', 'Barbell'],
        mealCategories: ['High Protein', 'Keto'],
        mealAreas: ['Italian', 'Middle Eastern'],
      );

      expect(meta1, equals(meta2));
      expect(meta1.props, [
        ['Chest', 'Back'],
        ['Beginner', 'Advanced'],
        ['Dumbbell', 'Barbell'],
        ['High Protein', 'Keto'],
        ['Italian', 'Middle Eastern'],
      ]);
    });
  });
}
