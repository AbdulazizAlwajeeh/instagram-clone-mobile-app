import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/create_post_repository.dart';

class CreatePost implements UseCase<Unit, CreatePostParams> {
  final CreatePostRepository _createPostRepository;

  const CreatePost(this._createPostRepository);

  @override
  Future<Either<Failure, Unit>> call(CreatePostParams params) async {
    return await _createPostRepository.createPost(
      caption: params.caption,
      mediaFile: params.mediaFile,
      authorId: params.authorId,
    );
  }
}

class CreatePostParams {
  final String caption;
  final File mediaFile;
  final String authorId;

  const CreatePostParams({
    required this.caption,
    required this.mediaFile,
    required this.authorId,
  });
}
