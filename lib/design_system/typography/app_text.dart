import 'package:flutter/material.dart';

enum TextVariant { h1, h2, h3, body, caption }

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.variant = TextVariant.body,
    this.color,
    this.textAlign,
  });

  final String text;
  final TextVariant variant;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: _getTextStyle().copyWith(color: color),
    );
  }

  TextStyle _getTextStyle() {
    return switch (variant) {
      TextVariant.h1 => const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      TextVariant.h2 => const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      TextVariant.h3 => const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      TextVariant.body => const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
      TextVariant.caption => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.4,
          color: Colors.grey[600],
        ),
    };
  }
}
