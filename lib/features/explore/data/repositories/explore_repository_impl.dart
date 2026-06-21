import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_data_source.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  const ExploreRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      final postModels = await _remoteDataSource.getAllPosts();
      return Right(postModels);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
