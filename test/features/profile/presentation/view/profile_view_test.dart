import 'dart:async';

import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/profile_fakes.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockProfileCubit profileCubit;
  late MockAppLocaleCubit localeCubit;

  setUp(() {
    profileCubit = MockProfileCubit();
    localeCubit = MockAppLocaleCubit();

    when(() => profileCubit.state).thenReturn(
      const ProfileState(
        profileState: BaseState<ProfileEntity>(data: testProfile),
      ),
    );
    when(
      () => profileCubit.stream,
    ).thenAnswer((_) => const Stream<ProfileState>.empty());
    when(
      () => profileCubit.uiEventStream,
    ).thenAnswer((_) => const Stream<CommonUiEvent>.empty());
    when(() => localeCubit.state).thenReturn(const Locale('en'));
    when(
      () => localeCubit.stream,
    ).thenAnswer((_) => const Stream<Locale>.empty());
    when(() => localeCubit.toggle()).thenAnswer((_) async {});
  });

  Future<void> pumpProfile(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) {
    return tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<AppLocaleCubit>.value(value: localeCubit),
        ],
        child: const ProfileView(),
      ),
      locale: locale,
    );
  }

  group('ProfileView', () {
    testWidgets('renders the profile header and menu', (tester) async {
      await pumpProfile(tester);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('renders translated content in Arabic', (tester) async {
      await pumpProfile(tester, locale: const Locale('ar'));
      await tester.pumpAndSettle();

      expect(find.text('الملف الشخصي'), findsOneWidget);
      expect(find.text('تعديل الملف الشخصي'), findsOneWidget);
      expect(find.text('تسجيل الخروج'), findsOneWidget);
    });
  });
}
