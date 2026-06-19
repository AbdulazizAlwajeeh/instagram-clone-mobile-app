import 'package:yemengram/core/posts/domain/entities/post.dart';
import '../../domain/entities/user_profile.dart';

sealed class ProfileState {
  const ProfileState();
}

/// Initial state of the state machine upon structural instantiation.
class ProfileInitial extends ProfileState {}

/// Core visual blocker state while async processing channels execute.
class ProfileLoading extends ProfileState {}

/// Success milestone holding full public profile values.
class ProfileLoadSuccess extends ProfileState {
  final UserProfile profile;
  final bool isMe;
  final List<Post> posts;

  const ProfileLoadSuccess({
    required this.profile,
    required this.isMe,
    required this.posts,
  });

  /// to swap out the mutated profile copy while preserving the active posts array.
  ProfileLoadSuccess copyWith({
    UserProfile? profile,
    List<Post>? posts,
    bool? isMe,
  }) {
    return ProfileLoadSuccess(
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      isMe: isMe ?? this.isMe,
    );
  }
}

/// Failure boundary capturing operational exceptions.
class ProfileLoadFailure extends ProfileState {
  final String errorMessage;

  const ProfileLoadFailure({required this.errorMessage});
}
