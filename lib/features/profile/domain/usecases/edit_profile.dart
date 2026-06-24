import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class EditProfile implements UseCase<Unit, EditProfileParams> {
  final ProfileRepository _profileRepository;

  const EditProfile(this._profileRepository);

  @override
  Future<Either<Failure, Unit>> call(EditProfileParams params) async {
    return await _profileRepository.editProfile(
      username: params.username,
      fullName: params.fullName,
      bio: params.bio,
      imageFile: params.imageFile,
    );
  }
}

class EditProfileParams {
  final String? username;
  final String? fullName;
  final String? bio;
  final dynamic imageFile;

  const EditProfileParams({
    this.username,
    this.fullName,
    this.bio,
    this.imageFile,
  });
}
