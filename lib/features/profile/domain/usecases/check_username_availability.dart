import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for verifying whether a specific username handle is available or taken.
///
/// Implements the base [UseCase] contract mapping input string parameters to boolean results.
class CheckUsernameAvailability implements UseCase<bool, String> {
  final ProfileRepository _profileRepository;

  /// Creates a [CheckUsernameAvailability] use case with the given repository dependency.
  const CheckUsernameAvailability(this._profileRepository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _profileRepository.checkUsernameAvailability(params);
  }
}
