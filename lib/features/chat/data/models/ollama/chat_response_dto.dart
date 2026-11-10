
import 'package:fitness_app/features/chat/data/models/ollama/message_dto.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_response_dto.g.dart';

@JsonSerializable()
class ChatResponseDto {
  @JsonKey(name: "model")
  String? model;

  @JsonKey(name: "message")
  MessageDto? message;

  @JsonKey(name: "done")
  bool? done;

  ChatResponseDto({
    this.model,
    this.message,
    this.done,
  });

  factory ChatResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseDtoToJson(this);

  ChatResponseEntity toEntity() {
    return ChatResponseEntity(
      content: message?.content ?? '',
    );
  }
}
