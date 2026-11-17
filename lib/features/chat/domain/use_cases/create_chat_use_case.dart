import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateChatUseCase {
  final ChatRepository _chatRepository;

  CreateChatUseCase(this._chatRepository);

  Future<BaseResponse<ChatEntity>> call({
    required String userId,
    required String userText,
  }) async {
    final title = userText.length > 30
        ? '${userText.substring(0, 30)}...'
        : userText;

    try {
      return await _chatRepository.createChat(title: title, userId: userId);
    } on AppFailure catch (failure) {
      return Error<ChatEntity>(failure);
    } catch (error, stackTrace) {
      debugPrint('Chat create error => $error\n$stackTrace');
      return const Error<ChatEntity>(UnknownFailure());
    }
  }
}
