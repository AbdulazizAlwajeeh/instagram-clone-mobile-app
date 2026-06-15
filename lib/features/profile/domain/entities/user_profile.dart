class UserProfile {
  final String id;
  final String username;
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const UserProfile({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });
}
