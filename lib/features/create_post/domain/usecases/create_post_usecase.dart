import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/create_post_repository.dart';

/// Domain usecase component responsible for publishing a new user post.
///
/// Orchestrates the business rules by triggering the [CreatePostRepository] contract.
class CreatePost implements UseCase<Unit, CreatePostParams> {
  final CreatePostRepository _createPostRepository;

  /// Creates a [CreatePost] business usecase wrapping a domain repository layer.
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

/// Parameter container holding the data models required to perform post creation.
class CreatePostParams {
  final String caption;
  final File mediaFile;
  final String authorId;

  /// Bundles required fields together into an immutable validation block.
  const CreatePostParams({
    required this.caption,
    required this.mediaFile,
    required this.authorId,
  });
}
