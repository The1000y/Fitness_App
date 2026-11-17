import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/features/profile/presentation/view/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('ProfileMenuItem', () {
    testWidgets('renders a title and invokes onTap', (tester) async {
      var tapped = false;

      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: ProfileMenuItem(
              icon: AppIcons.profile,
              title: 'Edit profile',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);

      await tester.tap(find.text('Edit profile'));

      expect(tapped, isTrue);
    });

    testWidgets('supports a custom title widget and trailing widget', (
      tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(
          body: Center(
            child: ProfileMenuItem(
              icon: AppIcons.language,
              titleWidget: Text('Language'),
              trailing: Icon(Icons.check),
              onTap: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('uses a left chevron in right-to-left layouts', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: ProfileMenuItem(
              icon: AppIcons.profile,
              title: 'Edit profile',
              onTap: () {},
            ),
          ),
        ),
        locale: const Locale('ar'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });
  });
}
