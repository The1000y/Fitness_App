import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBlurEffect extends StatelessWidget {
  const CustomBlurEffect({super.key, required this.child, this.sigma = 12});

  final Widget child;
  final double sigma;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: sigma, sigmaX: sigma),
      child: child,
    );
  }
}