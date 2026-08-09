import 'package:fpdart/fpdart.dart';
import '../../../error/exceptions.dart';
import '../../../error/failures.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../datasources/notification_remote_data_source.dart';

/// Concrete implementation of [NotificationRepository] orchestrating data routing.
///
/// Coordinates the local hardware permission/token extraction with the remote
/// cloud persistence layers while catching system driver exceptions safely.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _localDataSource;
  final NotificationRemoteDataSource _remoteDataSource;

  /// Creates a [NotificationRepositoryImpl] instance requiring explicit data sources.
  const NotificationRepositoryImpl({
    required NotificationLocalDataSource localDataSource,
    required NotificationRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, Unit>> registerDeviceToken() async {
    try {
      // Query the local hardware OS channels for permissions and the unique string token
      final token = await _localDataSource.getDeviceToken();

      // Determine the platform runtime type classification ('android' / 'ios')
      final platform = _localDataSource.getPlatformType();

      // Persist the hardware details securely upstream to the Supabase junction table
      await _remoteDataSource.upsertDeviceToken(
        token: token,
        platform: platform,
      );

      return const Right(unit);
    } on CacheException catch (e) {
      // Captures hardware/permission level localized failures cleanly
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      // Captures backend network/database constraint violations cleanly
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Fallback global handler for completely unhandled runtime thread exceptions
      return Left(
        ServerFailure('An unexpected repository exception occurred: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> unregisterDeviceToken() async {
    try {
      // Extract the active device token to ensure accurate targets are dropped
      final token = await _localDataSource.getDeviceToken();

      // Clear token records to isolate the data boundaries on sign out
      await _remoteDataSource.deleteDeviceToken(token: token);

      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('An unexpected repository exception occurred: $e'),
      );
    }
  }
}
