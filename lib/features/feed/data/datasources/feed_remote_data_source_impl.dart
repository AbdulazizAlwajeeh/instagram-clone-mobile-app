import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/posts/data/models/post_model.dart';
import 'feed_remote_data_source.dart';

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final SupabaseClient supabaseClient;

  FeedRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PostModel>> getFollowedUsersPostsRaw({
    required String userId,
    required int limit,
    required DateTime? lastPostTimestamp,
  }) async {
    try {
      // SINGLE NETWORK CALL:
      // 1. Get posts
      // 2. Inner join profiles to get user details
      // 3. Inner join follows to only keep authors the user is following
      var query = supabaseClient
          .from('posts')
          .select('''
        *,
        profiles!inner (
          username,
          avatar_url,
          follows!following_id!inner (
            follower_id
          )
        ),
        likes:likes(count)
      ''')
          // Filter the deeply nested follow table on the server side
          .eq('profiles.follows.follower_id', userId)
          // Filters the nested likes sub-query down to ONLY the current viewer's ID
          .eq('likes.user_id', userId);

      // ONLY append the cursor constraint if it's page 2 or deeper
      if (lastPostTimestamp != null) {
        query = query.lt('created_at', lastPostTimestamp.toIso8601String());
      }

      // Execute the final block
      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return response.map((postJson) => PostModel.fromJson(postJson)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
