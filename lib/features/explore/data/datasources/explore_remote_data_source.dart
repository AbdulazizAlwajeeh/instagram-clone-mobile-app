import '../../../../core/posts/domain/entities/post.dart';

/// Contract for the remote data source handling explore-related operations.
///
/// This interface defines the network boundaries for fetching post data.
abstract class ExploreRemoteDataSource {
  /// Queries the Supabase database to retrieve a list of all available posts.
  ///
  /// Throws a [ServerException] if the query fails or data is missing.
  Future<List<Post>> getAllPosts();
}
