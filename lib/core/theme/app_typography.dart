import 'package:flutter/material.dart';

/// A static design token repository defining the application's global typographic scale.
///
/// This class is marked `final` and `abstract` to prevent sub-classing or direct
/// instantiation, ensuring a predictable text hierarchy across the presentation layer.
abstract final class AppTypography {
  // ==========================================
  // Explicit Font Size Tokens
  // ==========================================

  /// Font size for extra-large hero displays, splash titles, and primary headers.
  static const double sizeHeadingXl = 32.0;

  /// Font size for primary section headings and prominent feature titles.
  static const double sizeHeadingLg = 24.0;

  /// Font size for sub-section headers and standard modal/dialog titles.
  static const double sizeHeadingMd = 20.0;

  /// Font size for emphasized body copy, lists, or large interactive text blocks.
  static const double sizeBodyLg = 16.0;

  /// Font size for default standard reading text, paragraph elements, and inputs.
  static const double sizeBodyMd = 14.0;

  /// Font size for tertiary metadata, timestamp labels, and supportive micro-copy.
  static const double sizeCaption = 12.0;

  // ==========================================
  // Base Inter/System TextStyles
  // ==========================================

  /// Extra-large prominent headline style with a condensed letter spacing profile for tight text presentation.
  static const TextStyle headingXl = TextStyle(
    fontSize: sizeHeadingXl,
    fontWeight: FontWeight.bold,
    letterSpacing:
        -0.5, // Tightens up spacing for aesthetic presentation at scale.
  );

  /// Large section header style featuring a bold profile and slight character condensation.
  static const TextStyle headingLg = TextStyle(
    fontSize: sizeHeadingLg,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  /// Medium structural title style typically assigned to cards, list view headers, and dialogues.
  static const TextStyle headingMd = TextStyle(
    fontSize: sizeHeadingMd,
    fontWeight: FontWeight.w600,
  );

  /// Large body layout style for descriptive items needing increased legibility.
  static const TextStyle bodyLg = TextStyle(
    fontSize: sizeBodyLg,
    fontWeight: FontWeight.normal,
  );

  /// Medium body style enforcing standard reading behaviors across conversational streams or regular fields.
  static const TextStyle bodyMd = TextStyle(
    fontSize: sizeBodyMd,
    fontWeight: FontWeight.normal,
  );

  /// Microscopic caption layout style utilizing expanded tracks for enhanced reading clarity at small sizes.
  static const TextStyle caption = TextStyle(
    fontSize: sizeCaption,
    fontWeight: FontWeight.w400,
    letterSpacing:
        0.25, // Expands layout tracks slightly to assist reading low-scale blocks.
  );
}
