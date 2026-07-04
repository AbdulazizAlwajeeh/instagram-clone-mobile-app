import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/data/models/chat_model.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';

void main() {
  const tCurrentUserId = 'user_125';
  const tOtherUserId = 'user_999';
  const tIsoTimeString = '2026-07-04T12:00:00.000Z';
  final tDateTime = DateTime.parse(tIsoTimeString).toLocal();

  // Instantiating the concrete core AppUser entity for the test profile context
  const tOtherUserEntity = AppUser(
    id: tOtherUserId,
    email: 'alice@example.com',
    username: 'Alice99',
    avatarUrl: 'https://example.com',
  );

  final tChatModel = ChatModel(
    id: 'chat_001',
    userOneId: tCurrentUserId,
    userTwoId: tOtherUserId,
    lastMessage: 'Hello there!',
    lastMessageTime: tDateTime,
    lastSenderId: tCurrentUserId,
    isLastMessageFromMe: true,
    otherUser: tOtherUserEntity,
    unreadCount: 3,
  );

  final tJsonMap = {
    'id': 'chat_001',
    'user_one': tCurrentUserId,
    'user_two': tOtherUserId,
    'last_message': 'Hello there!',
    'last_message_time': tDateTime.toUtc().toIso8601String(),
    'last_sender_id': tCurrentUserId,
  };

  test('should be a subclass of Chat entity', () {
    // Assert
    expect(tChatModel, isA<Chat>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when JSON contains all required values',
      () {
        // Act
        final result = ChatModel.fromJson(
          tJsonMap,
          currentUserId: tCurrentUserId,
          otherUserEntity: tOtherUserEntity,
          unreadCount: 3,
        );

        // Assert
        expect(result.id, tChatModel.id);
        expect(result.userOneId, tChatModel.userOneId);
        expect(result.userTwoId, tChatModel.userTwoId);
        expect(result.lastMessage, tChatModel.lastMessage);
        expect(result.lastMessageTime, tChatModel.lastMessageTime);
        expect(result.isLastMessageFromMe, true);
        expect(result.otherUser.id, tOtherUserEntity.id);
        expect(result.otherUser.username, 'Alice99');
        expect(result.unreadCount, 3);
      },
    );

    test('should fallback to current time when last_message_time is null', () {
      // Arrange
      final jsonWithNullTime = Map<String, dynamic>.from(tJsonMap)
        ..remove('last_message_time');

      // Act
      final result = ChatModel.fromJson(
        jsonWithNullTime,
        currentUserId: tCurrentUserId,
        otherUserEntity: tOtherUserEntity,
        unreadCount: 0,
      );

      // Assert
      expect(result.lastMessageTime, isA<DateTime>());
    });

    test(
      'should flag isLastMessageFromMe as false when another user is the sender',
      () {
        // Arrange
        final jsonSentByOther = Map<String, dynamic>.from(tJsonMap)
          ..['last_sender_id'] = tOtherUserId;

        // Act
        final result = ChatModel.fromJson(
          jsonSentByOther,
          currentUserId: tCurrentUserId,
          otherUserEntity: tOtherUserEntity,
          unreadCount: 2,
        );

        // Assert
        expect(result.isLastMessageFromMe, false);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing correct values matching database table schema',
      () {
        // Act
        final result = tChatModel.toJson();

        // Assert
        expect(result, equals(tJsonMap));
      },
    );
  });
}
