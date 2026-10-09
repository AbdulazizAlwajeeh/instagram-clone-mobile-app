/// Abstract storage provider interface declaring local disk access rules for localization data.
///
/// Decouples raw underlying data storage technologies (such as Shared Preferences, Hive, or Isar)
/// from the repository layer, defining low-level persistence signatures.
abstract interface class LocaleLocalDataSource {
  /// Fetches the persisted language code string key sequence directly from local device cache layers.
  ///
  /// Returns a nullable [String] indicating the saved configuration, or `null` if no configuration
  /// baseline profile records currently exist.
  String? getCachedLanguageCode();

  /// Persists the selected language code string token configuration directly to non-volatile local disk layouts.
  ///
  /// Acceptable structured parameters are standard layout key values (e.g., `"en"`, `"ar"`).
  /// Throws an [Exception] or framework-specific platform error if underlying input/output
  /// filesystem blocks fail or encounter write locks.
  Future<void> cacheLanguageCode(String languageCode);
}
