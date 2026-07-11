import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../entities/comment.dart';

/// Abstract contract defining the core domain interactions for post details.
///
/// Serves as the architectural boundary interface between the domain layer use cases
/// and the data layer implementation. Expresses business requirements independently
/// of any database or network framework engines.
abstract class PostDetailRepository {
  /// Retrieves a comprehensive post object by its distinct identification key.
  ///
  /// Takes a unique [postId] to query the targeted post record details.
  /// Returns a [ServerFailure] on the left side if the query fails,
  /// or a [Post] entity on the right side upon successful retrieval.
  Future<Either<Failure, Post>> getPostById(String postId);

  /// Toggles or updates the like status on a specific target post.
  ///
  /// Takes a unique [postId] representing the post being interacted with.
  /// Returns a [ServerFailure] on the left side if the request fails,
  /// or a [Unit] value on the right side upon successful execution.
  Future<Either<Failure, Unit>> toggleLikePost(String postId);

  /// Retrieves a list of comments associated with a distinct post identification key.
  ///
  /// Takes a unique [postId] to filter and match corresponding comment rows.
  /// Returns a [ServerFailure] on the left side if the query fails,
  /// or a [List<Comment>] on the right side upon successful retrieval.
  Future<Either<Failure, List<Comment>>> getPostComments(String postId);

  /// Inserts a new comment string under a specific targeted post entry.
  ///
  /// Requires both the target [postId] and the text body content [text].
  /// Returns a [ServerFailure] on the left side if the database execution fails,
  /// or a [Unit] token value on the right side upon successful insertion.
  Future<Either<Failure, Unit>> addComment({
    required String postId,
    required String text,
  });

  /// Sends a moderation report for a specific post to the backend infrastructure.
  ///
  /// Accepts the target [postId].
  /// Returns a [Unit] wrapped inside a [Right] on success.
  /// Returns a [Failure] wrapped inside a [Left] if a network or server anomaly occurs.
  Future<Either<Failure, Unit>> reportPost({required String postId});
}
