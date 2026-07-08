/// Sealed base class representing all incoming events to the profile business logic component.
sealed class ProfileEvent {
  /// Base constant constructor for all profile events.
  const ProfileEvent();
}

/// Dispatched to initialize profile data pulling routines targeting a specific UID.
class ProfileFetchRequested extends ProfileEvent {
  /// The unique identifier of the user whose profile is being requested.
  final String? userId;

  /// Creates a [ProfileFetchRequested] event with the given [userId].
  const ProfileFetchRequested({required this.userId});
}

/// Dispatched to trigger a silent background refresh of already initialized profile data.
///
/// This is used for pull-to-refresh user interactions. It updates the profile state
/// without dispatching a full-screen loading state, preserving the existing view.
class ProfileRefreshRequested extends ProfileEvent {
  /// The unique identifier of the user whose profile is being refreshed.
  final String? userId;

  /// Creates a [ProfileRefreshRequested] event with the given [userId].
  const ProfileRefreshRequested({required this.userId});
}

/// Dispatched when the user interacts with the follow/unfollow action block button.
class ProfileFollowToggleRequested extends ProfileEvent {
  /// The target user ID to follow or unfollow.
  final String targetUserId;

  /// Creates a [ProfileFollowToggleRequested] event with the required [targetUserId].
  const ProfileFollowToggleRequested({required this.targetUserId});
}
