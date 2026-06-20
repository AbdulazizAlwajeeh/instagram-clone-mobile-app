import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/repositories/post_detail_repository.dart';
import '../datasoucres/post_detail_remote_data_source.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  final PostDetailRemoteDataSource _remoteDataSource;

  const PostDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Post>> getPostById(String postId) async {
    try {
      final postModel = await _remoteDataSource.getPostById(postId);
      return Right(postModel);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleLikePost(String postId) async {
    try {
      await _remoteDataSource.toggleLikePost(postId);
      return const Right(unit);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
