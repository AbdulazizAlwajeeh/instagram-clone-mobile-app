import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

/// Concrete repository implementation that coordinates interactions with [ProfileRemoteDataSource].
///
/// Maps internal low-level exceptions into readable functional error [Failure] signatures.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  /// Creates a [ProfileRepositoryImpl] instance with the required [_remoteDataSource].
  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    try {
      final userProfile = await _remoteDataSource.getUserProfile(userId);
      return Right(userProfile);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getUserPosts(String userId) async {
    try {
      final postModels = await _remoteDataSource.getUserPosts(userId);

      return Right(postModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> followUser(String targetUserId) async {
    try {
      await _remoteDataSource.followUser(targetUserId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> unfollowUser(String targetUserId) async {
    try {
      await _remoteDataSource.unfollowUser(targetUserId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> editProfile({
    String? username,
    String? fullName,
    String? bio,
    dynamic imageFile,
  }) async {
    try {
      await _remoteDataSource.editProfile(
        username: username,
        fullName: fullName,
        bio: bio,
        imageFile: imageFile,
      );
      return const Right(unit);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameAvailability(
    String username,
  ) async {
    try {
      final isAvailable = await _remoteDataSource.checkUsernameAvailability(
        username,
      );
      return Right(isAvailable);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
