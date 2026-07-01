import '../models/app_user_model.dart';

/// Abstract data layer contract defining authentication interactions with a remote engine.
///
/// Outlines foundational gateway protocols for managing account generation, session
/// confirmation, and cancellation operations against cross-platform identity backends.
abstract class AuthRemoteDataSource {
  /// Calls the Supabase Auth API to sign up using email and password credentials.
  ///
  /// Yields a populated [AppUserModel] containing freshly initialized platform profiles
  /// when account instantiation processes clear remote server validation rules.
  Future<AppUserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Calls the Supabase Auth API to sign in using email and password credentials.
  ///
  /// Yields a populated [AppUserModel] encapsulating verified profile records if the
  /// supplied identity tokens clear target authentication databases.
  Future<AppUserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Calls the Supabase Auth API to terminate the active token session.
  ///
  /// Explicitly clears validation profiles from the remote host and signals the system
  /// client wrapper to drop local persistent network credential tracking records.
  Future<void> signOut();

  /// Retrieves the active current user session from the local Supabase cache.
  ///
  /// Returns a populated [AppUserModel] if an unexpired operational session footprint
  /// exists in memory, or `null` if the application is running in an anonymous cold start state.
  Future<AppUserModel?> getCurrentUser();
}
