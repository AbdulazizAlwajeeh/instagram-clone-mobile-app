import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// A static design token bridge that assembles foundational global visual themes.
///
/// This class is marked `final` and `abstract` to prevent instantiation, serving
/// exclusively as the engine that maps [AppColors] and [AppTypography] to Material 3 themes.
abstract final class AppTheme {
  /// Generates the system default [ThemeData] optimized for low-light execution environments.
  ///
  /// Employs a Material 3 design spec utilizing [AppColors.backgroundDark] for underlying
  /// canvas sheets and matches font weight structures to high-contrast variations.
  static ThemeData get darkTheme {
    return ThemeData(
      // Forces adherence to Material Design 3 specification boundaries.
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.headingXl.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: AppTypography.headingLg.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: AppTypography.headingMd.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: AppTypography.bodyLg.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppTypography.bodyMd.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        labelSmall: AppTypography.caption.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }

  /// Generates the system secondary [ThemeData] optimized for high-glare execution environments.
  ///
  /// Employs a Material 3 design spec utilizing [AppColors.backgroundLight] for underlying
  /// canvas sheets and matches font weight structures to low-reflection color values.
  static ThemeData get lightTheme {
    return ThemeData(
      // Forces adherence to Material Design 3 specification boundaries.
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.headingXl.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        headlineMedium: AppTypography.headingLg.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        titleLarge: AppTypography.headingMd.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: AppTypography.bodyLg.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: AppTypography.bodyMd.copyWith(
          // Maps to muted presentation values for secondary hierarchies.
          color: AppColors.textSecondaryLight,
        ),
        labelSmall: AppTypography.caption.copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
