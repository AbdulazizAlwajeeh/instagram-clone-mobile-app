import 'package:flutter/material.dart';

@immutable
abstract class ThemeState {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);
}

/// Initial default startup state before local storage resolution.
class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(ThemeMode.system);
}

/// Emitted while reading or writing preferences asynchronously.
class ThemeLoading extends ThemeState {
  const ThemeLoading(super.themeMode);
}

/// Emitted when preference resolution is verified and ready for rendering.
class ThemeLoaded extends ThemeState {
  const ThemeLoaded(super.themeMode);
}

/// Non-blocking state emitted when caching fails, providing raw error logs.
class ThemeError extends ThemeState {
  final String errorMessage;

  const ThemeError(super.themeMode, this.errorMessage);
}
