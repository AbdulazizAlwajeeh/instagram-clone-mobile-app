import 'package:yemengram/core/app_user/domain/entities/app_user.dart';

/// Core domain business model representing a unified chat conversation channel.
///
/// This entity encapsulates high-level presentation information required by the UI
/// layer and is decoupled completely from external infrastructure databases.
class Chat {
  /// The unique verification identity string of the conversation thread.
  final String id;

  /// The textual string content of the latest message dispatched within this channel.
  final String? lastMessage;

  /// The precise timestamp mapping when the latest message interaction occurred.
  final DateTime lastMessageTime;

  /// Business logic flag to determine if the local authenticated user sent the last message.
  final bool isLastMessageFromMe;

  /// The foundational profile entity container representing the peer participant.
  final AppUser otherUser;

  /// Cumulative count representing unread incoming items targeting the active user.
  final int unreadCount;

  /// Creates an immutable instance of the [Chat] domain entity contract.
  const Chat({
    required this.id,
    this.lastMessage,
    required this.lastMessageTime,
    required this.isLastMessageFromMe,
    required this.otherUser,
    this.unreadCount = 0,
  });
}
