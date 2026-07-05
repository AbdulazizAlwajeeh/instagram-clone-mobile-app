import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/posts/data/models/post_model.dart';
import '../../../../core/posts/domain/entities/post.dart';
import 'explore_remote_data_source.dart';

/// Implementation of [ExploreRemoteDataSource] interacting with Supabase.
class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final SupabaseClient _supabaseClient;

  /// Creates an instance of [ExploreRemoteDataSourceImpl] with a [SupabaseClient].
  const ExploreRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      // Safely read the authenticated user's ID to filter dynamic like states.
      final currentUserId = _supabaseClient.auth.currentUser?.id;

      // Query posts with joined profile information and aggregated like counts.
      final List<dynamic> data = await _supabaseClient
          .from('posts')
          .select('''
        *,
        profiles (
          username,
          avatar_url
        ),
        likes:likes(count)
      ''')
          .eq('likes.user_id', currentUserId ?? '');

      // Parse JSON raw payloads into domain-compliant models.
      return data
          .map(
            (postData) => PostModel.fromJson(postData as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (error) {
      // Map specific database transaction issues into domain exceptions.
      throw ServerException(error.message);
    } catch (error) {
      // Handle remaining unknown network or type-casting exceptions.
      throw ServerException(error.toString());
    }
  }
}
