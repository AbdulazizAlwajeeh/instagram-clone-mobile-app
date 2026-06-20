import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

class GetPostById implements UseCase<Post, String> {
  final PostDetailRepository _postDetailRepository;

  const GetPostById(this._postDetailRepository);

  @override
  Future<Either<Failure, Post>> call(String params) async {
    return await _postDetailRepository.getPostById(params);
  }
}
