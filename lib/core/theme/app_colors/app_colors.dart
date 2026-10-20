import 'package:flutter/material.dart';

abstract final class AppColors {
  // ───── Palette ─────
  static const white = Color(0xffFFFFFF);
  static const black = Color(0xFF000000);

  // Neutral (grey): من الغامق للفاتح
  static const neutral = Color(0xFF242424);
  static const neutralDark1 = Color(0xFF0A0A0A);
  static const neutralLight1 = Color(0xFF3A3A3A);
  static const neutralLight2 = Color(0xFF505050);
  static const neutralLight3 = Color(0xFF666666);
  static const neutralLight4 = Color(0xFF7C7C7C);
  static const neutralLight5 = Color(0xFF919191);
  static const neutralLight6 = Color(0xFFA7A7A7);
  static const neutralLight7 = Color(0xFFBDBDBD);
  static const neutralLight8 = Color(0xFFD3D3D3);
  static const neutralLight9 = Color(0xFFE9E9E9);

  // Primary (orange)
  static const primary = Color(0xFFFF4100);
  static const primaryLight1 = Color(0xFFFF5419);
  static const primaryLight2 = Color(0xFFFF6733);
  static const primaryLight3 = Color(0xFFFF7A4C);
  static const primaryLight4 = Color(0xFFFF8D66);
  static const primaryLight5 = Color(0xFFFFA07F);
  static const primaryLight6 = Color(0xFFFFB399);
  static const primaryLight7 = Color(0xFFFFC6B2);
  static const primaryLight8 = Color(0xFFFFD9CC);
  static const primaryLight9 = Color(0xFFFFECE5);
  static const primaryDark1 = Color(0xFFE52700);
  static const primaryDark2 = Color(0xFFCC0E00);
  static const primaryDark3 = Color(0xFFB20000);
  static const primaryDark4 = Color(0xFF990000);
  static const primaryDark5 = Color(0xFF7F0000);
  static const primaryDark6 = Color(0xFF660000);
  static const primaryDark7 = Color(0xFF4C0000);
  static const primaryDark8 = Color(0xFF330000);
  static const primaryDark9 = Color(0xFF190000);

  // ───── Semantic ─────
  static const background = neutral;
  static const textPrimary = white;
  static const textSecondary = neutralLight8;

  // خارج الـ palette (زي ما هي في الـ Figma)
  static const accent = Color(0xFFFF6A00);
  static const border = Color(0xFFD9D9D9);
  static const borderSubtle = Color(0xFF2D2D2D);

  // بشفافية (hex فيه alpha جوه عشان تفضل const)
  static const overlay = Color(0x801A1A1A);      // فوق صورة الخلفية
  static const scrim = Color(0x80000000);        // dim فوق الصور
  static const surface = Color(0x80242424);      // الكروت
  static const surfaceGlass = Color(0x1A242424); // كارت الـ Login
  static const surfaceMuted = Color(0x33D3D3D3); // خيارات غير مختارة
  static const shadow = Color(0x1A000000);
  static const glow = Color(0x40FF4100);
}