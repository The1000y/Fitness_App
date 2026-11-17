import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_hero_info.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_video_header_delegate.dart';
import '../../../../../../helpers/pump_app.dart';
import '../../../../../../helpers/test_data.dart';

void main() {
  final exercise = TestData.emptyLinkExerciseEntity;

  ExerciseVideoHeaderDelegate delegate({
    ExerciseEntity? item,
    String muscleName = 'Core',
    bool autoPlay = false,
    int playRequestId = 0,
    double maxHeight = 300,
    double minHeight = 165,
  }) {
    return ExerciseVideoHeaderDelegate(
      exercise: item ?? exercise,
      muscleName: muscleName,
      autoPlay: autoPlay,
      playRequestId: playRequestId,
      maxHeight: maxHeight,
      minHeight: minHeight,
    );
  }

  group('ExerciseVideoHeaderDelegate', () {
    test('exposes the configured extents', () {
      final header = delegate();

      expect(header.minExtent, 165);
      expect(header.maxExtent, 300);
    });

    test('rebuilds when playback or layout inputs change', () {
      final header = delegate();

      expect(header.shouldRebuild(delegate()), false);
      expect(header.shouldRebuild(delegate(autoPlay: true)), true);
      expect(header.shouldRebuild(delegate(playRequestId: 1)), true);
      expect(header.shouldRebuild(delegate(maxHeight: 320)), true);
      expect(header.shouldRebuild(delegate(minHeight: 180)), true);
      expect(
        header.shouldRebuild(
          delegate(
            item: const ExerciseEntity(
              id: 'exercise_other',
              exercise: 'Plank',
              difficultyLevel: 'Beginner',
              targetMuscleGroup: 'Core',
              primeMoverMuscle: 'Rectus Abdominis',
              primaryEquipment: 'Bodyweight',
              shortYoutubeDemonstrationLink: '',
              bodyRegion: 'Core',
              mechanics: 'Isolation',
            ),
          ),
        ),
        true,
      );
    });

    testWidgets('renders the player, hero info and back button', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(pinned: true, delegate: delegate()),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CustomVideoPlayer), findsOneWidget);
      expect(find.byType(ExerciseHeroInfo), findsOneWidget);
      expect(find.text('Core'), findsOneWidget);
      expect(find.text('Tap to play demo'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });
  });
}
