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
      // Fetch current logged-in user
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      // Determine if the profile belongs to the logged-in user
      final bool isMe = userId == currentUserId;

      // If it's not the logged-in user's profile, check the follows table
      // relationship status
      bool isFollowingTarget = false;
      if (!isMe && currentUserId != null) {
        final followCheck = await _supabaseClient
            .from('follows')
            .select('id') // Just grab a minimal field to reduce payload size
            .eq('follower_id', currentUserId)
            .eq('following_id', userId)
            .maybeSingle();

        isFollowingTarget = followCheck != null;
      }

      if (response == null) {
        throw const ServerException(
          'Requested public user profile does not exist.',
        );
      }

      return UserProfileModel.fromJson(
        response,
        isFollowing: isFollowingTarget,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      final response = await _supabaseClient
          .from('posts')
          .select('''
      *,
      profiles (
        username,
        avatar_url
      ),
      likes:likes(count)
    ''')
          .eq('user_id', userId) // Filters for the targeted profile's posts
          // Filters the nested likes sub-query down to ONLY the current viewer's ID
          .eq('likes.user_id', currentUserId ?? '')
          .order('created_at', ascending: false);

      return (response as List)
          .map((postJson) => PostModel.fromFlatJson(postJson))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> followUser(String targetUserId) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      if (currentUserId == null) {
        throw const ServerException('User authentication token not found.');
      }

      await _supabaseClient.from('follows').insert({
        'follower_id': currentUserId,
        'following_id': targetUserId,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unfollowUser(String targetUserId) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      if (currentUserId == null) {
        throw const ServerException('User authentication token not found.');
      }

      await _supabaseClient
          .from('follows')
          .delete()
          .eq('follower_id', currentUserId)
          .eq('following_id', targetUserId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
