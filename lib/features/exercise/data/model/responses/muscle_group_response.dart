
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_group_response.g.dart';

@JsonSerializable()
class MuscleGroupResponse {
  @JsonKey(name: '_id')
  final String? id;

  final String? name;

  MuscleGroupResponse({
    this.id,
    this.name,
  });

  factory MuscleGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupResponseToJson(this);

  MuscleGroupEntity toEntity() {
    return MuscleGroupEntity(
      id: id ?? '',
      name: name ?? '',
    );
  }
}
