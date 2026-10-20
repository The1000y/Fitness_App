import 'dart:ui';

import 'package:flutter/material.dart';

class AppBlurEffect extends StatelessWidget {
  const AppBlurEffect({super.key, required this.child, this.sigma = 12});

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