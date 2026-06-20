import 'package:meta/meta.dart';

@immutable
sealed class PostDetailState {
  const PostDetailState();
}

class PostDetailInitial extends PostDetailState {
  const PostDetailInitial();
}

class PostDetailLoading extends PostDetailState {
  final dynamic post; // Keeps old data visible during pull-to-refresh
  const PostDetailLoading({this.post});
}

class PostDetailSuccess extends PostDetailState {
  final dynamic post;
  const PostDetailSuccess(this.post);
}

class PostDetailFailure extends PostDetailState {
  final String errorMessage;
  final dynamic post; // Retains data if a background refresh fails
  const PostDetailFailure(this.errorMessage, {this.post});
}
