import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment.dart';
import '../repositories/post_detail_repository.dart';

/// Use case to retrieve a collection of user comments linked to a single post.
///
/// Implements the base [UseCase] contract, accepting a [String] payload
/// representing the target post ID and returning a list of [Comment] entities.
class GetPostComments implements UseCase<List<Comment>, String> {
  /// Core domain repository interface contract for post details data operations.
  final PostDetailRepository _postDetailRepository;

  /// Creates a [GetPostComments] action with required repository dependency injection.
  const GetPostComments(this._postDetailRepository);

  @override
  Future<Either<Failure, List<Comment>>> call(String params) async {
    return await _postDetailRepository.getPostComments(params);
  }
}
