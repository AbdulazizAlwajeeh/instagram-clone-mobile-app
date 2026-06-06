import '../models/app_user_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls the Supabase Auth API to sign up using email and password credentials.
  Future<AppUserModel> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  /// Calls the Supabase Auth API to sign in using email and password credentials.
  Future<AppUserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Calls the Supabase Auth API to terminate the active token session.
  Future<void> signOut();

  /// Retrieves the active current user session from the local Supabase cache.
  Future<AppUserModel?> getCurrentUser();
}
