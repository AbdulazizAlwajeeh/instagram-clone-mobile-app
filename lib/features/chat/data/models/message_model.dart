import '../../domain/entities/message.dart';

/// Data representation model for individual chat message records.
///
/// Extends the core [Message] entity to handle object mapping logic,
/// serialization, and deserialization from the database table rows.
class MessageModel extends Message {
  /// Creates an immutable instance of [MessageModel].
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.isRead,
    required super.createdAt,
  });

  /// Factory constructor to convert raw Supabase message entries into [MessageModel].
  ///
  /// Safe fallbacks are configured to handle null entries for [content],
  /// [isRead] flags, and [createdAt] timestamps gracefully.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String).toLocal()
          : DateTime.now(),
    );
  }

  /// Converts a new message payload into a JSON map ready for insertion into Supabase.
  ///
  /// Excludes properties like database-managed identification [id] or
  /// automatic timestamps to fulfill table write constraint schemas.
  Map<String, dynamic> toJson() {
    return {
      'conversation_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'is_read': isRead,
    };
  }
}
