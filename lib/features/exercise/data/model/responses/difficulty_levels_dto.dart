import 'package:json_annotation/json_annotation.dart';

import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';

part 'difficulty_levels_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class DifficultyLevelsDto {
  final String? message;
  final int? totalLevels;
  @JsonKey(name: 'difficulty_levels')
  final List<DifficultyLevelDto>? difficultyLevels;

  DifficultyLevelsDto({this.message, this.totalLevels, this.difficultyLevels});

  factory DifficultyLevelsDto.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelsDtoToJson(this);

  List<DifficultyLevelEntity> toEntity() =>
      difficultyLevels?.map((e) => e.toEntity()).toList() ?? [];
}

@JsonSerializable()
class DifficultyLevelDto {
  final String? id;
  final String? name;

  DifficultyLevelDto({this.id, this.name});

  factory DifficultyLevelDto.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelDtoToJson(this);

  DifficultyLevelEntity toEntity() =>
      DifficultyLevelEntity(id: id ?? '', name: name ?? '');
}
