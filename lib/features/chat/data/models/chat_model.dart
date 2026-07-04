import '../../../../core/app_user/domain/entities/app_user.dart';
import '../../domain/entities/chat.dart';

/// Data representation model for a chat conversation row.
///
/// Extends the core [Chat] entity to map database fields from the data layer,
/// providing factory methods for serialization and conversion.
class ChatModel extends Chat {
  /// The unique identification key of the first participant.
  final String userOneId;

  /// The unique identification key of the second participant.
  final String userTwoId;

  /// The unique identification key of the user who dispatched the latest message.
  final String? lastSenderId;

  /// Creates a concrete instance of [ChatModel].
  const ChatModel({
    required super.id,
    required this.userOneId,
    required this.userTwoId,
    super.lastMessage,
    required super.lastMessageTime,
    this.lastSenderId,
    required super.isLastMessageFromMe,
    required super.otherUser,
    super.unreadCount = 0,
  });

  /// Factory constructor to convert raw Supabase rows and profile data into [ChatModel].
  ///
  /// Combines the conversation map row data with explicit [currentUserId],
  /// [otherUserEntity], and [unreadCount] contexts computed during the data fetch.
  factory ChatModel.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
    required AppUser otherUserEntity,
    required int unreadCount,
  }) {
    final lastSender = json['last_sender_id'] as String?;

    return ChatModel(
      id: json['id'] as String,
      userOneId: json['user_one'] as String,
      userTwoId: json['user_two'] as String,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'] as String).toLocal()
          : DateTime.now(),
      lastSenderId: lastSender,
      isLastMessageFromMe: lastSender == currentUserId,
      otherUser: otherUserEntity,
      unreadCount: unreadCount,
    );
  }

  /// Converts the chat model variables back into a Supabase-compatible JSON map.
  ///
  /// Excludes relational runtime data like unread counts or sub-entities
  /// to keep the map restricted to properties matching the core chats table fields.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_one': userOneId,
      'user_two': userTwoId,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toUtc().toIso8601String(),
      'last_sender_id': lastSenderId,
    };
  }
}
