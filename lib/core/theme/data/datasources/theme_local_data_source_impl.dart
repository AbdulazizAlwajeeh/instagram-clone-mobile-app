import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemengram/core/theme/data/datasources/theme_local_data_source.dart';
import '../../../error/exceptions.dart';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _themeModeKey = 'cached_theme_mode';

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  String? getThemeMode() {
    try {
      return sharedPreferences.getString(_themeModeKey);
    } catch (e) {
      throw const CacheException(
        'Failed to read theme mode from local storage.',
      );
    }
  }

  @override
  Future<void> cacheThemeMode(String themeMode) async {
    try {
      final success = await sharedPreferences.setString(
        _themeModeKey,
        themeMode,
      );
      if (!success) {
        throw const CacheException(
          'SharedPreferences returned false during write execution.',
        );
      }
    } catch (e) {
      throw const CacheException(
        'Failed to persist theme mode to local storage.',
      );
    }
  }
}
