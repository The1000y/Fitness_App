abstract final class AppImages {
  AppImages._();

  static const String _basePath = 'assets/images';

  static const String logo = '$_basePath/logo.png';
  static const String logoSvg = '$_basePath/svgs/logo.svg';
  static const String robotChat = '$_basePath/robot_chat.png';
  static const String robotSkippingWithARope =
      '$_basePath/robot_skipping_with_a_rope.png';

  // Backgrounds
  static const String authBackground =
      '$_basePath/backgrounds/auth_background.png';
  static const String chatBackground =
      '$_basePath/backgrounds/chat_background.png';
  static const String layoutBackground =
      '$_basePath/backgrounds/layout_background.png';
  static const String onboardingBackground =
      '$_basePath/backgrounds/onboarding_background.png';

  // Avatars (O15_1 to O15_36)
  static String avatar(int index) => '$_basePath/avatars/O15_$index.png';

  // Test images (test1 to test10)
  static String test(int index) => '$_basePath/test/test$index.png';
}
