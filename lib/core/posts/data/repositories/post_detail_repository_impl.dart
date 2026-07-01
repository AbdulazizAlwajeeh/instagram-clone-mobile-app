import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/post_detail_repository.dart';
import '../datasoucres/post_detail_remote_data_source.dart';

/// Concrete implementation of [PostDetailRepository] in the data layer.
///
/// This repository orchestrates data access by calling [PostDetailRemoteDataSource]
/// and catches low-level exceptions, transforming them into functional error [Failure]
/// objects using the `fpdart` [Either] type for safer error handling in the UI.
class PostDetailRepositoryImpl implements PostDetailRepository {
  /// Remote data provider interacting with the database network client.
  final PostDetailRemoteDataSource _remoteDataSource;

  /// Creates a [PostDetailRepositoryImpl] with the required data source injection.
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

  @override
  Future<Either<Failure, List<Comment>>> getPostComments(String postId) async {
    try {
      final commentModels = await _remoteDataSource.getPostComments(postId);
      return Right(commentModels);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      await _remoteDataSource.addComment(postId: postId, text: text);
      return const Right(unit);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
