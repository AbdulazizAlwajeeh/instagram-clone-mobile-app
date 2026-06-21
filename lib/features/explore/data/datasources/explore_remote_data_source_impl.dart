import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/posts/data/models/post_model.dart';
import '../../../../core/posts/domain/entities/post.dart';
import 'explore_remote_data_source.dart';

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final SupabaseClient _supabaseClient;

  const ExploreRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;

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

      return data
          .map(
            (postData) => PostModel.fromJson(postData as Map<String, dynamic>),
          )
          .toList();
    } on PostgrestException catch (error) {
      throw ServerException(error.message);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
