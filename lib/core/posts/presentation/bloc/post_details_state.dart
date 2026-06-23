import 'package:meta/meta.dart';
import '../../domain/entities/comment.dart';

@immutable
sealed class PostDetailState {
  const PostDetailState();
}

class PostDetailInitial extends PostDetailState {
  const PostDetailInitial();
}

class PostDetailLoading extends PostDetailState {
  final dynamic post; // Keeps old data visible during pull-to-refresh
  final List<Comment>
  comments; // Added: Retains comments list during a background reload

  const PostDetailLoading({this.post, this.comments = const []});
}

class PostDetailSuccess extends PostDetailState {
  final dynamic post;
  final List<Comment>
  comments; // Added: Active comments list retrieved from Supabase

  const PostDetailSuccess(
    this.post, {
    this.comments =
        const [], // Default to an empty array for clean instantiation
  });
}

class PostDetailFailure extends PostDetailState {
  final String errorMessage;
  final dynamic post; // Retains data if a background refresh fails
  final List<Comment>
  comments; // Added: Retains current comments list if an operation fails

  const PostDetailFailure(
    this.errorMessage, {
    this.post,
    this.comments = const [],
  });
}
