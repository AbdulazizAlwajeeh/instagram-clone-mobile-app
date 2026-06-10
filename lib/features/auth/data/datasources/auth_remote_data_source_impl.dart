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
    required String username,
  }) async {
    try {
      // 1. Call our dedicated RPC function to safely check availability
      //  without table access
      final bool isAvailable = await supabaseClient.rpc(
        'check_username_available',
        params: {'requested_username': username.trim()},
      );

      if (!isAvailable) {
        throw const AuthException('This username is already taken.');
      }

      // 2. Single atomic signup call. We pass the username into the raw
      // metadata map
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user == null) {
        throw const AuthException(
          'Sign up failed: User payload returned null.',
        );
      }

      // 3. CHECK FOR HIDDEN EMAIL COLLISION:
      // If the response succeeds but the identities list is completely empty,
      // Supabase is hiding a duplicate email registration attempt.
      if (response.user!.identities != null &&
          response.user!.identities!.isEmpty) {
        throw const AuthException('This email is already registered.');
      }

      // 4. Return the mapped user model if everything passes safely
      return AppUserModel.fromJson(response.user!.toJson());
    } on AuthException {
      // Pass known auth errors straight up to the repository layer
      rethrow;
    } catch (e) {
      // Wrap any other low-level network or system errors safely
      throw Exception(e.toString());
    }
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

    // Pull the associated unique username on login from the profiles table
    final profileData = await supabaseClient
        .from('profiles')
        .select('username')
        .eq('id', response.user!.id)
        .single();

    return AppUserModel.fromJson({
      'id': response.user!.id,
      'email': response.user!.email ?? '',
      'username': profileData['username'] ?? '',
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

    // Restore user unique username along with cache credentials checkout
    final profileData = await supabaseClient
        .from('profiles')
        .select('username')
        .eq('id', sessionUser.id)
        .single();

    return AppUserModel.fromJson({
      'id': sessionUser.id,
      'email': sessionUser.email ?? '',
      'username': profileData['username'] ?? '',
    });
  }
}
