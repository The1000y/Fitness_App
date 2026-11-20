import 'dart:async';

import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_fields_widget.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_form_widget.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_header_widget.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/profile_fakes.dart';
import '../../../../../helpers/pump_app.dart';

class MockEditProfileCubit extends Mock implements EditProfileCubit {}

void main() {
  late MockEditProfileCubit cubit;
  late StreamController<CommonUiEvent> uiEventStreamController;

  setUpAll(() {
    registerFallbackValue(
      const SaveEditProfileEvent(firstName: '', lastName: ''),
    );
    registerFallbackValue(const PickPhotoEvent());
  });

  setUp(() {
    cubit = MockEditProfileCubit();
    uiEventStreamController = StreamController<CommonUiEvent>.broadcast();

    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.uiEventStream).thenAnswer((_) => uiEventStreamController.stream);
    when(() => cubit.state).thenReturn(
      const EditProfileState(
        initialProfile: testProfile,
        weight: 60.5,
        goal: 'fitness',
        activityLevel: 'level3',
      ),
    );
    when(() => cubit.doEvent(any())).thenAnswer((_) async {});
    when(() => cubit.close()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await uiEventStreamController.close();
  });

  Widget buildSubject() {
    return BlocProvider<EditProfileCubit>.value(
      value: cubit,
      child: const EditProfileView(),
    );
  }

  group('EditProfileView', () {
    testWidgets('renders all major sections and initial profile values in fields', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      expect(find.byType(EditProfileView), findsOneWidget);
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.byType(EditProfileHeaderWidget), findsOneWidget);
      expect(find.byType(EditProfileFormWidget), findsOneWidget);
      expect(find.byType(EditProfileFieldsWidget), findsOneWidget);

      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Lovelace'), findsOneWidget);
      expect(find.text('ada@example.com'), findsOneWidget);
    });

    testWidgets('renders gracefully when initialProfile in state is null', (tester) async {
      when(() => cubit.state).thenReturn(const EditProfileState());

      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      expect(find.byType(EditProfileView), findsOneWidget);
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.byType(EditProfileFormWidget), findsOneWidget);
    });

    testWidgets('tapping back button triggers save and dispatches SaveEditProfileEvent with current text', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      final backButton = find.byType(IconButton);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pump();

      verify(
        () => cubit.doEvent(
          any(
            that: isA<SaveEditProfileEvent>()
                .having((e) => e.firstName, 'firstName', 'Ada')
                .having((e) => e.lastName, 'lastName', 'Lovelace'),
          ),
        ),
      ).called(1);
    });

    testWidgets('editing text fields and tapping back button dispatches SaveEditProfileEvent with updated text', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      final firstNameField = find.widgetWithText(CustomTextFormField, 'Ada');
      await tester.enterText(firstNameField, 'Grace');

      final lastNameField = find.widgetWithText(CustomTextFormField, 'Lovelace');
      await tester.enterText(lastNameField, 'Hopper');

      final backButton = find.byType(IconButton);
      await tester.tap(backButton);
      await tester.pump();

      verify(
        () => cubit.doEvent(
          any(
            that: isA<SaveEditProfileEvent>()
                .having((e) => e.firstName, 'firstName', 'Grace')
                .having((e) => e.lastName, 'lastName', 'Hopper'),
          ),
        ),
      ).called(1);
    });

    testWidgets('PopScope onPopInvokedWithResult triggers save when didPop is false', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      final popScopeFinder = find.byWidgetPredicate((w) => w is PopScope);
      expect(popScopeFinder, findsOneWidget);

      final popScope = tester.widget<PopScope<Object?>>(popScopeFinder);
      expect(popScope.canPop, isFalse);

      popScope.onPopInvokedWithResult?.call(false, null);
      await tester.pump();

      verify(
        () => cubit.doEvent(
          any(
            that: isA<SaveEditProfileEvent>()
                .having((e) => e.firstName, 'firstName', 'Ada')
                .having((e) => e.lastName, 'lastName', 'Lovelace'),
          ),
        ),
      ).called(1);
    });

    testWidgets('BaseUiEventListener shows SnackBar when ShowSuccessMessage is emitted', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      uiEventStreamController.add(
        const ShowSuccessMessage(AppSuccessMessage.profileUpdated),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('BaseUiEventListener shows SnackBar when ShowFailureMessage is emitted', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        size: const Size(375, 900),
      );

      uiEventStreamController.add(
        const ShowFailureMessage(ServerFailure()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('renders properly with Arabic locale and translated strings', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        locale: const Locale('ar'),
        size: const Size(375, 900),
      );

      expect(find.byType(EditProfileView), findsOneWidget);
      expect(find.text('تعديل الملف الشخصي'), findsOneWidget);
      expect(find.text('اسم العائلة'), findsOneWidget);
      expect(find.text('الاسم الأول'), findsOneWidget);
    });
  });
}
