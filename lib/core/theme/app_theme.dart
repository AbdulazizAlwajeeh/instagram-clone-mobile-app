import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
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

  static ThemeData get lightTheme {
    return ThemeData(
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
          color: AppColors.textSecondaryLight,
        ),
        labelSmall: AppTypography.caption.copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}
