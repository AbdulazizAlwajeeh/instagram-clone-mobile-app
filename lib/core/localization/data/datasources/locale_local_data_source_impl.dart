import 'package:shared_preferences/shared_preferences.dart';
import 'locale_local_datasource.dart';

/// Concrete infrastructure implementation of [LocaleLocalDataSource] powered by SharedPreferences storage drivers.
///
/// Directs low-level input/output operations to the device's native key-value storage engine.
class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  final SharedPreferences _sharedPreferences;

  /// Private constant tracking the storage bucket identifier key assigned to regional language configurations.
  static const _localeCacheKey = 'cached_locale_language_code';

  /// Creates a new instance of [LocaleLocalDataSourceImpl] driven by the injected [_sharedPreferences] instance.
  const LocaleLocalDataSourceImpl(this._sharedPreferences);

  @override
  String? getCachedLanguageCode() {
    return _sharedPreferences.getString(_localeCacheKey);
  }

  @override
  Future<void> cacheLanguageCode(String languageCode) async {
    await _sharedPreferences.setString(_localeCacheKey, languageCode);
  }
}
