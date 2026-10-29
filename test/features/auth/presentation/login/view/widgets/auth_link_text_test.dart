import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_link_text.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('AuthLinkText', () {
    testWidgets(
      'shows label, calls onPressed, and bold applies FontWeight.w800',
      (tester) async {
        bool clicked = false;
        await tester.pumpApp(
          AuthLinkText(
            label: 'ClickMe',
            onPressed: () => clicked = true,
            bold: true,
          ),
        );

        expect(find.text('ClickMe'), findsOneWidget);

        final Text textWidget = tester.widget(find.text('ClickMe'));
        expect(textWidget.style?.fontWeight, FontWeight.w800);

        await tester.tap(find.text('ClickMe'));
        expect(clicked, true);
      },
    );
  });
}
