import 'package:flutter/material.dart';

/// REDUCES BOILERPLATE: Eliminates repeating `Theme.of(context).textTheme...`
/// and prevents declaring redundant `final theme = Theme.of(context);` variables
/// at the top of every build method. Provides direct semantic shortcuts.

extension ThemeContextExtension on BuildContext {
  // Directly exposes the ThemeData object
  ThemeData get theme => Theme.of(this);

  // Directly exposes the textTheme matrix
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Directly exposes the colorScheme palette
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}