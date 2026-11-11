import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('ExercisesListDto', () {
    test('fromJson maps counters and exercises', () {
      final response = ExercisesListDto.fromJson(
        TestData.exercisesListResponseJson,
      );

      expect(response.message, 'Success');
      expect(response.totalExercises, 2);
      expect(response.totalPages, 1);
      expect(response.currentPage, 1);
      expect(response.exercises, hasLength(2));
      expect(response.exercises?.first.exercise, 'Push Up');
      expect(response.exercises?.last.exercise, 'Dumbbell Fly');
    });

    test('toJson round trips the list payload', () {
      final json = TestData.exercisesListResponse.toJson();

      expect(json['message'], 'Success');
      expect(json['totalExercises'], 2);
      expect(json['totalPages'], 1);
      expect(json['currentPage'], 1);
      expect((json['exercises'] as List).length, 2);
      expect((json['exercises'] as List).first['exercise'], 'Push Up');
    });

    test('toEntity maps counters and nested exercises', () {
      final entity = TestData.exercisesListResponse.toEntity();

      expect(entity, isA<ExercisesListEntity>());
      expect(entity.message, 'Success');
      expect(entity.totalExercises, 2);
      expect(entity.totalPages, 1);
      expect(entity.currentPage, 1);
      expect(entity.exercises, hasLength(2));
      expect(entity.exercises.first.exercise, 'Push Up');
      expect(entity.exercises.last.difficultyLevel, 'Beginner');
      expect(entity.exercises.last.inDepthYoutubeExplanationLink, isNull);
    });

    test('fromJson with an empty payload produces safe defaults', () {
      final response = ExercisesListDto.fromJson({});

      expect(response.message, isNull);
      expect(response.totalExercises, isNull);
      expect(response.totalPages, isNull);
      expect(response.currentPage, isNull);
      expect(response.exercises, isNull);
    });

    test('toEntity replaces missing values with defaults', () {
      final entity = ExercisesListDto.fromJson({}).toEntity();

      expect(entity.message, '');
      expect(entity.totalExercises, 0);
      expect(entity.totalPages, 0);
      expect(entity.currentPage, 0);
      expect(entity.exercises, isEmpty);
    });

    test('ExercisesListEntity equality is value based', () {
      final first = TestData.exercisesListEntity;
      final second = TestData.exercisesListResponse.toEntity();
      final different = ExercisesListDto.fromJson({
        ...TestData.exercisesListResponseJson,
        'totalExercises': 5,
      }).toEntity();

      expect(first, second);
      expect(first, isNot(different));
      expect(first.props, contains(2));
    });
  });
}
