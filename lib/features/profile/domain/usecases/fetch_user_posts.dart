import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class FetchUserPosts implements UseCase<List<Post>, String> {
  final ProfileRepository _profileRepository;

  const FetchUserPosts(this._profileRepository);

  @override
  Future<Either<Failure, List<Post>>> call(String params) async {
    return await _profileRepository.getUserPosts(params);
  }
}
