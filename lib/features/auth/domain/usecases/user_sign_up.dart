import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// A dedicated application use case orchestrating new account creation workflows.
///
/// Coordinates registration streams by passing validated, structured [SignUpParams]
/// configurations down into the core domain [repository] layer.
class UserSignUp implements UseCase<AppUser, SignUpParams> {
  /// The structural domain repository boundary handling registration transitions.
  final AuthRepository repository;

  /// Creates an account creation business operation worker bound to the active [repository].
  const UserSignUp(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignUpParams params) async {
    // Unpacks parameters atomically to initiate security provisioning inside
    // infrastructure tracks.
    return await repository.signUpWithEmailPassword(
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}

/// Explicit data transaction payload carrying configuration attributes required for profile generation.
///
/// Encapsulates strict user-provided profile metadata, ensuring that corporate boundary layers
/// remain protected against unvalidated field attributes.
class SignUpParams {
  /// The unique electronic delivery endpoint required for identity allocation profiles.
  final String email;

  /// The raw unencrypted security token chosen by the profile applicant.
  final String password;

  /// The unique visible user display handle selected for application interaction nodes.
  final String username;

  /// Creates a frozen configuration parameter block with required registration attributes.
  const SignUpParams({
    required this.email,
    required this.password,
    required this.username,
  });
}
