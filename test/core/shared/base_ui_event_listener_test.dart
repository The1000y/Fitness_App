import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/pump_app.dart';

final class _CustomTestEvent extends BaseUiEvent {
  final String payload;
  const _CustomTestEvent(this.payload);
}

class _TestCubit extends BaseCubit<int, BaseUiEvent> {
  _TestCubit() : super(0);

  void triggerEvent(BaseUiEvent event) {
    emitEvent(event);
  }
}

void main() {
  late _TestCubit cubit;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    cubit = _TestCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('BaseUiEventListener', () {
    testWidgets('shows failure SnackBar when ShowFailureMessage event is emitted', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: BaseUiEventListener<_TestCubit, int, BaseUiEvent>(
            cubit: cubit,
            child: const Text('Child Content'),
          ),
        ),
      );

      expect(find.text('Child Content'), findsOneWidget);

      cubit.triggerEvent(const ShowFailureMessage(InternetConnectionFailure()));
      await tester.pumpAndSettle();

      expect(find.text(l10n.failureInternetConnection), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('delegates custom event to onCustomEvent callback', (tester) async {
      String? receivedPayload;

      await tester.pumpApp(
        Scaffold(
          body: BaseUiEventListener<_TestCubit, int, BaseUiEvent>(
            cubit: cubit,
            onCustomEvent: (context, event) {
              if (event is _CustomTestEvent) {
                receivedPayload = event.payload;
              }
            },
            child: const Text('Child Content'),
          ),
        ),
      );

      cubit.triggerEvent(const _CustomTestEvent('Custom Action'));
      await tester.pump();

      expect(receivedPayload, 'Custom Action');
    });
  });
}
