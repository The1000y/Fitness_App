import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/chat/presentation/view/chat_view.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/profile_fakes.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockProfileCubit mockProfileCubit;

  setUp(() {
    mockProfileCubit = MockProfileCubit();
    when(() => mockProfileCubit.state).thenReturn(const ProfileState());
    when(() => mockProfileCubit.stream).thenAnswer((_) => const Stream.empty());

    if (getIt.isRegistered<ProfileCubit>()) {
      getIt.unregister<ProfileCubit>();
    }
    getIt.registerSingleton<ProfileCubit>(mockProfileCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<ProfileCubit>()) {
      getIt.unregister<ProfileCubit>();
    }
  });

  group('ChatView', () {
    testWidgets('renders CustomBackgroundImage and transparent Scaffold', (
      tester,
    ) async {
      await tester.pumpApp(const ChatView());

      expect(find.byType(ChatView), findsOneWidget);
      expect(find.byType(CustomBackgroundImage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.transparent);
    });
  });
}
