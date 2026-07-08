import '../../domain/entities/user_profile.dart';

/// Data model representing a user profile, extending the core [UserProfile] entity.
///
/// Handles serialization and deserialization from database JSON records.
class UserProfileModel extends UserProfile {
  /// Creates a [UserProfileModel] instance initialized with database properties.
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.fullName,
    super.avatarUrl,
    super.bio,
    required super.postsCount,
    required super.followersCount,
    required super.followingCount,
    required super.isFollowing,
  });

  /// Factory constructor to convert raw Supabase database rows into [UserProfileModel].
  ///
  /// Extracts counts safely converting [num] types to integers. The parameter
  /// [isFollowing] tracks contextual social connections relative to the reader.
  factory UserProfileModel.fromJson(
    Map<String, dynamic> json, {
    required bool isFollowing,
  }) {
    return UserProfileModel(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
      isFollowing: isFollowing,
    );
  }

  /// Converts our model data back into a JSON map if needed for update operations.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'posts_count': postsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
    };
  }
}
