import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/features/chat/domain/entities/message.dart';

void main() {
  group('Message Entity Validation Suite', () {
    final tTime = DateTime.parse('2026-07-04T12:05:00.000Z');

    test('should construct correctly and match parameter inputs', () {
      // Act
      final messageInstance = Message(
        id: 'msg_99',
        chatId: 'chat_01',
        senderId: 'user_current',
        receiverId: 'user_target',
        content: 'Writing quality domain entity tests.',
        isRead: false,
        createdAt: tTime,
      );

      // Assert
      expect(messageInstance.id, equals('msg_99'));
      expect(messageInstance.chatId, equals('chat_01'));
      expect(messageInstance.senderId, equals('user_current'));
      expect(messageInstance.receiverId, equals('user_target'));
      expect(
        messageInstance.content,
        equals('Writing quality domain entity tests.'),
      );
      expect(messageInstance.isRead, isFalse);
      expect(messageInstance.createdAt, equals(tTime));
    });
  });
}
