import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

/// Use case to dispatch and append a new user text comment under a post.
///
/// Implements the base [UseCase] contract, accepting a bundled parameter
/// object [AddCommentParams] and returning a successful [Unit] token wrapper.
class AddComment implements UseCase<Unit, AddCommentParams> {
  /// Core domain repository interface contract for post details data operations.
  final PostDetailRepository _postDetailRepository;

  /// Creates an [AddComment] action with required repository dependency injection.
  const AddComment(this._postDetailRepository);

  @override
  Future<Either<Failure, Unit>> call(AddCommentParams params) async {
    return await _postDetailRepository.addComment(
      postId: params.postId,
      text: params.text,
    );
  }
}

/// Data parameter structure designed to pass multiple tightly coupled arguments
/// into the single input execution slot of the [AddComment] use case interface.
class AddCommentParams {
  /// The destination post identification key where the comment is posted.
  final String postId;

  /// The literal plain-text body content of the user comment message.
  final String text;

  /// Creates an immutable [AddCommentParams] bundle class.
  const AddCommentParams({required this.postId, required this.text});
}
