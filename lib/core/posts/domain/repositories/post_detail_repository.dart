import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../entities/comment.dart';

abstract class PostDetailRepository {
  /// Retrieves a comprehensive post object by its distinct identification key.
  ///
  /// Returns a [ServerFailure] on the left side if the query fails,
  /// or a [Post] entity on the right side upon successful retrieval.
  Future<Either<Failure, Post>> getPostById(String postId);

  /// Toggles or updates the like status on a specific target post.
  ///
  /// Returns a [ServerFailure] on the left side if the request fails,
  /// or a [Unit] value on the right side upon successful execution.
  Future<Either<Failure, Unit>> toggleLikePost(String postId);

  /// Retrieves a list of comments associated with a distinct post identification key.
  ///
  /// Returns a [ServerFailure] on the left side if the query fails,
  /// or a [List<Comment>] on the right side upon successful retrieval.
  Future<Either<Failure, List<Comment>>> getPostComments(String postId);

  /// Inserts a new comment string under a specific targeted post entry.
  ///
  /// Returns a [ServerFailure] on the left side if the database execution fails,
  /// or a [Unit] token value on the right side upon successful insertion.
  Future<Either<Failure, Unit>> addComment({
    required String postId,
    required String text,
  });
}
