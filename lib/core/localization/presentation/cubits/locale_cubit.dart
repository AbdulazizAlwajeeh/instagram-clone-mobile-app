import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemengram/core/localization/domain/repositories/locale_repository.dart';
import '../../generated/app_localizations.dart';

/// Business logic component managing application localization configuration and runtime mutations.
///
/// Communicates directly with an abstract [LocaleRepository] interface boundary, converting
/// persistent storage footprints into predictable [Locale] stream state adjustments.
class LocaleCubit extends Cubit<Locale> {
  /// The abstract repository bridge handling internal regional configuration persistence.
  final LocaleRepository _localeRepository;

  /// Creates a business controller instance and primes the initial runtime state.
  LocaleCubit(this._localeRepository)
    : super(_getInitialLocale(_localeRepository));

  /// Evaluates local storage lookups on cold boot sequences to recover user language profiles.
  static Locale _getInitialLocale(LocaleRepository repo) {
    // Queries the underlying repository boundary for stored language code configurations.
    final result = repo.getCachedLanguageCode();

    final activeLocale = result.fold((failure) => const Locale('en'), (code) {
      if (code != null) {
        final cachedLocale = Locale(code);
        if (AppLocalizations.supportedLocales.contains(cachedLocale)) {
          return cachedLocale;
        }
      }
      // Defaults to English
      return const Locale('en');
    });

    return activeLocale;
  }

  /// Updates the active language state globally across the app
  void changeLocale(Locale newLocale) {
    if (state == newLocale) return;

    // Safety check: ensure the language is actually generated in our ARB system
    if (AppLocalizations.supportedLocales.contains(newLocale)) {
      emit(newLocale);
      _localeRepository.cacheLanguageCode(newLocale.languageCode);
    }
  }
}
