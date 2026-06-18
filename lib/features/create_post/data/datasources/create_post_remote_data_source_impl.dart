import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import 'create_post_remote_data_source.dart';

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final SupabaseClient _supabaseClient;

  const CreatePostRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<void> createPost({
    required String caption,
    required File mediaFile,
    required String authorId,
  }) async {
    try {
      // Convert file handle into raw binary bytes required for Supabase upload
      final fileBytes = await mediaFile.readAsBytes();

      // Combine microsecond timestamps and file hashes to prevent naming collisions
      final String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
      final String uniqueId = mediaFile.path.hashCode.abs().toString();

      // Organize files into distinct, user-specific directory folders
      final String storagePath = '$authorId/${timestamp}_$uniqueId.jpg';

      // Push raw asset binary stream straight to your secure storage bucket
      await _supabaseClient.storage
          .from('post-media')
          .uploadBinary(storagePath, fileBytes);

      // Extract the remote edge link used to populate the database column
      final String publicMediaUrl = _supabaseClient.storage
          .from('post-media')
          .getPublicUrl(storagePath);

      // Forming a payload with the necessary fields
      final payload = {
        'user_id': authorId,
        'caption': caption,
        'media_url': publicMediaUrl,
      };

      // Inserting to the post to the table
      await _supabaseClient.from('posts').insert(payload);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
