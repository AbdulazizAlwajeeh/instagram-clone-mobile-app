import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/app_user/domain/entities/app_user.dart';

/// Abstract boundary definition outlining domain-level authentication capabilities.
///
/// Serves as the high-level behavioral contract that presentation and application layers
/// interact with, shielding business workflows from lower-level data infrastructure changes.
abstract class AuthRepository {
  /// Fetches the active authenticated user session.
  ///
  /// Returns a functional [Either] layout yielding a localized [Failure] on the left channel,
  /// or a nullable [AppUser] representing the operational session footprint on the right channel.
  Future<Either<Failure, AppUser?>> getCurrentUser();

  /// Signs up a new user via the Supabase Auth ecosystem.
  ///
  /// Establishes remote structural profile tracking metrics and returns a validated
  /// [AppUser] instance upon successful registration.
  Future<Either<Failure, AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Authenticates an existing user via credentials.
  ///
  /// Matches validation tokens against remote infrastructure data endpoints and returns the
  /// associated [AppUser] domain records on success.
  Future<Either<Failure, AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Clears the active session token securely.
  ///
  /// Discards client authorization parameters locally and drops tracking tokens across connected
  /// service pools, logging the profile out.
  Future<Either<Failure, void>> signOut();
}
