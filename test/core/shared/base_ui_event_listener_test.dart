import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class CustomTestEvent extends BaseUiEvent {
  const CustomTestEvent();
}

class TestBaseCubit extends BaseCubit<int, BaseUiEvent> {
  TestBaseCubit() : super(0);

  void sendEvent(BaseUiEvent event) {
    emitEvent(event);
  }
}

Widget wrapWithApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  late TestBaseCubit cubit;

  setUp(() {
    cubit = TestBaseCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('BaseUiEventListener', () {
    testWidgets('shows success SnackBar when ShowSuccessMessage is emitted', (tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          BaseUiEventListener<TestBaseCubit, int, BaseUiEvent>(
            cubit: cubit,
            child: const Text('Listener Child'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      cubit.sendEvent(const ShowSuccessMessage(AppSuccessMessage.accountCreated));
      await tester.pump(); // Start SnackBar animation
      await tester.pump(const Duration(milliseconds: 300)); // Finish appearance

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows failure SnackBar when ShowFailureMessage is emitted', (tester) async {
      await tester.pumpWidget(
        wrapWithApp(
          BaseUiEventListener<TestBaseCubit, int, BaseUiEvent>(
            cubit: cubit,
            child: const Text('Listener Child'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      cubit.sendEvent(const ShowFailureMessage(InternetConnectionFailure()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('calls onCustomEvent callback when non-common event is emitted', (tester) async {
      bool customEventCalled = false;

      await tester.pumpWidget(
        wrapWithApp(
          BaseUiEventListener<TestBaseCubit, int, BaseUiEvent>(
            cubit: cubit,
            onCustomEvent: (context, event) {
              if (event is CustomTestEvent) {
                customEventCalled = true;
              }
            },
            child: const Text('Listener Child'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      cubit.sendEvent(const CustomTestEvent());
      await tester.pump();

      expect(customEventCalled, isTrue);
    });
  });
}
