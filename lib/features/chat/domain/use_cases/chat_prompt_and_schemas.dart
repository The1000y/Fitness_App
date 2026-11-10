class ChatPromptAndSchemas {
  static String buildSystemPrompt(CatalogFilterMetadata meta) =>
      '''
You are the in-app fitness and nutrition coach.

LANGUAGE:
Reply in the same language the user wrote in (Arabic or English).

CRITICAL GROUND RULES:
1. Never invent or suggest exercises or meals from your own memory.
2. Before recommending any exercise or meal, ALWAYS call `get_exercises` or `get_meals`.
3. Recommend ONLY items returned by those tools.
4. Keep replies concise (under 180 words) and never put raw IDs or URLs in the text.

ALLOWED FILTER VALUES (use these exact strings in tool arguments):
- muscle_group: ${meta.muscleGroups.join(' | ')}
- difficulty: ${meta.difficulties.join(' | ')}
- equipment: ${meta.equipments.join(' | ')}
- meal category: ${meta.mealCategories.join(' | ')}
- meal area: ${meta.mealAreas.join(' | ')}
''';

  static List<Map<String, dynamic>> buildTools(CatalogFilterMetadata meta) => [
    {
      'type': 'function',
      'function': {
        'name': 'get_exercises',
        'description':
            'Search the exercise catalog by muscle group, difficulty and/or equipment. '
            'Call this BEFORE recommending any exercise. '
            'Returns up to 8 exercises, most popular first. All filters are optional.',
        'parameters': {
          'type': 'object',
          'properties': {
            'muscle_group': {
              'type': 'string',
              'description': 'Allowed: ${meta.muscleGroups.join(", ")}',
            },
            'difficulty': {
              'type': 'string',
              'description': 'Allowed: ${meta.difficulties.join(", ")}',
            },
            'equipment': {
              'type': 'string',
              'description': 'Allowed: ${meta.equipments.join(", ")}',
            },
          },
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_meals',
        'description':
            'Search the meal catalog by category, area, protein, calories and/or vegetarian. '
            'Call this BEFORE recommending any meal. '
            'Returns up to 8 meals, highest protein first. All filters are optional.',
        'parameters': {
          'type': 'object',
          'properties': {
            'category': {
              'type': 'string',
              'description': 'Allowed: ${meta.mealCategories.join(", ")}',
            },
            'area': {
              'type': 'string',
              'description': 'Allowed: ${meta.mealAreas.join(", ")}',
            },
            'min_protein': {'type': 'number'},
            'max_kcal': {'type': 'number'},
            'vegetarian': {'type': 'boolean'},
          },
        },
      },
    },
  ];
  static const Map<String, dynamic> answerSchema = {
    'type': 'object',
    'properties': {
      'answer': {
        'type': 'string',
        'description':
            'Friendly natural-language reply in the user language without IDs or URLs.',
      },
      'exercise_ids': {
        'type': 'array',
        'items': {'type': 'string'},
        'description': 'Exact exercise IDs chosen from tool results.',
      },
      'meal_ids': {
        'type': 'array',
        'items': {'type': 'string'},
        'description': 'Exact meal IDs chosen from tool results.',
      },
    },
    'required': ['answer', 'exercise_ids', 'meal_ids'],
  };
}
