import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';
import '../../domain/repositories/locale_repository.dart';
import '../datasources/locale_local_datasource.dart';

/// Concrete operational implementation handling the persistence boundary for locale settings.
///
/// Bridges abstract infrastructure signatures to specific local layout engines using a
/// decoupled data provider abstraction [LocaleLocalDataSource].
class LocaleRepositoryImpl implements LocaleRepository {
  /// The structural underlying cache client adapter layer interface.
  final LocaleLocalDataSource localDataSource;

  /// Creates a repository manager containing the active dependencies block.
  LocaleRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, String?> getCachedLanguageCode() {
    try {
      // Direct pass-through pipeline reading from local device memory configurations.
      final languageCode = localDataSource.getCachedLanguageCode();
      return right(languageCode);
    } catch (e) {
      // Catches driver integration bugs and surfaces them back out as domain failures.
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheLanguageCode(String languageCode) async {
    try {
      // Explicitly forces writing tracking strings to disk arrays asynchronously.
      await localDataSource.cacheLanguageCode(languageCode);
      return right(unit);
    } catch (e) {
      // Captures input/output framework standard device write block errors.
      return left(CacheFailure(e.toString()));
    }
  }
}
