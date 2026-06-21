import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';

abstract class ExploreRepository {
  /// Retrieves a paginated or curated list of all available posts for exploration.
  ///
  /// Returns a [ServerFailure] on the left side if the query fails,
  /// or a [List<Post>] on the right side upon successful retrieval.
  Future<Either<Failure, List<Post>>> getAllPosts();
}
