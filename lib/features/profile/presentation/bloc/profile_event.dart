sealed class ProfileEvent {
  const ProfileEvent();
}

/// Dispatched to initialize profile data pulling routines targeting a specific UID.
class ProfileFetchRequested extends ProfileEvent {
  final String? userId;

  const ProfileFetchRequested({required this.userId});
}

/// Dispatched when the user interacts with the follow/unfollow action block button.
class ProfileFollowToggleRequested extends ProfileEvent {
  final String targetUserId;

  const ProfileFollowToggleRequested({required this.targetUserId});
}
