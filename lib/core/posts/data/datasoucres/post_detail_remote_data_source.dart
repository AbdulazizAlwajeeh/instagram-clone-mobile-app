import '../../../../core/posts/domain/entities/post.dart';

abstract class PostDetailRemoteDataSource {
  /// Queries the Supabase database to locate a single post by identification key.
  ///
  /// Throws a [ServerException] if the query fails or data is missing.
  Future<Post> getPostById(String postId);

  /// Executes an RPC or handles a toggle transaction for liking a post in Supabase.
  ///
  /// Throws a [ServerException] if the database execution fails.
  Future<void> toggleLikePost(String postId);
}
