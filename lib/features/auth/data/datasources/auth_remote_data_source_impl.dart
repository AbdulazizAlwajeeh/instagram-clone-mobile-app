import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user_model.dart';
import 'auth_remote_data_source.dart';
import '../../../../core/error/exceptions.dart';

/// Concrete integration engine executing remote data transactions against the Supabase backend.
///
/// Leverages the provided [SupabaseClient] tool suite to run specialized database functions (RPCs),
/// administer active identity authentication loops, and query table records.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// The global active driver gateway leading directly into the Supabase ecosystem.
  final SupabaseClient supabaseClient;

  /// Creates a concrete remote data provider containing the operational [supabaseClient] handle.
  const AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AppUserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // 1. Call our dedicated RPC function to safely check availability without table access.
      final bool isAvailable = await supabaseClient.rpc(
        'check_username_available',
        params: {'requested_username': username.trim()},
      );

      if (!isAvailable) {
        // Blocks registration routines early if username allocations conflict on database indexes.
        throw const ServerException('This username is already taken.');
      }

      // 2. Single atomic signup call. We pass the username into the raw metadata map.
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user == null) {
        // Enforces checking system-level confirmations to safeguard execution tracks.
        throw const ServerException(
          'Sign up failed: User payload returned null.',
        );
      }

      // 3. CHECK FOR HIDDEN EMAIL COLLISION:
      // If the response succeeds but the identities list is completely empty,
      // Supabase is hiding a duplicate email registration attempt.
      if (response.user!.identities != null &&
          response.user!.identities!.isEmpty) {
        throw const ServerException('This email is already registered.');
      }

      // 4. Return the mapped user model if everything passes safely.
      return AppUserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      // Pass known auth errors straight up to the repository layer.
      throw ServerException(e.message);
    } catch (e) {
      // Wrap any other low-level network or system errors safely.
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppUserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Dispatches baseline authorization requests down to Supabase network adapters.
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException(
          'Sign in failed: Session could not be created.',
        );
      }

      // Pull the associated unique username on login from the profiles table.
      final profileData = await supabaseClient
          .from('profiles')
          .select('username')
          .eq('id', response.user!.id)
          .single(); // Assumes clean 1:1 user-to-profile database schema architecture mapping rules.

      return AppUserModel.fromJson({
        'id': response.user!.id,
        'email': response.user!.email ?? '',
        'username': profileData['username'] ?? '',
      });
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Informs the remote engine to immediately drop access token validations for this client device.
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppUserModel?> getCurrentUser() async {
    try {
      // Evaluates immediate local cache checks using memory signatures.
      final sessionUser = supabaseClient.auth.currentUser;
      if (sessionUser == null) {
        return null;
      } // Returns null smoothly if no user token session
      // footprint is recorded.

      // Restore user unique username along with cache credentials checkout.
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
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
