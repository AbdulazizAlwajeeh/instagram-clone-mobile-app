import 'package:meta/meta.dart';

@immutable
sealed class PostDetailEvent {
  final String postId;
  const PostDetailEvent(this.postId);
}

class PostDetailFetchRequested extends PostDetailEvent {
  const PostDetailFetchRequested({required String postId}) : super(postId);
}

class PostDetailRefreshRequested extends PostDetailEvent {
  const PostDetailRefreshRequested({required String postId}) : super(postId);
}

class PostDetailLikeTapped extends PostDetailEvent {
  const PostDetailLikeTapped({required String postId}) : super(postId);
}
