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
}
