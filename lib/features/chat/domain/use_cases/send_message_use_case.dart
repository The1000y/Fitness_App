import 'dart:convert';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/chat/domain/entities/catalog_filter_metadata.dart';
import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';
import 'package:fitness_app/features/chat/domain/entities/message_entity.dart';
import 'package:fitness_app/features/chat/domain/repository/catalog_repository.dart';
import 'package:fitness_app/features/chat/domain/repository/chat_repository.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

class ChatOutput {
  final String chatId;
  final String answerText;
  final List<ExerciseEntity> exercises;
  final List<MealEntity> meals;
  final int totalTokensUsed;
  final bool isNearTokenLimit;

  const ChatOutput({
    required this.chatId,
    required this.answerText,
    required this.exercises,
    required this.meals,
    required this.totalTokensUsed,
    required this.isNearTokenLimit,
  });
}

@injectable
class SendMessageUseCase {
  final CatalogRepository _catalogRepository;
  final ChatRepository _chatRepository;

  SendMessageUseCase(this._catalogRepository, this._chatRepository);

  static const int maxSessionTokens = 12000;
  static const int maxToolLoops = 4;

  Future<BaseResponse<ChatOutput>> call({
    required String chatId,
    required String userText,
    required List<MessageEntity> conversationHistory,
  }) async {
    try {
      return await _sendMessage(
        chatId: chatId,
        userText: userText,
        conversationHistory: conversationHistory,
      );
    } on AppFailure catch (failure) {
      return Error<ChatOutput>(failure);
    } catch (error, stackTrace) {
      debugPrint('Chat send error => $error\n$stackTrace');
      return const Error<ChatOutput>(UnknownFailure());
    }
  }

  Future<BaseResponse<ChatOutput>> _sendMessage({
    required String chatId,
    required String userText,
    required List<MessageEntity> conversationHistory,
  }) async {
    final activeChatId = chatId;

    final filterMetadata = await _getFilterMetadata();
    final previousMessages = conversationHistory.length > 20
        ? conversationHistory.sublist(conversationHistory.length - 20)
        : conversationHistory;

    final totalPreviousTokens = previousMessages.fold<int>(
      0,
      (sum, message) => sum + message.tokensUsed,
    );
    final isRetryingLastUserMessage =
        previousMessages.isNotEmpty &&
        previousMessages.last.role == 'user' &&
        previousMessages.last.content == userText;
    final userMessage = isRetryingLastUserMessage
        ? previousMessages.last
        : MessageEntity(
            id: '',
            chatId: activeChatId,
            content: userText,
            role: 'user',
            createdAt: DateTime.now(),
          );

    if (!isRetryingLastUserMessage) {
      final saveUserMessageResult = await _chatRepository.saveMessage(
        message: userMessage,
      );
      switch (saveUserMessageResult) {
        case Success<MessageEntity>():
          break;
        case Error<MessageEntity>(failure: final failure):
          return Error(failure);
      }
    }

    final recentHistory = previousMessages.length > 12
        ? previousMessages.sublist(previousMessages.length - 12)
        : previousMessages;
    final workingHistory = [...recentHistory];
    if (!isRetryingLastUserMessage) {
      workingHistory.add(userMessage);
    }

    bool thereIsTool = false;
    int loopCount = 0;
    int usedTokenOllama = 0;
    String lastAssistantContent = '';
    final Set<String> validExerciseCandidates = {};
    final Set<String> validMealCandidates = {};

    while (loopCount < maxToolLoops) {
      loopCount++;
      final responseResult = await _chatRepository
          .requestCoachResponseWithTools(
            conversationHistory: workingHistory,
            muscleGroups: filterMetadata.muscleGroups,
            difficulties: filterMetadata.difficulties,
            equipment: filterMetadata.equipments,
            mealCategories: filterMetadata.mealCategories,
            mealAreas: filterMetadata.mealAreas,
          );

      final response = switch (responseResult) {
        Success(data: final data) => data,
        Error(failure: final failure) => throw failure,
      };

      usedTokenOllama += response.totalTokensUsed;
      lastAssistantContent = response.content;

      workingHistory.add(
        MessageEntity(
          id: '',
          chatId: activeChatId,
          content: response.content,
          role: 'assistant',
          createdAt: DateTime.now(),
          toolCalls: response.toolCalls,
        ),
      );

      if (!response.hasToolCalls) break;
      thereIsTool = true;

      for (final ToolCallEntity call in response.toolCalls) {
        final args = call.arguments;

        if (call.name == 'get_exercises') {
          final exercises = await _getExercisesForTool(
            muscleGroup: _validatedChoice(
              args['muscle_group'],
              filterMetadata.muscleGroups,
            ),
            difficulty: _validatedChoice(
              args['difficulty'],
              filterMetadata.difficulties,
            ),
            equipment: _validatedChoice(
              args['equipment'],
              filterMetadata.equipments,
            ),
          );
          final rowsJson = exercises.map((exercise) {
            validExerciseCandidates.add(exercise.id);
            return {
              'id': exercise.id,
              'name': exercise.exercise,
              'name_ar': exercise.nameAr,
              'muscle_group': exercise.targetMuscleGroup,
              'difficulty': exercise.difficultyLevel,
              'equipment': exercise.primaryEquipment,
            };
          }).toList();

          workingHistory.add(
            MessageEntity(
              id: '',
              chatId: activeChatId,
              role: 'tool',
              toolName: call.name,
              toolCallId: call.id,
              content: jsonEncode(rowsJson),
              createdAt: DateTime.now(),
            ),
          );
        } else if (call.name == 'get_meals') {
          final vegetarian = args['vegetarian'];
          final meals = await _getMealsForTool(
            category: _validatedChoice(
              args['category'],
              filterMetadata.mealCategories,
            ),
            area: _validatedChoice(args['area'], filterMetadata.mealAreas),
            minProtein: _boundedNumber(args['min_protein'], maximum: 500),
            maxKcal: _boundedNumber(args['max_kcal'], maximum: 10000),
            vegetarian: vegetarian is bool ? vegetarian : null,
          );
          final rowsJson = meals.map((meal) {
            validMealCandidates.add(meal.id);
            return {
              'id': meal.id,
              'name': meal.name,
              'name_ar': meal.nameAr,
              'category': meal.category,
              'area': meal.area,
              'kcal': meal.kcal,
              'protein_g': meal.proteinG,
            };
          }).toList();

          workingHistory.add(
            MessageEntity(
              id: '',
              chatId: activeChatId,
              role: 'tool',
              toolName: call.name,
              toolCallId: call.id,
              content: jsonEncode(rowsJson),
              createdAt: DateTime.now(),
            ),
          );
        }
      }
    }

    String finalAnswerText;
    List<String> chosenExerciseIds = [];
    List<String> chosenMealIds = [];

    if (!thereIsTool) {
      finalAnswerText = lastAssistantContent;
    } else {
      final structuredResult = await _chatRepository
          .requestStructuredCoachResponse(
            conversationHistory: [
              ...workingHistory,
              MessageEntity(
                id: '',
                chatId: activeChatId,
                role: 'user',
                content:
                    'Convert your previous answer to JSON matching the schema.',
                createdAt: DateTime.now(),
              ),
            ],
          );

      final structuredResponse = switch (structuredResult) {
        Success(data: final data) => data,
        Error(failure: final failure) => throw failure,
      };

      usedTokenOllama += structuredResponse.totalTokensUsed;
      final parsed =
          jsonDecode(structuredResponse.content) as Map<String, dynamic>;
      finalAnswerText = parsed['answer'] as String? ?? lastAssistantContent;

      chosenExerciseIds = ((parsed['exercise_ids'] as List?) ?? const [])
          .map((id) => id.toString())
          .where(validExerciseCandidates.contains)
          .toList();
      chosenMealIds = ((parsed['meal_ids'] as List?) ?? const [])
          .map((id) => id.toString())
          .where(validMealCandidates.contains)
          .toList();
    }

    final exercises = await _getExercisesByIds(chosenExerciseIds);
    final meals = await _getMealsByIds(chosenMealIds);

    final saveAssistantResult = await _chatRepository.saveMessage(
      message: MessageEntity(
        id: '',
        chatId: activeChatId,
        role: 'assistant',
        content: finalAnswerText,
        exerciseIds: chosenExerciseIds,
        mealIds: chosenMealIds,
        tokensUsed: usedTokenOllama,
        createdAt: DateTime.now(),
      ),
    );
    if (saveAssistantResult case Error(failure: final failure)) {
      return Error(failure);
    }

    final updatedTotalTokens = totalPreviousTokens + usedTokenOllama;
    return Success(
      ChatOutput(
        chatId: activeChatId,
        answerText: finalAnswerText,
        exercises: exercises,
        meals: meals,
        totalTokensUsed: updatedTotalTokens,
        isNearTokenLimit: updatedTotalTokens >= (maxSessionTokens * 0.85),
      ),
    );
  }

