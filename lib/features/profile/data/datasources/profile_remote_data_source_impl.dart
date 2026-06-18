import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/posts/data/models/post_model.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabaseClient;

  const ProfileRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        throw const ServerException(
          'Requested public user profile does not exist.',
        );
      }

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final response = await _supabaseClient
          .from('posts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((postJson) => PostModel.fromFlatJson(postJson))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
