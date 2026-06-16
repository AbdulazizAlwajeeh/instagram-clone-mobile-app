import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/feed_repository.dart';

class GetFollowedUsersPosts
    implements UseCase<List<Post>, GetFollowedUsersPostsParams> {
  final FeedRepository repository;

  GetFollowedUsersPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(
    GetFollowedUsersPostsParams params,
  ) async {
    return await repository.getFollowedUsersPosts(
      userId: params.userId,
      limit: params.limit,
      lastPostTimestamp: params.lastPostTimestamp,
    );
  }
}

class GetFollowedUsersPostsParams {
  final String userId;
  final int limit;
  final DateTime? lastPostTimestamp;

  const GetFollowedUsersPostsParams({
    required this.userId,
    this.limit = 10, // Default page size parameter
    this.lastPostTimestamp,
  });
}
