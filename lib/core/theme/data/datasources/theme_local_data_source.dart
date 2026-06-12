import '../../../error/exceptions.dart';

abstract interface class ThemeLocalDataSource {
  /// Fetches the persisted theme mode string. Returns null if no selection exists.
  String? getThemeMode();

  /// Persists the selected theme mode string ("light" or "dark") to disk.
  /// Throws [CacheException] if the operation fails.
  Future<void> cacheThemeMode(String themeMode);
}
