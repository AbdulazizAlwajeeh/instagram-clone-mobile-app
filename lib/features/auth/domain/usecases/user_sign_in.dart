import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// A dedicated application use case orchestrating the user authentication process.
///
/// Coordinates security access operations by feeding validated structured [SignInParams]
/// inputs down into the core domain [repository] layer.
class UserSignIn implements UseCase<AppUser, SignInParams> {
  /// The structural domain repository boundary handling security context transitions.
  final AuthRepository repository;

  /// Creates an authentication business operation worker bound to the active [repository].
  const UserSignIn(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(SignInParams params) async {
    // Unpacks parameters tightly to execute verification loops against infrastructure pipelines.
    return await repository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

/// Explicit data transaction payload carrying credentials required for authentication.
///
/// Encapsulates strict user-provided configuration strings, shielding domain execution boundaries
/// from arbitrary unmapped parameter injections.
class SignInParams {
  /// The specific account email target signature required for remote verification lookup.
  final String email;

  /// The secure access token key matching the associated user account file.
  final String password;

  /// Creates a frozen validation parameters block with required validation parameters.
  const SignInParams({required this.email, required this.password});
}
