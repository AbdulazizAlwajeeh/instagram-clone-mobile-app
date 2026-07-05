import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/explore_repository.dart';

/// Use case responsible for orchestrating the retrieval of exploration posts.
///
/// Interacts directly with the domain boundary repository [ExploreRepository].
class GetAllPosts implements UseCase<List<Post>, NoParams> {
  final ExploreRepository _exploreRepository;

  /// Creates a [GetAllPosts] use case initialized with the repository contract.
  const GetAllPosts(this._exploreRepository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    // Delegate processing execution flow to the underlying repository layer.
    return await _exploreRepository.getAllPosts();
  }
}
