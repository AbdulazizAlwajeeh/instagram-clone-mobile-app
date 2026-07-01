import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

/// Use case to handle toggling the liked/unliked status of a post.
///
/// Implements the base [UseCase] contract, accepting a [String] payload
/// representing the post identification key and returning a [Unit] wrapper.
class ToggleLikePost implements UseCase<Unit, String> {
  /// Core domain repository interface contract for post details data operations.
  final PostDetailRepository _postDetailRepository;

  /// Creates a [ToggleLikePost] action with required repository dependency injection.
  const ToggleLikePost(this._postDetailRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await _postDetailRepository.toggleLikePost(params);
  }
}
