import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/explore_repository.dart';

class GetAllPosts implements UseCase<List<Post>, NoParams> {
  final ExploreRepository _exploreRepository;

  const GetAllPosts(this._exploreRepository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await _exploreRepository.getAllPosts();
  }
}
