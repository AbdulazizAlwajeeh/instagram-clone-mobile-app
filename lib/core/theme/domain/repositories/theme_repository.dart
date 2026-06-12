import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';

abstract interface class ThemeRepository {
  /// Retrieves the cached theme mode string.
  /// Returns a [CacheFailure] or a nullable string value.
  Either<Failure, String?> getThemeMode();

  /// Caches the explicit theme mode string.
  /// Returns a [CacheFailure] or a [Unit] indicating success.
  Future<Either<Failure, Unit>> cacheThemeMode(String themeMode);
}
