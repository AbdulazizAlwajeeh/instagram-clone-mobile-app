import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment.dart';
import '../repositories/post_detail_repository.dart';

class GetPostComments implements UseCase<List<Comment>, String> {
  final PostDetailRepository _postDetailRepository;

  const GetPostComments(this._postDetailRepository);

  @override
  Future<Either<Failure, List<Comment>>> call(String params) async {
    return await _postDetailRepository.getPostComments(params);
  }
}
