import 'package:yemengram/core/posts/domain/entities/post.dart';
import '../../domain/entities/user_profile.dart';

/// Sealed base class representing all possible states for the profile feature.
sealed class ProfileState {
  /// Base constant constructor for all profile states.
  const ProfileState();
}

/// Initial state of the state machine upon structural instantiation.
class ProfileInitial extends ProfileState {}

/// Core visual blocker state while async processing channels execute.
class ProfileLoading extends ProfileState {}

/// Success milestone holding full public profile values.
class ProfileLoadSuccess extends ProfileState {
  /// The user profile details entity.
  final UserProfile profile;

  /// Tracks if the loaded profile belongs to the currently logged-in user.
  final bool isMe;

  /// The collection of posts published by this profile.
  final List<Post> posts;

  /// Creates a immutable [ProfileLoadSuccess] state with required data payloads.
  const ProfileLoadSuccess({
    required this.profile,
    required this.isMe,
    required this.posts,
  });

  /// Allows swapping out the mutated profile copy while preserving the active
  /// posts array.
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
  /// The user-facing error message describing the failure.
  final String errorMessage;

  /// Creates a [ProfileLoadFailure] state with the required error description.
  const ProfileLoadFailure({required this.errorMessage});
}
