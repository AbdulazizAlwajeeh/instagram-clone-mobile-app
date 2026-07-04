import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

/// Contract definition for the post creation domain repository interface layer.
///
/// Outlines the structural requirements for handling media assets and relational
/// database persistence operations without exposing domain-specific implementations.
abstract class CreatePostRepository {
  /// Publishes a new user post to the system.
  ///
  /// This operation handles both media storage asset uploading and relational
  /// database record insertion sequentially as a single logical transaction.
  ///
  /// ### Parameters:
  /// * [caption] : A description text typed by the author.
  /// * [mediaFile] : The absolute local path binary [File] reference picked from the device cache.
  /// * [authorId] : The distinct, authenticated system identification key of the logged-in user.
  ///
  /// ### Returns:
  /// * `Right(unit)` if the media asset is stored securely and the database row is populated.
  /// * `Left(Failure)` packaging a readable domain error message if network connectivity drops,
  ///   storage writes are rejected, or server authorization validation fails.
  Future<Either<Failure, Unit>> createPost({
    required String caption,
    required File mediaFile,
    required String authorId,
  });
}
