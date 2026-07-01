import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/theme_repository.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// Business logic component managing application theme resolution and mutations.
///
/// Intercepts incoming [ThemeEvent] signals to communicate with a [ThemeRepository],
/// mapping persistent storage footprints into stream-ready [ThemeState] mutations.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// The abstract repository bridge handling internal theme state configuration persistence.
  final ThemeRepository _themeRepository;

  /// Creates a business controller instance, maps event handlers, and primes initialization.
  ThemeBloc({required ThemeRepository themeRepository})
    : _themeRepository = themeRepository,
      super(const ThemeInitial()) {
    on<ThemeInitRequested>(_onThemeInitRequested);
    on<ThemeToggleRequested>(_onThemeToggleRequested);

    // Automatically trigger initialization upon creation to resolve system values instantly.
    add(const ThemeInitRequested());
  }

  /// Processes local storage lookups on cold boot sequences to recover user theme profiles.
  void _onThemeInitRequested(
    ThemeInitRequested event,
    Emitter<ThemeState> emit,
  ) {
    // Elevates to loading status while preserving active fallback variables.
    emit(ThemeLoading(state.themeMode));

    final result = _themeRepository.getThemeMode();

    result.fold(
      // Reverts cleanly to system default configurations on persistent validation cracks.
      (failure) => emit(ThemeError(ThemeMode.system, failure.message)),
      (modeString) {
        if (modeString == 'dark') {
          emit(const ThemeLoaded(ThemeMode.dark));
        } else if (modeString == 'light') {
          emit(const ThemeLoaded(ThemeMode.light));
        } else {
          emit(
            const ThemeLoaded(ThemeMode.system),
          ); // Defaults back to standard host OS settings.
        }
      },
    );
  }

  /// Executes runtime configuration swaps between alternate theme layout structures.
  Future<void> _onThemeToggleRequested(
    ThemeToggleRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentMode = state.themeMode;

    // Toggle logic: If system, fallback to light first, then switch between light/dark.
    final targetMode = (currentMode == ThemeMode.dark)
        ? ThemeMode.light
        : ThemeMode.dark;
    final targetString = (targetMode == ThemeMode.dark) ? 'dark' : 'light';

    emit(ThemeLoading(currentMode));

    final result = await _themeRepository.cacheThemeMode(targetString);

    result.fold(
      // Emits non-blocking logging data while preserving previous user parameters on failures.
      (failure) => emit(ThemeError(currentMode, failure.message)),
      (_) => emit(ThemeLoaded(targetMode)),
    );
  }
}
