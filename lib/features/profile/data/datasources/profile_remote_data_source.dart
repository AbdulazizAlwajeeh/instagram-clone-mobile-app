import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  /// Fetches a raw profile database record matching the provided [userId].
  ///
  /// Throws a [ServerException] if the row is missing or a database error occurs.
  Future<UserProfileModel> getUserProfile(String userId);
}
