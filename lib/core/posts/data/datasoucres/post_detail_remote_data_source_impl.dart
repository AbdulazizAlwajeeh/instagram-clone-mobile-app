import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import 'post_detail_remote_data_source.dart';

/// Concrete implementation of [PostDetailRemoteDataSource] using [SupabaseClient].
///
/// Handles low-level database operations, table joins, transactions, and conversion
/// of raw relational data JSON into clean Dart domain models.
class PostDetailRemoteDataSourceImpl implements PostDetailRemoteDataSource {
  /// Direct client reference to communicate with your Supabase backend application instance.
  final SupabaseClient _supabaseClient;

  /// Creates a [PostDetailRemoteDataSourceImpl] instance with the required client injection.
  const PostDetailRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<PostModel> getPostById(String postId) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      // Queries your posts table and joins the author profile data dynamically
      final data = await _supabaseClient
          .from('posts')
          .select('''
        *,
        profiles (
          id,
          username,
          avatar_url
        ),
        likes:likes(count),
        reported_by_me:post_reports(reporter_id)
      ''')
          .eq('id', postId)
          // Ensures the detail view also knows if the viewer liked this specific post
          .eq('likes.user_id', currentUserId ?? '')
          .eq('reported_by_me.reporter_id', currentUserId ?? '')
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

  @override
  Future<List<CommentModel>> getPostComments(String postId) async {
    try {
      final List<dynamic> data = await _supabaseClient
          .from('comments')
          .select('''
            id,
            post_id,
            user_id,
            message,
            created_at,
            profiles (
              username,
              avatar_url
            )
          ''')
          .eq('post_id', postId)
          .order('created_at', ascending: false);
      return data.map((commentJson) {
        final profile = commentJson['profiles'] as Map<String, dynamic>?;

        // Normalize raw nested table joins into a single flat model structure.
        return CommentModel.fromJson({
          'id': commentJson['id'],
          'post_id': commentJson['post_id'],
          'user_id': commentJson['user_id'],
          'message': commentJson['message'],
          'created_at': commentJson['created_at'],
          'username': profile?['username'] ?? 'unknown_user',
          'avatar_url': profile?['avatar_url'] ?? '',
        });
      }).toList();
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      if (currentUserId == null) {
        throw const ServerException('User authentication session not found.');
      }

      await _supabaseClient.from('comments').insert({
        'post_id': postId,
        'user_id': currentUserId,
        'message': text,
      });
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<void> reportPost({required String postId}) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      if (currentUserId == null) {
        throw const ServerException('User authentication session not found.');
      }
      await _supabaseClient.from('post_reports').insert({
        'post_id': postId,
        'reporter_id': currentUserId,
      });
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
