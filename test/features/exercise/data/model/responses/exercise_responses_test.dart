import 'package:fitness_app/features/exercise/data/model/responses/muscles_by_group_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/muscles_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MusclesResponse', () {
    test('deserializes API group JSON and maps it to domain entities', () {
      final response = MusclesResponse.fromJson({
        'message': 'success',
        'musclesGroup': [
          {'_id': 'group-1', 'name': 'Abdominals'},
        ],
      });

      expect(response.message, 'success');
      expect(response.musclesGroup?.single.id, 'group-1');
      expect(response.toEntity().musclesGroup.single.name, 'Abdominals');
    });

    test('handles a response with no groups', () {
      final entity = MusclesResponse.fromJson({
        'message': 'success',
      }).toEntity();

      expect(entity.musclesGroup, isEmpty);
    });
  });

  group('MusclesByGroupResponse', () {
    test('deserializes API muscle JSON and maps it to domain entities', () {
      final response = MusclesByGroupResponse.fromJson({
        'message': 'success',
        'totalMuscles': 1,
        'muscles': [
          {
            '_id': 'muscle-1',
            'name': 'Rectus Abdominis',
            'image': 'https://example.com/rectus.png',
          },
        ],
      });

      final entity = response.toEntity();

      expect(entity.message, 'success');
      expect(entity.totalMuscles, 1);
      expect(entity.muscles.single.id, 'muscle-1');
      expect(entity.muscles.single.name, 'Rectus Abdominis');
      expect(entity.muscles.single.image, 'https://example.com/rectus.png');
    });

    test('handles a response with no muscles', () {
      final entity = MusclesByGroupResponse.fromJson({
        'message': 'success',
      }).toEntity();

      expect(entity.totalMuscles, 0);
      expect(entity.muscles, isEmpty);
    });
  });
}
