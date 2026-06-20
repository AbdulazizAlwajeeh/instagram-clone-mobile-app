import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';

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
}
