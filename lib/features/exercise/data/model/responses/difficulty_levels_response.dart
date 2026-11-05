import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/difficulty_level_entity.dart';

part 'difficulty_levels_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DifficultyLevelsResponse {
  final String? message;
  final int? totalLevels;
  @JsonKey(name: 'difficulty_levels')
  final List<DifficultyLevelResponse>? difficultyLevels;

  DifficultyLevelsResponse({this.message, this.totalLevels, this.difficultyLevels});

  factory DifficultyLevelsResponse.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelsResponseToJson(this);

  List<DifficultyLevelEntity> toEntity() =>
      difficultyLevels?.map((e) => e.toEntity()).toList() ?? [];
}

@JsonSerializable()
class DifficultyLevelResponse {
  final String? id;
  final String? name;

  DifficultyLevelResponse({this.id, this.name});

  factory DifficultyLevelResponse.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelResponseToJson(this);

  DifficultyLevelEntity toEntity() =>
      DifficultyLevelEntity(id: id ?? '', name: name ?? '');
}