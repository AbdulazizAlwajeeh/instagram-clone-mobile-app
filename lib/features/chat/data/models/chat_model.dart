import '../../../../core/app_user/domain/entities/app_user.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  final String userOneId;
  final String userTwoId;
  final String? lastSenderId;

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

  /// Factory constructor to convert raw Supabase rows and profile data into ChatModel.
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
