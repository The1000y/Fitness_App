import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  @JsonKey(name: "role")
  final String role;

  @JsonKey(name: "content")
  final String content;

  const MessageDto({
    required this.role,
    required this.content,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}