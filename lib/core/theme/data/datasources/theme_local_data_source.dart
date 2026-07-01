import '../../../error/exceptions.dart';

/// Abstract storage provider interface declaring local disk access rules for theme data.
///
/// Decouples raw underlying data storage technologies (such as Shared Preferences, Hive, or Isar)
/// from the repository layer, defining low-level persistence signatures.
abstract interface class ThemeLocalDataSource {
  /// Fetches the persisted theme mode string key sequence directly from local device cache layers.
  ///
  /// Returns a nullable [String] indicating the saved configuration, or `null` if no configuration
  /// baseline profile records currently exist.
  String? getThemeMode();

  /// Persists the selected theme mode string token configuration directly to non-volatile local disk layouts.
  ///
  /// Acceptable structured parameters are standard layout key values (e.g., `"light"` or `"dark"`).
  /// Throws a [CacheException] if underlying input/output filesystem blocks fail or encounter write locks.
  Future<void> cacheThemeMode(String themeMode);
}
