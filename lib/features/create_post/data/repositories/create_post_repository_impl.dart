import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/create_post_repository.dart';
import '../datasources/create_post_remote_data_source.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final CreatePostRemoteDataSource _remoteDataSource;

  const CreatePostRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Unit>> createPost({
    required String caption,
    required File mediaFile,
    required String authorId,
  }) async {
    try {
      await _remoteDataSource.createPost(
        caption: caption,
        mediaFile: mediaFile,
        authorId: authorId,
      );
      return Right(unit);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
