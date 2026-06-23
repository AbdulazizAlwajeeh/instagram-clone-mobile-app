import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

class AddComment implements UseCase<Unit, AddCommentParams> {
  final PostDetailRepository _postDetailRepository;

  const AddComment(this._postDetailRepository);

  @override
  Future<Either<Failure, Unit>> call(AddCommentParams params) async {
    return await _postDetailRepository.addComment(
      postId: params.postId,
      text: params.text,
    );
  }
}

/// Data container class to pass multiple arguments into a single UseCase param slot
class AddCommentParams {
  final String postId;
  final String text;

  const AddCommentParams({required this.postId, required this.text});
}