  Future<CatalogFilterMetadata> _getFilterMetadata() =>
      _catalogRepository.getFilterMetadata();

  String? _validatedChoice(Object? value, List<String> options) {
    if (value is! String) return null;
    final normalizedValue = value.trim().toLowerCase();
    for (final option in options) {
      if (option.toLowerCase() == normalizedValue) return option;
    }
    return null;
  }

  double? _boundedNumber(Object? value, {required double maximum}) {
    if (value is! num) return null;
    final number = value.toDouble();
    if (!number.isFinite || number < 0) return null;
    return number > maximum ? maximum : number;
  }

  Future<List<ExerciseEntity>> _getExercisesForTool({
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  }) async {
    try {
      return await _catalogRepository.getExercisesForTool(
        muscleGroup: muscleGroup,
        difficulty: difficulty,
        equipment: equipment,
      );
    } catch (error, stackTrace) {
      debugPrint('Chat exercise catalog unavailable => $error\n$stackTrace');
      return const [];
    }
  }

  Future<List<MealEntity>> _getMealsForTool({
    String? category,
    String? area,
    double? minProtein,
    double? maxKcal,
    bool? vegetarian,
  }) async {
    try {
      return await _catalogRepository.getMealsForTool(
        category: category,
        area: area,
        minProtein: minProtein,
        maxKcal: maxKcal,
        vegetarian: vegetarian,
      );
    } catch (error, stackTrace) {
      debugPrint('Chat meal catalog unavailable => $error\n$stackTrace');
      return const [];
    }
  }

  Future<List<ExerciseEntity>> _getExercisesByIds(List<String> ids) async {
    try {
      return await _catalogRepository.getExercisesByIds(ids);
    } catch (error, stackTrace) {
      debugPrint('Chat exercise details unavailable => $error\n$stackTrace');
      return const [];
    }
  }

  Future<List<MealEntity>> _getMealsByIds(List<String> ids) async {
    try {
      return await _catalogRepository.getMealsByIds(ids);
    } catch (error, stackTrace) {
      debugPrint('Chat meal details unavailable => $error\n$stackTrace');
      return const [];
    }
  }
}
