import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class FollowUser implements UseCase<Unit, String> {
  final ProfileRepository _profileRepository;

  const FollowUser(this._profileRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await _profileRepository.followUser(params);
  }
}
