import 'package:flutter/material.dart';

class AppBackgroundImage extends StatelessWidget {
  const AppBackgroundImage({
    super.key,
    required this.backgroundImage,
    required this.child,
  });

  final String backgroundImage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(backgroundImage, fit: BoxFit.fill)),
        child,
      ],
    );
  }
}