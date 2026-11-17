import 'package:fitness_app/core/shared/helper/video_error_view.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('VideoErrorView', () {
    testWidgets('renders error icon, errorMessage, retry and back buttons', (
      tester,
    ) async {
      var retryTapped = false;
      var closeTapped = false;

      await tester.pumpApp(
        Scaffold(
          body: VideoErrorView(
            errorMessage: 'Unable to stream video',
            onRetry: () => retryTapped = true,
            onClose: () => closeTapped = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.videocam_off_rounded), findsOneWidget);
      expect(find.text('Unable to stream video'), findsOneWidget);
      expect(find.text(l10n.retry), findsOneWidget);
      expect(find.text(l10n.back), findsOneWidget);

      await tester.tap(find.text(l10n.retry));
      expect(retryTapped, isTrue);

      await tester.tap(find.text(l10n.back));
      expect(closeTapped, isTrue);
    });

    testWidgets('omits retry button when onRetry is null', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: VideoErrorView(errorMessage: 'Playback error', onClose: () {}),
        ),
      );

      expect(find.text('Playback error'), findsOneWidget);
      expect(find.text(l10n.retry), findsNothing);
      expect(find.text(l10n.back), findsOneWidget);
    });
  });
}
