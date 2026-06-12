import 'package:fpdart/fpdart.dart';
import '../../../error/exceptions.dart';
import '../../../error/failures.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, String?> getThemeMode() {
    try {
      final mode = localDataSource.getThemeMode();
      return right(mode);
    } on CacheException catch (e) {
      return left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> cacheThemeMode(String themeMode) async {
    try {
      await localDataSource.cacheThemeMode(themeMode);
      return right(unit);
    } on CacheException catch (e) {
      return left(CacheFailure(e.message));
    }
  }
}
