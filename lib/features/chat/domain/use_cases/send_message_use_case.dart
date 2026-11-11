// import 'dart:convert';
// import 'package:fitness_app/features/chat/domain/use_cases/chat_prompt_and_schemas.dart';
// import 'package:injectable/injectable.dart';

// class ChatTurnOutput {
//   final String answerText;
//   final List<ExerciseEntity> exercises;
//   final List<MealEntity> meals;
//   final int totalTokensUsed;
//   final bool isNearTokenLimit;
//   const ChatTurnOutput({
//     required this.answerText,
//     required this.exercises,
//     required this.meals,
//     required this.totalTokensUsed,
//     required this.isNearTokenLimit,
//   });
// }


// class SendMessageUseCase {
//   final CatalogReposatery _catalogDataSource;
//   final ChatRepository _ollamaDataSource;
//   final ChatFirestoreDataSource _firestoreDataSource;
//   static const int maxSessionTokens = 6000;
//   static const int maxToolLoops = 4; // ; 4 Infinite Loop
//   SendMessageUseCase(
//     this._catalogDataSource,
//     this._ollamaDataSource,
//     this._firestoreDataSource,
//   );

//   Future<ChatTurnOutput> call({
//     required String userId,
//     required String conversationId,
//     required String userText,
//   }) async {
//     //possible value  and stsyem prompt and tools
//     final meta = await _catalogDataSource.getFilterMetadata();
//     final systemPrompt = ChatPromptAndSchemas.buildSystemPrompt(meta);
//     final tools = ChatPromptAndSchemas.buildTools(meta);

//     //get previous messages and build message list

//     final historyDtos = await _firestoreDataSource.getMessages(
//       userId,
//       conversationId,
//     );
//     int cumulativeTokens = historyDtos.fold(0, (sum, m) => sum + m.tokensUsed);
//     final List<Map<String, dynamic>> messages = [
//       {'role': 'system', 'content': systemPrompt},

//       for (final m in historyDtos.skip(
//         historyDtos.length > 12 ? historyDtos.length - 12 : 0,
//       ))
//         {'role': m.role, 'content': m.content},
//       {'role': 'user', 'content': userText},
//     ];

//     //save user message previous
//     await _firestoreDataSource.saveMessage(
//       userId,
//       conversationId,
//       ChatMessageDto.fromEntity(
//         ChatMessageEntity(
//           id: '',
//           role: 'user',
//           content: userText,
//           createdAt: DateTime.now(),
//         ),
//       ),
//     );

//     //tool call loop 1
//     bool thereIsTool = false;
//     int loopCount = 0;
//     int turnTokens = 0;
//     final Set<String> validExerciseCandidates = {};
//     final Set<String> validMealCandidates = {};
//     while (loopCount < maxToolLoops) {
//       loopCount++;
//       final response = await _ollamaDataSource.chat(
//         messages: messages,
//         tools: tools,
//       );
//       //caculate token form ollama's responce
//       final promptTokens =
//           (response['prompt_eval_count'] as num?)?.toInt() ?? 0;
//       final evalTokens = (response['eval_count'] as num?)?.toInt() ?? 0;
//       turnTokens = promptTokens + evalTokens;
//       final assistantMsg = response['message'] as Map<String, dynamic>;
//       messages.add(assistantMsg);
//       final toolCalls = assistantMsg['tool_calls'] as List<dynamic>?;
//       if (toolCalls == null || toolCalls.isEmpty) {
//         break;
//       }
//       thereIsTool = true;
//       for (final call in toolCalls) {
//         final fn = call['function'] as Map<String, dynamic>;
//         final name = fn['name'] as String;
//         final args = (fn['arguments'] as Map<String, dynamic>?) ?? {};
//         if (name == 'get_exercises') {
//           final rows = await _catalogDataSource.getExercisesForTool(
//             muscleGroup: args['muscle_group']?.toString(),
//             difficulty: args['difficulty']?.toString(),
//             equipment: args['equipment']?.toString(),
//           );
//           for (final r in rows) {
//             validExerciseCandidates.add(r['id'].toString());
//           }
//           messages.add({
//             'role': 'tool',
//             'tool_name': name,
//             'content': jsonEncode(rows),
//           });
//         } else if (name == 'get_meals') {
//           final rows = await _catalogDataSource.getMealsForTool(
//             category: args['category']?.toString(),
//             area: args['area']?.toString(),
//             minProtein: (args['min_protein'] as num?)?.toDouble(),
//             maxKcal: (args['max_kcal'] as num?)?.toDouble(),
//             vegetarian: args['vegetarian'] as bool?,
//           );
//           for (final r in rows) {
//             validMealCandidates.add(r['id'].toString());
//           }
//           messages.add({
//             'role': 'tool',
//             'tool_name': name,
//             'content': jsonEncode(rows),
//           });
//         }
//       }
//     }
//     String finalAnswerText = '';
//     List<String> chosenExerciseIds = [];
//     List<String> chosenMealIds = [];

//     //return answer when there is no tool
//     if (!thereIsTool) {
//       finalAnswerText = (messages.last['content'] as String?) ?? '';
//     } else {
//       //make model to return responce dependon answer schema
//       final formattedResponse = await _ollamaDataSource.chat(
//         messages: [
//           ...messages,
//           {
//             'role': 'user',
//             'content':
//                 'Convert your previous answer to JSON matching the schema.',
//           },
//         ],
//         format: ChatPromptAndSchemas.answerSchema,
//       );
//       final pTokens =
//           (formattedResponse['prompt_eval_count'] as num?)?.toInt() ?? 0;
//       final eTokens = (formattedResponse['eval_count'] as num?)?.toInt() ?? 0;
//       turnTokens += (pTokens + eTokens);
//       final rawContent = formattedResponse['message']['content'] as String;
//       final parsed = jsonDecode(rawContent) as Map<String, dynamic>;
//       finalAnswerText = parsed['answer'] as String? ?? '';

//       //filter id to make sure not fake id geneareted
//       chosenExerciseIds = ((parsed['exercise_ids'] as List?) ?? [])
//           .map((e) => e.toString())
//           .where((id) => validExerciseCandidates.contains(id))
//           .toList();
//       chosenMealIds = ((parsed['meal_ids'] as List?) ?? [])
//           .map((e) => e.toString())
//           .where((id) => validMealCandidates.contains(id))
//           .toList();
//     }

//     //get card details
//     final exercises = await _catalogDataSource.getExercisesByIds(
//       chosenExerciseIds,
//     );
//     final meals = await _catalogDataSource.getMealsByIds(chosenMealIds);

//     //save message of assistent in firestore with token and ids
//     await _firestoreDataSource.saveMessage(
//       userId,
//       conversationId,
//       ChatMessageDto.fromEntity(
//         ChatMessageEntity(
//           id: '',
//           role: 'assistant',
//           content: finalAnswerText,
//           exerciseIds: chosenExerciseIds,
//           mealIds: chosenMealIds,
//           tokensUsed: turnTokens,
//           createdAt: DateTime.now(),
//         ),
//       ),
//     );
//     final updatedTotalTokens = cumulativeTokens + turnTokens;
//     return ChatTurnOutput(
//       answerText: finalAnswerText,
//       exercises: exercises,
//       meals: meals,
//       totalTokensUsed: updatedTotalTokens,
//       isNearTokenLimit: updatedTotalTokens >= (maxSessionTokens * 0.85),
//     );
//   }
// }
