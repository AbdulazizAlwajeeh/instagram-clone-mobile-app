import '../../../../core/app_user/domain/entities/app_user.dart';

/// Data transfer object extending core domain entity layers to facilitate JSON mutations.
///
/// Bridges abstract domain entities to database-specific representations, isolating serialization
/// logic from corporate-level business rules.
class AppUserModel extends AppUser {
  /// Instantiates a data-layer representation of an application user profile configuration.
  const AppUserModel({
    required super.id,
    required super.email,
    required super.username,
    super.avatarUrl,
  });

  /// Factory constructor to convert raw Supabase database/auth maps into [AppUserModel].
  ///
  /// Safeguards extraction loops by looking into top-tier keys or fallback metadata maps
  /// depending on whether the payload stems from a database query or authentication challenge.
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username:
          json['username'] as String? ??
          json['user_metadata']?['username']
              as String? ?? // Safe fallback extraction route for Auth responses.
          '',
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Converts our model data back into a JSON map for database operations if needed.
  ///
  /// Simplifies down-stream serialization payloads targeting remote tables or local caches.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }
}
