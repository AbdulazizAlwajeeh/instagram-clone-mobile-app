import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/post_detail_repository.dart';

class ToggleLikePost implements UseCase<Unit, String> {
  final PostDetailRepository _postDetailRepository;

  const ToggleLikePost(this._postDetailRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await _postDetailRepository.toggleLikePost(params);
  }
}
