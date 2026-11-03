import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('CustomTextFormField', () {
    testWidgets('renders hint text and accepts user input', (tester) async {
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        _buildTestApp(
          CustomTextFormField(
            controller: controller,
            hintText: 'Enter email',
            onChanged: (val) => changedValue = val,
          ),
        ),
      );

      expect(find.text('Enter email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      expect(controller.text, 'test@example.com');
      expect(changedValue, 'test@example.com');
    });

    testWidgets(
      'toggles obscureText when visibility icon is pressed for password fields',
      (tester) async {
        await tester.pumpWidget(
          _buildTestApp(
            const CustomTextFormField(hintText: 'Password', isPassword: true),
          ),
        );

        final textFieldFinder = find.byType(TextField);
        expect(textFieldFinder, findsOneWidget);

        // Initially obscured
        TextField textField = tester.widget<TextField>(textFieldFinder);
        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Tap toggle button to show password
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        textField = tester.widget<TextField>(textFieldFinder);
        expect(textField.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        // Tap again to hide
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        textField = tester.widget<TextField>(textFieldFinder);
        expect(textField.obscureText, isTrue);
      },
    );

    testWidgets('displays validation error message when validator fails', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _buildTestApp(
          Form(
            key: formKey,
            child: CustomTextFormField(
              hintText: 'Required field',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Field is required' : null,
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Field is required'), findsOneWidget);
    });
  });
}
