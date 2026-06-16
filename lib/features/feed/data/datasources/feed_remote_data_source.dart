import '../../../../core/posts/data/models/post_model.dart';

abstract class FeedRemoteDataSource {
  /// Queries the remote backend engine to return a raw list of post data models.
  Future<List<PostModel>> getFollowedUsersPostsRaw({
    required String userId,
    required int limit,
    required DateTime? lastPostTimestamp,
  });
}
