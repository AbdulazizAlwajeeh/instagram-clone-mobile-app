import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  /// Fetches the active authenticated user session.
  Future<Either<Failure, AppUser?>> getCurrentUser();

  /// Signs up a new user via the Supabase Auth ecosystem.
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Authenticates an existing user via credentials.
  Future<Either<Failure, AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Clears the active session token securely.
  Future<Either<Failure, void>> signOut();
}
