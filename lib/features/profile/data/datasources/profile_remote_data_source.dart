import '../../../../core/posts/data/models/post_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  /// Fetches a raw profile database record matching the provided [userId].
  ///
  /// Throws a [ServerException] if the row is missing or a database error occurs.
  Future<UserProfileModel> getUserProfile(String userId);

  /// Fetches a collection of raw post database records matching the provided [userId].
  ///
  /// Throws a [ServerException] if a network error or database query failure occurs.
  Future<List<PostModel>> getUserPosts(String userId);

  /// Establishes a follow entry in the database record targeting the provided [targetUserId].
  ///
  /// Throws a [ServerException] if a network error or database query failure occurs.
  Future<void> followUser(String targetUserId);

  /// Dissolves an existing follow entry in the database record targeting the provided [targetUserId].
  ///
  /// Throws a [ServerException] if a network error or database query failure occurs.
  Future<void> unfollowUser(String targetUserId);

  /// Modifies an existing user profile row in the database.
  ///
  /// Throws a [ServerException] if the update fails or a database error occurs.
  Future<void> editProfile({
    String? username,
    String? fullName,
    String? bio,
    dynamic imageFile,
  });

  /// Checks if a [username] is already claimed by another user record.
  Future<bool> checkUsernameAvailability(String username);
}
