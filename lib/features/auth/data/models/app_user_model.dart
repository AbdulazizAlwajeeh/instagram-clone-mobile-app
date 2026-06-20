import '../../../../core/app_user/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.email,
    required super.username,
    super.avatarUrl,
  });

  /// Factory constructor to convert raw Supabase database/auth maps into AppUserModel.
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username:
          json['username'] as String? ??
          json['user_metadata']?['username'] as String? ??
          '',
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Converts our model data back into a JSON map for database operations if needed.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }
}
