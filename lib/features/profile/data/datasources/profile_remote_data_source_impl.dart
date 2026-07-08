import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/posts/data/models/post_model.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_data_source.dart';

/// Production implementation of [ProfileRemoteDataSource] powered by the Supabase backend client.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabaseClient;

  /// Creates a [ProfileRemoteDataSourceImpl] with the required [SupabaseClient] dependency.
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
            .select('') // Just grab a count to reduce payload
            .eq('follower_id', currentUserId)
            .eq('following_id', userId)
            .count(CountOption.exact);

        isFollowingTarget = followCheck.count > 0;
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

  @override
  Future<void> editProfile({
    String? username,
    String? fullName,
    String? bio,
    dynamic imageFile,
  }) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      if (currentUserId == null) {
        throw const ServerException('User is not authenticated.');
      }
      final Map<String, dynamic> updateData = {};
      if (username != null) updateData['username'] = username;
      if (fullName != null) updateData['full_name'] = fullName;
      if (bio != null) updateData['bio'] = bio;

      if (imageFile != null) {
        // Convert to raw bytes
        final fileBytes = await imageFile.readAsBytes();

        // Collision-safe naming formula
        final String timestamp = DateTime.now().microsecondsSinceEpoch
            .toString();
        final String uniqueId = imageFile.path.hashCode.abs().toString();

        // Keep files separated in distinct, user-specific directory folders
        final String storagePath = '$currentUserId/${timestamp}_$uniqueId.jpg';

        // Push raw asset binary stream straight to the storage bucket
        await _supabaseClient.storage
            .from('avatars')
            .uploadBinary(storagePath, fileBytes);

        // Extract public URL to pass to your profile table
        final String publicUrl = _supabaseClient.storage
            .from('avatars')
            .getPublicUrl(storagePath);

        updateData['avatar_url'] = publicUrl;
      }

      // Only make the database call if there is actual data to modify
      if (updateData.isNotEmpty) {
        await _supabaseClient
            .from('profiles')
            .update(updateData)
            .eq('id', currentUserId);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      final response = await _supabaseClient
          .from('profiles')
          .select('username')
          .eq('username', username.trim())
          .neq('id', currentUserId ?? '');

      // If the list is empty, the username is available (true)
      return (response as List).isEmpty;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
