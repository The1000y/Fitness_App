
import 'package:equatable/equatable.dart';

class ChatResponseEntity extends Equatable {
  final String content;

  const ChatResponseEntity({
    required this.content,
  });

  @override
  List<Object?> get props => [content];
}
