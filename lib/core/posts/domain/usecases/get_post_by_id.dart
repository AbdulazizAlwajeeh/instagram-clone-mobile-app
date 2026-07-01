import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

/// Use case to fetch full operational data details for a targeted post.
///
/// Implements the base [UseCase] contract, accepting a [String] payload
/// representing the post ID and returning the unified domain [Post] entity.
class GetPostById implements UseCase<Post, String> {
  /// Core domain repository interface contract for post details data operations.
  final PostDetailRepository _postDetailRepository;

  /// Creates a [GetPostById] action with required repository dependency injection.
  const GetPostById(this._postDetailRepository);

  @override
  Future<Either<Failure, Post>> call(String params) async {
    return await _postDetailRepository.getPostById(params);
  }
}
