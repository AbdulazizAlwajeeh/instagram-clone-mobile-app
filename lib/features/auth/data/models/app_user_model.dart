import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.email,
  });

  /// Factory constructor to convert raw Supabase database/auth maps into AppUserModel.
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
    );
  }

  /// Converts our model data back into a JSON map for database operations if needed.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}