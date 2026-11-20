
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/profile_fakes.dart';
import '../../../../../../helpers/pump_app.dart';

class MockEditProfileCubit extends Mock implements EditProfileCubit {}

void main() {
  late MockEditProfileCubit cubit;

  setUpAll(() {
    registerFallbackValue(const PickPhotoEvent());
  });

  setUp(() {
    cubit = MockEditProfileCubit();
    when(() => cubit.doEvent(any())).thenAnswer((_) async {});
  });

  void stubState(EditProfileState state) {
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));
  }

  Widget buildSubject() {
    return BlocProvider<EditProfileCubit>.value(
      value: cubit,
      child: const Scaffold(
        body: Center(
          child: EditProfileHeaderWidget(),
        ),
      ),
    );
  }

  group('EditProfileHeaderWidget', () {
    testWidgets('renders fallback person icon and full name when photo is empty', (tester) async {
      stubState(const EditProfileState(initialProfile: testProfile));

      await tester.pumpApp(buildSubject());

      expect(find.byType(EditProfileHeaderWidget), findsOneWidget);
      expect(find.text(testProfile.fullName), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('renders CachedNetworkImage when remote photo URL is provided', (tester) async {
      const profileWithPhoto = ProfileEntity(
        id: 'user-2',
        firstName: 'Marie',
        lastName: 'Curie',
        email: 'marie@example.com',
        gender: 'female',
        age: 35,
        weight: 55.0,
        height: 165.0,
        activityLevel: 'level3',
        goal: 'fitness',
        photo: 'https://example.com/avatar.jpg',
      );
      stubState(const EditProfileState(initialProfile: profileWithPhoto));

      await tester.pumpApp(buildSubject());

      expect(find.text('Marie Curie'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders Image.file when pickedPhotoPath is set', (tester) async {
      stubState(
        const EditProfileState(
          initialProfile: testProfile,
          pickedPhotoPath: '/path/to/local/picked_image.jpg',
        ),
      );

      await tester.pumpApp(buildSubject());

      expect(find.text(testProfile.fullName), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders empty name string when profile is null', (tester) async {
      stubState(const EditProfileState());

      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text(''), findsWidgets);
    });

    testWidgets('tapping edit photo icon triggers PickPhotoEvent on cubit', (tester) async {
      stubState(const EditProfileState(initialProfile: testProfile));

      await tester.pumpApp(buildSubject());

      final editIconFinder = find.byIcon(Icons.edit);
      expect(editIconFinder, findsOneWidget);

      await tester.tap(editIconFinder);
      await tester.pump();

      verify(() => cubit.doEvent(const PickPhotoEvent())).called(1);
    });
  });
}
