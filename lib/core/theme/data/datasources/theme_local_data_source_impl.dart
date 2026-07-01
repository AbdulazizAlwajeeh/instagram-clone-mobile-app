import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemengram/core/theme/data/datasources/theme_local_data_source.dart';
import '../../../error/exceptions.dart';

/// Concrete operational data client translating theme persistence logic to a specific engine.
///
/// Interacts directly with the device's persistent filesystem through the [SharedPreferences] framework API,
/// isolating raw string mapping operations behind an interface contract.
class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  /// The underlying key-value driver system running cross-platform storage.
  final SharedPreferences sharedPreferences;

  /// Internal explicit look-up tracking key pointer used to index structural data blocks.
  static const String _themeModeKey = 'cached_theme_mode';

  /// Creates a storage data provider binding containing the baseline [sharedPreferences] client.
  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  String? getThemeMode() {
    try {
      // Accesses memory tracks locally using the internal static data pointer.
      return sharedPreferences.getString(_themeModeKey);
    } catch (e) {
      // Intercepts driver-level unexpected access errors to standardize framework faults.
      throw const CacheException(
        'Failed to read theme mode from local storage.',
      );
    }
  }

  @override
  Future<void> cacheThemeMode(String themeMode) async {
    try {
      // Executes standard disk-level update sequence using the runtime token sequence.
      final success = await sharedPreferences.setString(
        _themeModeKey,
        themeMode,
      );

      if (!success) {
        // Enforces checking system-level confirmations to ensure structural validation guarantees.
        throw const CacheException(
          'SharedPreferences returned false during write execution.',
        );
      }
    } catch (e) {
      // Intercepts driver-level filesystem errors to bubble up clean architecture boundaries.
      throw const CacheException(
        'Failed to persist theme mode to local storage.',
      );
    }
  }
}
