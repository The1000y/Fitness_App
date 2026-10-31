
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_response.g.dart';

@JsonSerializable()
class MuscleResponse {
  @JsonKey(name: '_id')
  final String? id;

  final String? name;
  final String? image;

  MuscleResponse({
    this.id,
    this.name,
    this.image,
  });

  factory MuscleResponse.fromJson(Map<String, dynamic> json) =>
      _$MuscleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleResponseToJson(this);

  MuscleEntity toEntity() {
    return MuscleEntity(
      id: id ?? '',
      name: name ?? '',
      image: image ?? '',
    );
  }
}
