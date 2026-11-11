// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'chat_state.dart';

// class ChatCubit extends Cubit<ChatState> {
//   ChatCubit() : super(const ChatState());

// }

// class ChatUiMessage {
//   final bool isUser;
//   final String text;
//   final List<ExerciseEntity> exercises;
//   final List<MealEntity> meals;
//   const ChatUiMessage({
//     required this.isUser,
//     required this.text,
//     this.exercises = const [],
//     this.meals = const [],
//   });
// }

// class ChatState {
//   final List<ChatUiMessage> messages;
//   final bool isLoading;
//   final bool showTokenLimitWarning;
//   final String? error;
//   const ChatState({
//     this.messages = const [],
//     this.isLoading = false,
//     this.showTokenLimitWarning = false,
//     this.error,
//   });
// }

// class ChatCubit extends Cubit<ChatState> {
//   final SendMessageUseCase _sendMessageUseCase;
//   String conversationId;
//   final String userId;
//   ChatCubit(
//     this._sendMessageUseCase, {
//     required this.userId,
//     required this.conversationId,
//   }) : super(const ChatState());
//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     final updated = [
//       ...state.messages,
//       ChatUiMessage(isUser: true, text: text),
//     ];
//     emit(ChatState(messages: updated, isLoading: true));
//     try {
//       final result = await _sendMessageUseCase(
//         userId: userId,
//         conversationId: conversationId,
//         userText: text,
//       );
//       emit(
//         ChatState(
//           messages: [
//             ...updated,
//             ChatUiMessage(
//               isUser: false,
//               text: result.answerText,
//               exercises: result.exercises,
//               meals: result.meals,
//             ),
//           ],
//           isLoading: false,
//           showTokenLimitWarning: result.isNearTokenLimit,
//         ),
//       );
//     } catch (e) {
//       emit(
//         ChatState(messages: updated, isLoading: false, error: 'حدث حطا  :$e'),
//       );
//     }
//   }

//   void startNewChat(String newConversationId) {
//     conversationId = newConversationId;
//     emit(const ChatState(messages: []));
//   }
// }
