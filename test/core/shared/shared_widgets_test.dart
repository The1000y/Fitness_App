import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('ImageTitleCard', () {
    testWidgets('renders its title and responds to taps', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          ImageTitleCard(
            imagePath: 'assets/images/robot_chat.png',
            title: 'Strength',
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Strength'), findsOneWidget);

      final card = tester.widget<Container>(
        find.descendant(
          of: find.byType(ImageTitleCard),
          matching: find.byType(Container),
        ),
      );
      final cardSize = tester.getSize(
        find.descendant(
          of: find.byType(ImageTitleCard),
          matching: find.byType(Container),
        ),
      );
      expect(cardSize.width, 170.w);
      expect(cardSize.height, 170.h);
      final decoration = card.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16.r));
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      expect(image.colorBlendMode, BlendMode.darken);

      await tester.tap(find.text('Strength'));
      expect(tapped, isTrue);
    });

    testWidgets('loads an HTTPS URL with CachedNetworkImage', (tester) async {
      const imageUrl = 'https://images.example.com/muscle.png';

      await tester.pumpWidget(
        _buildTestApp(
          const ImageTitleCard(
            imagePath: imageUrl,
            title: 'Chest',
            onTap: _noop,
          ),
        ),
      );

      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.imageUrl, imageUrl);
      expect(cachedImage.errorWidget, isNotNull);
      expect(tester.takeException(), isNull);
    });
  });

  group('CategoryTabBar', () {
    testWidgets('styles selected category and reports selection', (
      tester,
    ) async {
      String? selected;

      await tester.pumpWidget(
        _buildTestApp(
          CategoryTabBar(
            categories: const ['All', 'Yoga'],
            selectedCategory: 'All',
            onCategorySelected: (category) => selected = category,
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Yoga'), findsOneWidget);

      final chips = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(
        (chips.first.decoration! as BoxDecoration).color,
        AppColors.primary,
      );
      expect(
        (chips.last.decoration! as BoxDecoration).color,
        Colors.transparent,
      );
      expect(tester.getSize(find.byType(SizedBox).first).height, 48.h);

      await tester.tap(find.text('Yoga'));
      expect(selected, 'Yoga');
    });
  });
}

void _noop() {}
