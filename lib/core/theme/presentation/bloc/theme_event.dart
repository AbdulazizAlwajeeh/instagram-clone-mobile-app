import 'package:flutter/foundation.dart';

@immutable
abstract class ThemeEvent {
  const ThemeEvent();
}

/// Initial check triggered on application startup to load the cached configuration.
class ThemeInitRequested extends ThemeEvent {
  const ThemeInitRequested();
}

/// Dispatched from settings to manually toggle between Light and Dark mode options.
class ThemeToggleRequested extends ThemeEvent {
  const ThemeToggleRequested();
}
