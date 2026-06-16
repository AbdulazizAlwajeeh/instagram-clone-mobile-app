import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_data_source.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Post>>> getFollowedUsersPosts({
    required String userId,
    required int limit,
    required DateTime? lastPostTimestamp,
  }) async {
    try {
      // 1. Fetch the raw data models from the remote data source
      final postModels = await remoteDataSource.getFollowedUsersPostsRaw(
        userId: userId,
        limit: limit,
        lastPostTimestamp: lastPostTimestamp,
      );

      // 2. Return right-hand success by mapping data models to pure domain entities
      return Right(postModels);
    } on ServerException catch (e) {
      // 3. Catch infrastructure exceptions and map them to domain failures
      return Left(ServerFailure(e.message));
    }
  }
}
