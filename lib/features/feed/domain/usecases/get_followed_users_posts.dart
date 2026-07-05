import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/feed_repository.dart';

/// Use case responsible for orchestrating the retrieval of followed users' posts.
///
/// Connects the presentation layer to the underlying [FeedRepository] domain layer.
class GetFollowedUsersPosts
    implements UseCase<List<Post>, GetFollowedUsersPostsParams> {
  final FeedRepository repository;

  /// Creates a [GetFollowedUsersPosts] use case initialized with the repository contract.
  GetFollowedUsersPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(
    GetFollowedUsersPostsParams params,
  ) async {
    // Forward parameter inputs directly into the repository transaction layer.
    return await repository.getFollowedUsersPosts(
      userId: params.userId,
      limit: params.limit,
      lastPostTimestamp: params.lastPostTimestamp,
    );
  }
}

/// Parameter container class required to execute the [GetFollowedUsersPosts] query logic.
class GetFollowedUsersPostsParams {
  /// The unique identifier of the user requesting the timeline feed data.
  final String userId;

  /// The maximum number of records requested to maintain strict data boundary limits.
  final int limit;

  /// An optional cursor tracking the precise timestamp offset bound for subsequent paginated items.
  final DateTime? lastPostTimestamp;

  /// Creates parameter instructions required for pagination filtering transactions.
  const GetFollowedUsersPostsParams({
    required this.userId,
    this.limit = 10, // Default page size parameter
    this.lastPostTimestamp,
  });
}
