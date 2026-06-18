import 'dart:io';

/// Infrastructure contract defining the remote network operations for post creation.
///
/// This data source interface isolates raw third-party service communication
/// (such as cloud storage systems and relational database engines) from the repository.
abstract class CreatePostRemoteDataSource {
  /// Uploads raw asset binaries and inserts a relational post row to the remote database.
  ///
  /// This implementation performs a two-tier sequence:
  /// 1. Reads the local [mediaFile] into a binary byte stream and uploads it to cloud storage.
  /// 2. Extracts the resulting remote public network link to compile and execute a table insertion.
  ///
  /// ### Parameters:
  /// * [caption] : The textual commentary for the post.
  /// * [mediaFile] : The native local [File] handle targeted for binary stream upload.
  /// * [authorId] : The unique primary key identifier used to resolve the relational `user_id` column.
  ///
  /// ### Throws:
  /// * A [ServerException] if network protocols drop, cloud bucket constraints block the upload,
  ///   or database constraints (like RLS policies) reject the payload.
  Future<void> createPost({
    required String caption,
    required File mediaFile,
    required String authorId,
  });
}
