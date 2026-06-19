sealed class ProfileEvent {
  const ProfileEvent();
}

/// Dispatched to initialize profile data pulling routines targeting a specific UID.
class ProfileFetchRequested extends ProfileEvent {
  final String? userId;

  const ProfileFetchRequested({required this.userId});
}

/// Dispatched to trigger a silent background refresh of already initialized profile data.
///
/// This is used for pull-to-refresh user interactions. It updates the profile state
/// without dispatching a full-screen loading state, preserving the existing view.
class ProfileRefreshRequested extends ProfileEvent {
  final String? userId;

  const ProfileRefreshRequested({required this.userId});
}

/// Dispatched when the user interacts with the follow/unfollow action block button.
class ProfileFollowToggleRequested extends ProfileEvent {
  final String targetUserId;

  const ProfileFollowToggleRequested({required this.targetUserId});
}
