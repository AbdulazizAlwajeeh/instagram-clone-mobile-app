import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_data_source.dart';

/// Implementation of [ExploreRepository] managing explore data transactions.
///
/// Maps data source exceptions into functional [Failure] types.
class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  /// Creates an instance of [ExploreRepositoryImpl] with the given [_remoteDataSource].
  const ExploreRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      // Fetch data models from remote boundary.
      final postModels = await _remoteDataSource.getAllPosts();
      return Right(postModels);
    } on ServerException catch (exception) {
      // Transform local boundary infrastructure errors into unified domain server failures.
      return Left(ServerFailure(exception.message));
    } catch (error) {
      // Gracefully handle unexpected runtime exceptions during data processing.
      return Left(ServerFailure(error.toString()));
    }
  }
}
