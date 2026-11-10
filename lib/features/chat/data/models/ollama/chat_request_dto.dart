import 'package:fitness_app/features/chat/data/models/ollama/message_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_request_dto.g.dart';

@JsonSerializable()
class ChatRequestDto {
  @JsonKey(name: "model")
  final String model;

  @JsonKey(name: "messages")
  final List<MessageDto> messages;

  @JsonKey(name: "stream")
  final bool stream;

  ChatRequestDto({
    required this.model,
    required this.messages,
    this.stream = false,
  });

  factory ChatRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRequestDtoToJson(this);
}