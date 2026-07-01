import 'package:flutter/foundation.dart';

/// Base event class defining the user intents and actions for the application theme subsystem.
///
/// This class is marked `@immutable` to guarantee safe handling and prevent data mutations
/// inside state management pipelines.
@immutable
abstract class ThemeEvent {
  /// Instantiates a unmodifiable baseline event framework.
  const ThemeEvent();
}

/// Initial check triggered on application startup to load the cached configuration.
///
/// Dispatched during the early initialization cycle to evaluate and pull the persistent
/// storage track into memory before building the primary visual shell.
class ThemeInitRequested extends ThemeEvent {
  /// Instantiates a startup system init hook event tracking block.
  const ThemeInitRequested();
}

/// Dispatched from settings to manually toggle between Light and Dark mode options.
///
/// Triggers a cyclical sequence swap between layout profiles, moving from dark to light
/// or vice versa depending on the active state layout parameters.
class ThemeToggleRequested extends ThemeEvent {
  /// Instantiates an explicit user-driven toggle interaction event frame.
  const ThemeToggleRequested();
}
