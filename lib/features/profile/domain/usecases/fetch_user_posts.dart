import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case responsible for retrieving a collection of posts published by a specific user.
///
/// Implements the base [UseCase] contract mapping input string user identification keys
/// to a list of matching [Post] domain entities wrapped in an [Either] container.
class FetchUserPosts implements UseCase<List<Post>, String> {
  final ProfileRepository _profileRepository;

  /// Creates a [FetchUserPosts] use case with the given repository dependency.
  const FetchUserPosts(this._profileRepository);

  @override
  Future<Either<Failure, List<Post>>> call(String params) async {
    return await _profileRepository.getUserPosts(params);
  }
}
