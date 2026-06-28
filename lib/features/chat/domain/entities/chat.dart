import 'package:yemengram/core/app_user/domain/entities/app_user.dart';

class Chat {
  final String id;
  final String? lastMessage;
  final DateTime lastMessageTime;
  final bool isLastMessageFromMe;
  final AppUser otherUser;
  final int unreadCount;

  const Chat({
    required this.id,
    this.lastMessage,
    required this.lastMessageTime,
    required this.isLastMessageFromMe,
    required this.otherUser,
    this.unreadCount = 0,
  });
}
