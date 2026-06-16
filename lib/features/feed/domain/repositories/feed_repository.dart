import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';

abstract class FeedRepository {
  /// Fetches a paginated timeline of posts from creators that the target user follows.
  ///
  /// Takes the active [userId] to identify follow relationships, a fixed [limit]
  /// for the page size, and an optional [lastPostTimestamp] cursor to fetch older posts
  /// without content duplication during endless scrolling.
  Future<Either<Failure, List<Post>>> getFollowedUsersPosts({
    required String userId,
    required int limit,
    required DateTime? lastPostTimestamp,
  });
}
