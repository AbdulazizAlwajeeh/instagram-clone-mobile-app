sealed class ProfileEvent {
  const ProfileEvent();
}

/// Dispatched to initialize profile data pulling routines targeting a specific UID.
class ProfileFetchRequested extends ProfileEvent {
  final String? userId;

  const ProfileFetchRequested({required this.userId});
}
