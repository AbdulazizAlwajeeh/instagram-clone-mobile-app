/// Core entity representing a user profile within the domain layer.
///
/// Contains user identifiers, metadata, activity counters, and social status.
class UserProfile {
  /// The unique database identifier for the user.
  final String id;

  /// The unique handle chosen by the user.
  final String username;

  /// The display or legal name of the user.
  final String fullName;

  /// Optional remote endpoint URL targeting the user's avatar asset.
  final String? avatarUrl;

  /// Optional self-written description or biography of the user.
  final String? bio;

  /// Total number of public posts published by this account.
  final int postsCount;

  /// Total number of accounts following this user.
  final int followersCount;

  /// Total number of accounts this user is actively following.
  final int followingCount;

  /// Contextual flag tracking if the active viewer follows this user.
  final bool isFollowing;

  /// Creates a immutable [UserProfile] entity instance.
  const UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
  });

  /// Generates a modified replica of this object updating specific properties.
  UserProfile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? bio,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
