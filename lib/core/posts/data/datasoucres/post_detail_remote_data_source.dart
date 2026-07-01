import '../../../../core/posts/domain/entities/post.dart';
import '../models/comment_model.dart';

/// Contract for the remote data source handling detailed interactions for posts.
///
/// This data source interfaces directly with Supabase to perform CRUD and transaction
/// operations on posts and their associated metadata (likes, comments).
/// Located in core because post data models are globally accessed across multiple features.
abstract class PostDetailRemoteDataSource {
  /// Queries the Supabase database to locate a single post by identification key.
  ///
  /// Takes a unique [postId] string to look up the specific record.
  /// Returns a [Future] containing the [Post] entity matching the ID.
  /// Throws a [ServerException] if the query fails or data is missing.
  Future<Post> getPostById(String postId);

  /// Executes an RPC or handles a toggle transaction for liking a post in Supabase.
  ///
  /// Increments/decrements like counts and updates relational tables for the current user session.
  /// Requires the specific [postId] being interacted with.
  /// Throws a [ServerException] if the database execution fails.
  Future<void> toggleLikePost(String postId);

  /// Queries the Supabase database to fetch all comments linked to a single post key.
  ///
  /// Takes a [postId] to filter and match corresponding comment rows.
  /// Returns a [Future] resolving to a list of [CommentModel] objects.
  /// Throws a [ServerException] if the database operation fails.
  Future<List<CommentModel>> getPostComments(String postId);

  /// Inserts a new comment row into the Supabase database under a given post ID.
  ///
  /// Requires both the target [postId] and the message content [text].
  /// Associates the input data with the currently active user session on the backend.
  /// Throws a [ServerException] if the database operation or authentication fails.
  Future<void> addComment({required String postId, required String text});
}
