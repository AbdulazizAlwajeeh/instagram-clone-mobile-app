import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/theme_repository.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeBloc({required ThemeRepository themeRepository})
    : _themeRepository = themeRepository,
      super(const ThemeInitial()) {
    on<ThemeInitRequested>(_onThemeInitRequested);
    on<ThemeToggleRequested>(_onThemeToggleRequested);

    // Automatically trigger initialization upon creation
    add(const ThemeInitRequested());
  }

  void _onThemeInitRequested(
    ThemeInitRequested event,
    Emitter<ThemeState> emit,
  ) {
    emit(ThemeLoading(state.themeMode));

    final result = _themeRepository.getThemeMode();

    result.fold(
      (failure) => emit(ThemeError(ThemeMode.system, failure.message)),
      (modeString) {
        if (modeString == 'dark') {
          emit(const ThemeLoaded(ThemeMode.dark));
        } else if (modeString == 'light') {
          emit(const ThemeLoaded(ThemeMode.light));
        } else {
          emit(const ThemeLoaded(ThemeMode.system));
        }
      },
    );
  }

  Future<void> _onThemeToggleRequested(
    ThemeToggleRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final currentMode = state.themeMode;
    // Toggle logic: If system, fallback to light first, then switch between light/dark
    final targetMode = (currentMode == ThemeMode.dark)
        ? ThemeMode.light
        : ThemeMode.dark;
    final targetString = (targetMode == ThemeMode.dark) ? 'dark' : 'light';

    emit(ThemeLoading(currentMode));

    final result = await _themeRepository.cacheThemeMode(targetString);

    result.fold(
      (failure) => emit(ThemeError(currentMode, failure.message)),
      (_) => emit(ThemeLoaded(targetMode)),
    );
  }
}
