import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case responsible for establishing a social follow link targeting another user account.
///
/// Implements the base [UseCase] contract mapping input string target user identification keys
/// to a successful functional [Unit] confirmation wrapped in an [Either] container.
class FollowUser implements UseCase<Unit, String> {
  final ProfileRepository _profileRepository;

  /// Creates a [FollowUser] use case with the given repository dependency.
  const FollowUser(this._profileRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await _profileRepository.followUser(params);
  }
}
