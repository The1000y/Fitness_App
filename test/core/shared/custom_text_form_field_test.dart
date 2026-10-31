import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithScreenUtil(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('CustomTextFormField', () {
    testWidgets('renders hint text and accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomTextFormField(
            controller: controller,
            hintText: 'Enter your email',
            prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 18),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pump();

      expect(controller.text, equals('test@example.com'));
    });

    testWidgets('calls onChanged callback when user types', (tester) async {
      String typed = '';

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomTextFormField(
            hintText: 'Type here',
            onChanged: (val) {
              typed = val;
            },
            prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 18),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'hello');
      await tester.pump();

      expect(typed, equals('hello'));
    });

    testWidgets('triggers validator in Form', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapWithScreenUtil(
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                  prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 18),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Field cannot be empty'), findsOneWidget);
    });

    testWidgets('toggles obscureText when isPassword is true and eye icon tapped', (tester) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          const CustomTextFormField(
            isPassword: true,
            hintText: 'Password',
            prefixIconConstraints: BoxConstraints(minWidth: 46, minHeight: 18),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // By default obscureText should be true and visibility_off icon shown
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      final textFieldFinder = find.byType(TextField);
      TextField textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isTrue);

      // Tap toggle icon
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isFalse);
    });
  });
}
