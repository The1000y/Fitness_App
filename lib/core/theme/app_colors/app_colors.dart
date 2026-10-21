import 'package:flutter/material.dart';

abstract final class AppColors {
  // ───── Base Colors ─────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ───── Primary (Orange) ─────
  static const MaterialColor primary = MaterialColor(0xFFFF4100, <int, Color>{
    50: Color(0xFFFFECE5),
    100: Color(0xFFFFD9CC),
    200: Color(0xFFFFB399),
    300: Color(0xFFFF7A4C),
    400: Color(0xFFFF5419),
    500: Color(0xFFFF4100),
    600: Color(0xFFE52700),
    700: Color(0xFFB20000),
    800: Color(0xFF7F0000),
    900: Color(0xFF330000),
  });

  // ───── Neutral (Grey) ─────
  static const MaterialColor neutral = MaterialColor(0xFF242424, <int, Color>{
    50: Color(0xFFE9E9E9),
    100: Color(0xFFD3D3D3),
    200: Color(0xFFBDBDBD),
    300: Color(0xFFA7A7A7),
    400: Color(0xFF919191),
    500: Color(0xFF242424),
    600: Color(0xFF202020),
    700: Color(0xFF191919),
    800: Color(0xFF111111),
    900: Color(0xFF0A0A0A),
  });

  // ───── Semantic Colors ─────
  static const Color background = neutral;
  static const Color textPrimary = white;
  static const Color textSecondary = Color(0xFFD3D3D3);

  // ───── Accent & Borders ─────
  static const Color accent = Color(0xFFFF6A00);
  static const Color border = Color(0xFFD9D9D9);
  static const Color borderSubtle = Color(0xFF2D2D2D);

  // ───── Surfaces & Transparency ─────
  static const Color overlay = Color(0x801A1A1A);
  static const Color scrim = Color(0x80000000);
  static const Color surface = Color(0x80242424);
  static const Color surfaceGlass = Color(0x1A242424);
  static const Color surfaceMuted = Color(0x33D3D3D3);

  // ───── Effects ─────
  static const Color shadow = Color(0x1A000000);
  static const Color glow = Color(0x40FF4100);
  static const Color transparent = Color(0x00000000);
}
