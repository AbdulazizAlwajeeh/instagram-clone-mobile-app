import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class FetchUserProfile implements UseCase<UserProfile, String> {
  final ProfileRepository _profileRepository;

  const FetchUserProfile(this._profileRepository);

  @override
  Future<Either<Failure, UserProfile>> call(String params) async {
    return await _profileRepository.getUserProfile(params);
  }
}
