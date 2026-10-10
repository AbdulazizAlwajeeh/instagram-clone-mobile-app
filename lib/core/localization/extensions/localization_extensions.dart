import 'package:flutter/material.dart';
import 'package:yemengram/core/localization/generated/app_localizations.dart';

/// REDUCES BOILERPLATE: Eliminates repeating `AppLocalizations.of(context)!`
/// and prevents declaring redundant `final l10n = AppLocalizations.of(context)!;`
/// variables at the top of every build method. Provides a direct semantic shortcut.

extension LocalizationContextExtensions on BuildContext {
  /// Directly exposes the active [AppLocalizations] translation framework for this context node.
  /// Throws an exception if localization is not properly configured in the widget tree.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
