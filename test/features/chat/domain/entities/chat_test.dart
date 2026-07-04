import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';

void main() {
  group('Chat Entity Structural Validations', () {
    const tId = 'chat_999';
    const tLastMessage = 'Hey, check out this update!';
    final tLastMessageTime = DateTime.parse('2026-07-04T15:00:00.000Z');
    const tIsLastMessageFromMe = false;
    const tUnreadCount = 5;

    const tOtherUser = AppUser(
      id: 'user_456',
      email: 'peer@yemengram.com',
      username: 'YemenDev',
      avatarUrl: 'https://yemengram.com',
    );

    test(
      'should properly retain all assigned constructor variables during instantiation',
      () {
        // Act
        final chatEntity = Chat(
          id: tId,
          lastMessage: tLastMessage,
          lastMessageTime: tLastMessageTime,
          isLastMessageFromMe: tIsLastMessageFromMe,
          otherUser: tOtherUser,
          unreadCount: tUnreadCount,
        );

        // Assert
        expect(chatEntity.id, equals(tId));
        expect(chatEntity.lastMessage, equals(tLastMessage));
        expect(chatEntity.lastMessageTime, equals(tLastMessageTime));
        expect(chatEntity.isLastMessageFromMe, equals(tIsLastMessageFromMe));
        expect(chatEntity.otherUser, equals(tOtherUser));
        expect(chatEntity.unreadCount, equals(tUnreadCount));
      },
    );

    test(
      'should fallback to 0 unreadCount when initialization parameter is omitted',
      () {
        // Act
        final chatEntity = Chat(
          id: tId,
          lastMessageTime: tLastMessageTime,
          isLastMessageFromMe: tIsLastMessageFromMe,
          otherUser: tOtherUser,
        );

        // Assert
        expect(chatEntity.unreadCount, equals(0));
        expect(chatEntity.lastMessage, isNull);
      },
    );
  });
}
