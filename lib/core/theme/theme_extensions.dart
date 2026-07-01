import 'package:flutter/material.dart';

/// REDUCES BOILERPLATE: Eliminates repeating `Theme.of(context).textTheme...`
/// and prevents declaring redundant `final theme = Theme.of(context);` variables
/// at the top of every build method. Provides direct semantic shortcuts.

extension ThemeContextExtension on BuildContext {
  /// Directly exposes the active [ThemeData] structural configuration framework for this context node.
  ThemeData get theme => Theme.of(this);

  /// Directly exposes the [TextTheme] typographic system matrix populated by the ambient theme token provider.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Directly exposes the active [ColorScheme] color token mappings assigned to the matching presentation tree.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
