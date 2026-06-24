import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class CheckUsernameAvailability implements UseCase<bool, String> {
  final ProfileRepository _profileRepository;

  const CheckUsernameAvailability(this._profileRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _profileRepository.checkUsernameAvailability(params);
  }
}
