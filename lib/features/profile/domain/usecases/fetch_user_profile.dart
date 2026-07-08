import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Use case responsible for retrieving a specific user's public profile data.
///
/// Implements the base [UseCase] contract mapping input string user identification keys
/// to a matching [UserProfile] domain entity wrapped in an [Either] container.
class FetchUserProfile implements UseCase<UserProfile, String> {
  final ProfileRepository _profileRepository;

  /// Creates a [FetchUserProfile] use case with the given repository dependency.
  const FetchUserProfile(this._profileRepository);

  @override
  Future<Either<Failure, UserProfile>> call(String params) async {
    return await _profileRepository.getUserProfile(params);
  }
}
