import 'package:fpdart/fpdart.dart';
import '../../../error/exceptions.dart';
import '../../../error/failures.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_data_source.dart';

/// Concrete operational implementation handling the persistence boundary for theme settings.
///
/// Bridges abstract infrastructure signatures to specific local layout engines using a
/// decoupled data provider abstraction [ThemeLocalDataSource].
class ThemeRepositoryImpl implements ThemeRepository {
  /// The structural underlying cache client adapter layer interface.
  final ThemeLocalDataSource localDataSource;

  /// Creates a repository manager containing the active dependencies block.
  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, String?> getThemeMode() {
    try {
      // Direct pass-through pipeline reading from local device memory configurations.
      final mode = localDataSource.getThemeMode();
      return right(mode);
    } on CacheException catch (e) {
      // Catches driver integration bugs and surfaces them back out as domain failures.
      return left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheThemeMode(String themeMode) async {
    try {
      // Explicitly forces writing tracking strings to disk arrays asynchronously.
      await localDataSource.cacheThemeMode(themeMode);
      return right(unit);
    } on CacheException catch (e) {
      // Captures input/output framework standard device write block errors.
      return left(CacheFailure(e.message));
    }
  }
}
