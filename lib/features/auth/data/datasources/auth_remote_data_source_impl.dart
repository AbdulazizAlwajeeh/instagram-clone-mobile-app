import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AppUserModel> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Sign up failed: User payload returned null.');
    }

    // Map the Supabase SDK User object cleanly to our local Data Model layout
    return AppUserModel.fromJson({
      'id': response.user!.id,
      'email': response.user!.email ?? '',
    });
  }

  @override
  Future<AppUserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException(
        'Sign in failed: Session could not be created.',
      );
    }

    return AppUserModel.fromJson({
      'id': response.user!.id,
      'email': response.user!.email ?? '',
    });
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<AppUserModel?> getCurrentUser() async {
    final sessionUser = supabaseClient.auth.currentUser;
    if (sessionUser == null) return null;

    return AppUserModel.fromJson({
      'id': sessionUser.id,
      'email': sessionUser.email ?? '',
    });
  }
}
