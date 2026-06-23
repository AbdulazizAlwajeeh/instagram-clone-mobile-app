import '../../../../core/posts/domain/entities/post.dart';
import '../models/comment_model.dart';

abstract class PostDetailRemoteDataSource {
  /// Queries the Supabase database to locate a single post by identification key.
  ///
  /// Throws a [ServerException] if the query fails or data is missing.
  Future<Post> getPostById(String postId);

  /// Executes an RPC or handles a toggle transaction for liking a post in Supabase.
  ///
  /// Throws a [ServerException] if the database execution fails.
  Future<void> toggleLikePost(String postId);

  /// Queries the Supabase database to fetch all comments linked to a single post key.
  ///
  /// Throws a [ServerException] if the database operation fails.
  Future<List<CommentModel>> getPostComments(String postId);

  /// Inserts a new comment row into the Supabase database under a given post ID.
  ///
  /// Throws a [ServerException] if the database operation or authentication fails.
  Future<void> addComment({
    required String postId,
    required String text,
  });
}
