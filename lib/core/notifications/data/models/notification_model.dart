import '../../domain/entities/notification.dart';

/// Data model representing a notification within the data layer.
///
/// Extends the core [Notification] domain entity to provide serialization capabilities
/// (JSON parsing and formatting) required for Supabase database operations.
class NotificationModel extends Notification {
  /// Creates an immutable instance of [NotificationModel].
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.payload,
  });

  /// Factory constructor to cleanly convert Supabase JSON maps into a structural
  /// [NotificationModel] instance.
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
    );
  }

  /// Serialization method to format the [NotificationModel] parameters back into
  /// relational JSON fields suitable for Supabase insertion or updates.
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body, 'payload': payload};
  }
}
