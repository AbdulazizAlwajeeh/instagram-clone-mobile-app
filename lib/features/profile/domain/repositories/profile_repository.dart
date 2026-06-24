import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  /// Retrieves a targeted public user profile by their distinct identification key.
  ///
  /// Returns a [ServerFailure] on the left side if data fetching fails,
  /// or a [UserProfile] entity on the right side upon a successful query.
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);

  /// Retrieves a collection of posts published by a specific user using their distinct identification key.
  ///
  /// Returns a [ServerFailure] on the left side if media data fetching fails,
  /// or a [List] of [Post] entities on the right side upon a successful query.
  Future<Either<Failure, List<Post>>> getUserPosts(String userId);

  /// Establishes a follow relationship targeting a specific user.
  ///
  /// Returns a [ServerFailure] on the left side if the operation fails,
  /// or a [Unit] value on the right side upon a successful operation.
  Future<Either<Failure, Unit>> followUser(String targetUserId);

  /// Dissolves an existing follow relationship targeting a specific user.
  ///
  /// Returns a [ServerFailure] on the left side if the operation fails,
  /// or a [Unit] value on the right side upon a successful operation.
  Future<Either<Failure, Unit>> unfollowUser(String targetUserId);

  /// Updates an existing user profile's details in the database.
  ///
  /// Returns a [Failure] on the left side if the modification fails,
  /// or a [Unit] value on the right side upon a successful update operation.
  Future<Either<Failure, Unit>> editProfile({
    String? username,
    String? fullName,
    String? bio,
    dynamic imageFile,
  });

  /// Verifies whether the specified [username] is free to use or already claimed.
  Future<Either<Failure, bool>> checkUsernameAvailability(String username);
}
