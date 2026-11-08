import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeView', () {
    testWidgets('renders CustomBackgroundImage and transparent Scaffold', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeView()));

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(CustomBackgroundImage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.transparent);
    });
  });
}
