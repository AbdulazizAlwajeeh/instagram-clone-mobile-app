import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case responsible for orchestrating modifications to an authenticated user's profile details.
class EditProfile implements UseCase<Unit, EditProfileParams> {
  final ProfileRepository _profileRepository;

  /// Creates an [EditProfile] use case with the given repository dependency.
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

/// Parameter container class encapsulating all possible editable properties for a user profile.
class EditProfileParams {
  /// The newly requested unique username handle.
  final String? username;

  /// The updated public display name.
  final String? fullName;

  /// The revised biographical description.
  final String? bio;

  /// The raw image file object (or reference platform asset) intended for avatar upload.
  final dynamic imageFile;

  /// Constructs an immutable set of parameters for updating the user profile.
  const EditProfileParams({
    this.username,
    this.fullName,
    this.bio,
    this.imageFile,
  });
}
