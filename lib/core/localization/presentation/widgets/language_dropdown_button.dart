import 'package:flutter/material.dart';
import 'package:yemengram/core/localization/generated/app_localizations.dart';
import 'package:yemengram/core/theme/theme_extensions.dart';

/// A UI widget that displays a menu for users to choose their preferred app language.
///
/// It displays the available languages loaded from the app's ARB files and notifies
/// the parent widget whenever a new language is selected.
class LanguageDropdownButton extends StatelessWidget {
  /// The current language code currently active in the app.
  final Locale currentLocale;

  /// A callback function that triggers when the user selects a different language.
  final ValueChanged<Locale> onLocaleChanged;

  /// Creates a language selection button with the required initial settings.
  const LanguageDropdownButton({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  // Converts short language codes (like 'en') into human-readable native names (like 'English').
  String _getNativeLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'ar':
        return 'العربية';
      default:
        return languageCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      // Limit the menu so it Only shows 2.5 items
      constraints: const BoxConstraints(maxHeight: 135),
      initialValue: currentLocale,
      child: Text(
        _getNativeLanguageName(currentLocale.languageCode),
        style: context.textTheme.labelLarge,
      ),
      onSelected: (Locale? newLocale) {
        if (newLocale != null) {
          onLocaleChanged(newLocale);
        }
      },
      itemBuilder: (BuildContext context) {
        // Loops through all languages supported by the app and generates a menu item for each.
        return AppLocalizations.supportedLocales.map((Locale locale) {
          return PopupMenuItem<Locale>(
            value: locale,
            child: Text(_getNativeLanguageName(locale.languageCode)),
          );
        }).toList();
      },
    );
  }
}
