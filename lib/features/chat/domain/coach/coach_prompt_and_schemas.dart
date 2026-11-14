import 'package:fitness_app/features/chat/domain/entities/chat_tool_definition_entity.dart';

class CoachPromptAndSchemas {
  static String buildSystemPrompt({
    required List<String> muscleGroups,
    required List<String> difficulties,
    required List<String> equipment,
    required List<String> mealCategories,
    required List<String> mealAreas,
  }) {
    return '''
You are the in-app fitness and nutrition coach.
Reply in the same language the user used.
Never invent exercises or meals.
Before recommending an exercise, call get_exercises.
Before recommending a meal, call get_meals.
Recommend only items returned by the tools.
Keep replies concise and do not include raw IDs or URLs.

Allowed exercise filters:
- muscle_group: ${muscleGroups.join(' | ')}
- difficulty: ${difficulties.join(' | ')}
- equipment: ${equipment.join(' | ')}

Allowed meal filters:
- category: ${mealCategories.join(' | ')}
- area: ${mealAreas.join(' | ')}
''';
  }

  static List<ChatToolDefinitionEntity> buildAvailableTools({
    required List<String> muscleGroups,
    required List<String> difficulties,
    required List<String> equipment,
    required List<String> mealCategories,
    required List<String> mealAreas,
  }) {
    return [
      ChatToolDefinitionEntity(
        name: 'get_exercises',
        description: 'Search exercises in the local catalog.',
        parameters: {
          'type': 'object',
          'properties': {
            'muscle_group': {
              'type': 'string',
              'enum': muscleGroups,
            },
            'difficulty': {
              'type': 'string',
              'enum': difficulties,
            },
            'equipment': {
              'type': 'string',
              'enum': equipment,
            },
          },
        },
      ),
      ChatToolDefinitionEntity(
        name: 'get_meals',
        description: 'Search meals in the local catalog.',
        parameters: {
          'type': 'object',
          'properties': {
            'category': {
              'type': 'string',
              'enum': mealCategories,
            },
            'area': {
              'type': 'string',
              'enum': mealAreas,
            },
            'min_protein': {'type': 'number'},
            'max_kcal': {'type': 'number'},
            'vegetarian': {'type': 'boolean'},
          },
        },
      ),
    ];
  }

  static const Map<String, dynamic> answerSchema = {
    'type': 'object',
    'properties': {
      'answer': {'type': 'string'},
      'exercise_ids': {
        'type': 'array',
        'items': {'type': 'string'},
      },
      'meal_ids': {
        'type': 'array',
        'items': {'type': 'string'},
      },
    },
    'required': ['answer', 'exercise_ids', 'meal_ids'],
  };
}
