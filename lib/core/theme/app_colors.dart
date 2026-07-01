import 'package:flutter/material.dart';

/// A static design token repository defining the application's global color system.
///
/// This class is marked `final` and `abstract` to prevent sub-classing or direct
/// instantiation, serving exclusively as a structural style configuration layout.
abstract final class AppColors {
  // ==========================================
  // Brand Palette
  // ==========================================

  /// The primary accent hue utilized for dominant call-to-action buttons, highlights, and focal states.
  static const Color primary = Color(0xFF6366F1); // Indigo

  /// The secondary accent hue utilized to complement the primary brand direction or denote alternative emphasis.
  static const Color secondary = Color(0xFF10B981); // Emerald

  // ==========================================
  // Dark Neutral (Default Theme Mode Focus)
  // ==========================================

  /// The foundation layer background canvas for dark mode user interfaces.
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900

  /// The elevated structural layer (e.g., cards, dialogs, bottom sheets) for dark mode.
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800

  /// High-contrast primary typographic copy elements optimized for dark canvas backgrounds.
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate 50

  /// Medium-contrast supportive typographic elements, descriptions, and metadata for dark canvas backgrounds.
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400

  // ==========================================
  // Light Neutral
  // ==========================================

  /// The foundation layer background canvas for light mode user interfaces.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// The elevated structural layer (e.g., cards, components) for light mode layouts.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// High-contrast primary typographic copy elements optimized for light canvas backgrounds.
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Medium-contrast supportive typographic elements and metadata for light canvas backgrounds.
  static const Color textSecondaryLight = Color(0xFF64748B);

  // ==========================================
  // Status Codes
  // ==========================================

  /// Semantic color token used across the app to denote destructive actions, failures, or critical field validation alerts.
  static const Color error = Color(0xFFEF4444);

  /// Semantic color token used to represent completed operations, verified confirmations, or successful state thresholds.
  static const Color success = Color(0xFF10B981);
}
