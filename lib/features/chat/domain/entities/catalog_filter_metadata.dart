import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [
    muscleGroups,
    difficulties,
    equipments,
    mealCategories,
    mealAreas,
  ];
}
