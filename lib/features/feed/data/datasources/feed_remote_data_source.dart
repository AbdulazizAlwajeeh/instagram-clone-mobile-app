import '../../../../core/posts/data/models/post_model.dart';

/// Contract for the remote data source handling feed-related transactions.
///
/// This boundary interface communicates directly with the network infrastructure layer.
abstract class FeedRemoteDataSource {
  /// Queries the remote backend engine to return a raw list of post data models.
  ///
  /// Requires a target [userId] to aggregate followed profiles, a pagination [limit],
  /// and an optional [lastPostTimestamp] parameter to coordinate cursor pagination bounds.
  Future<List<PostModel>> getFollowedUsersPostsRaw({
    required String userId,
    required int limit,
    required DateTime? lastPostTimestamp,
  });
}
