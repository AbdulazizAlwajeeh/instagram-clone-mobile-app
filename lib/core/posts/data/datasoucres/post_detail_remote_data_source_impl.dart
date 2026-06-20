import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../models/post_model.dart';
import 'post_detail_remote_data_source.dart';

class PostDetailRemoteDataSourceImpl implements PostDetailRemoteDataSource {
  final SupabaseClient _supabaseClient;

  const PostDetailRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<Post> getPostById(String postId) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      // Queries your posts table and joins the author profile data dynamically
      final data = await _supabaseClient
          .from('posts')
          .select('''
        *,
        profiles (
          username,
          avatar_url
        ),
        likes:likes(count)
      ''')
          .eq('id', postId)
          // Ensures the detail view also knows if the viewer liked this specific post
          .eq('likes.user_id', currentUserId ?? '')
          .single();

      // Map the returned Map<String, dynamic> using your Post model factory
      return PostModel.fromJson(data);
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<void> toggleLikePost(String postId) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      if (currentUserId == null) {
        throw const ServerException('User authentication session not found.');
      }

      // Check if the like entry already exists
      final existingLike = await _supabaseClient
          .from('likes')
          .select()
          .eq('post_id', postId)
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike: Delete the row if it's already liked
        await _supabaseClient
            .from('likes')
            .delete()
            .eq('post_id', postId)
            .eq('user_id', currentUserId);
      } else {
        // Like: Insert a row if it's not liked yet
        await _supabaseClient.from('likes').insert({
          'post_id': postId,
          'user_id': currentUserId,
        });
      }
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
