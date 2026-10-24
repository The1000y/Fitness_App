import 'package:flutter/material.dart';

abstract class AppTextTheme {
  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
      
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
       fontFamily: 'BalooThambi2',
    ),
  );
}
