import 'package:flutter/material.dart';

/// Base state class governing the active application theme settings configuration.
///
/// This class is marked `@immutable` to guarantee thread-safe state distribution pipelines
/// across state management emission streams.
@immutable
abstract class ThemeState {
  /// The reactive visual mode token tracking how the platform should evaluate canvas presentation layers.
  final ThemeMode themeMode;

  /// Creates a unified tracking state variant containing the configured [themeMode].
  const ThemeState(this.themeMode);
}

/// Initial default startup state before local storage resolution.
///
/// Defaults explicitly to [ThemeMode.system] layout configurations to preserve immediate,
/// localized platform display styles during cold boots.
class ThemeInitial extends ThemeState {
  /// Creates the structural default foundation state configuration.
  const ThemeInitial() : super(ThemeMode.system);
}

/// Emitted while reading or writing preferences asynchronously.
///
/// Holds onto the last evaluated active [ThemeMode] sequence to maintain smooth UI continuity
/// and prevent flickering during persistence execution blocks.
class ThemeLoading extends ThemeState {
  /// Creates a transitional loading boundary carrying the active [themeMode] footprint.
  const ThemeLoading(super.themeMode);
}

/// Emitted when preference resolution is verified and ready for rendering.
///
/// Signals presentation modules to commit the updated [ThemeMode] configurations
/// cleanly across the widget construction hierarchy.
class ThemeLoaded extends ThemeState {
  /// Creates a stable, finalized state layout configuration.
  const ThemeLoaded(super.themeMode);
}

/// Non-blocking state emitted when caching fails, providing raw error logs.
///
/// Preserves the last valid runtime [ThemeMode] configuration, allowing the user interface to
/// degrade gracefully without crashing or forcing unwanted UI flashes.
class ThemeError extends ThemeState {
  /// The descriptive, user-facing or telemetry logging error message block.
  final String errorMessage;

  /// Creates a localized fallback error frame with explicit structural data preservation parameters.
  const ThemeError(super.themeMode, this.errorMessage);
}
