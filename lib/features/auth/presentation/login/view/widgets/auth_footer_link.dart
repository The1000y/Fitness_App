import 'package:flutter/material.dart';

import 'auth_link_text.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.text,
    required this.linkLabel,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String linkLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.titleSmall),
        AuthLinkText(label: linkLabel, bold: true, onPressed: onPressed),
      ],
    );
  }
}
