import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  group('EditProfileFormWidget', () {
    late TextEditingController firstNameController;
    late TextEditingController lastNameController;
    late TextEditingController emailController;

    setUp(() {
      firstNameController = TextEditingController(text: 'Ada');
      lastNameController = TextEditingController(text: 'Lovelace');
      emailController = TextEditingController(text: 'ada@example.com');
    });

    tearDown(() {
      firstNameController.dispose();
      lastNameController.dispose();
      emailController.dispose();
    });

    testWidgets('renders all three text form fields with correct initial text and hints', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EditProfileFormWidget(
            firstName: firstNameController,
            lastName: lastNameController,
            email: emailController,
          ),
        ),
      );

      expect(find.byType(CustomTextFormField), findsNWidgets(3));
      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Lovelace'), findsOneWidget);
      expect(find.text('ada@example.com'), findsOneWidget);
    });

    testWidgets('email field is read-only while name fields are editable', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EditProfileFormWidget(
            firstName: firstNameController,
            lastName: lastNameController,
            email: emailController,
          ),
        ),
      );

      final fields = tester.widgetList<CustomTextFormField>(find.byType(CustomTextFormField)).toList();
      expect(fields[0].readOnly, isFalse);
      expect(fields[1].readOnly, isFalse);
      expect(fields[2].readOnly, isTrue);
    });

    testWidgets('entering text updates the respective TextEditingControllers', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EditProfileFormWidget(
            firstName: firstNameController,
            lastName: lastNameController,
            email: emailController,
          ),
        ),
      );

      final firstNameField = find.widgetWithText(CustomTextFormField, 'Ada');
      await tester.enterText(firstNameField, 'Grace');
      expect(firstNameController.text, 'Grace');

      final lastNameField = find.widgetWithText(CustomTextFormField, 'Lovelace');
      await tester.enterText(lastNameField, 'Hopper');
      expect(lastNameController.text, 'Hopper');
    });

    testWidgets('renders properly with Arabic localization', (tester) async {
      final arFirstName = TextEditingController();
      final arLastName = TextEditingController();
      final arEmail = TextEditingController();

      await tester.pumpApp(
        Scaffold(
          body: EditProfileFormWidget(
            firstName: arFirstName,
            lastName: arLastName,
            email: arEmail,
          ),
        ),
        locale: const Locale('ar'),
      );

      expect(find.text('الاسم الأول'), findsOneWidget);
      expect(find.text('اسم العائلة'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);

      arFirstName.dispose();
      arLastName.dispose();
      arEmail.dispose();
    });
  });
}
