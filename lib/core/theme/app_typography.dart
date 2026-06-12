import 'package:flutter/material.dart';

abstract final class AppTypography {
  // Explicit Font Size Tokens
  static const double sizeHeadingXl = 32.0;
  static const double sizeHeadingLg = 24.0;
  static const double sizeHeadingMd = 20.0;
  static const double sizeBodyLg = 16.0;
  static const double sizeBodyMd = 14.0;
  static const double sizeCaption = 12.0;

  // Base Inter/System TextStyles
  static const TextStyle headingXl = TextStyle(
    fontSize: sizeHeadingXl,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle headingLg = TextStyle(
    fontSize: sizeHeadingLg,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  static const TextStyle headingMd = TextStyle(
    fontSize: sizeHeadingMd,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: sizeBodyLg,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: sizeBodyMd,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    fontSize: sizeCaption,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
}
