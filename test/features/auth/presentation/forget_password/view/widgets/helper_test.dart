import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/widgets/helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Helper pin themes', () {
    test('focusPinTheme has correct primary color and dimensions', () {
      final theme = Helper.focusPinTheme;
      expect(theme.width, equals(56));
      expect(theme.height, equals(60));
      expect(theme.textStyle?.color, equals(AppColors.primary));
    });

    test('defultPinTheme has correct textPrimary color', () {
      final theme = Helper.defultPinTheme;
      expect(theme.width, equals(56));
      expect(theme.height, equals(60));
      expect(theme.textStyle?.color, equals(AppColors.textPrimary));
    });

    test('submittedPinTheme is not null and has correct primary color', () {
      final theme = Helper.submittedPinTheme;
      expect(theme, isNotNull);
      expect(theme?.width, equals(56));
      expect(theme?.height, equals(60));
      expect(theme?.textStyle?.color, equals(AppColors.primary));
    });
  });
}
