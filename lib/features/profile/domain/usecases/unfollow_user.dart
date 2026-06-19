import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class UnfollowUser implements UseCase<Unit, String> {
  final ProfileRepository _profileRepository;

  const UnfollowUser(this._profileRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await _profileRepository.unfollowUser(params);
  }
}
