import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/features/chat/data/models/message_model.dart';
import 'package:yemengram/features/chat/domain/entities/message.dart';

void main() {
  const tIsoTimeString = '2026-07-04T12:00:00.000Z';
  final tDateTime = DateTime.parse(tIsoTimeString).toLocal();

  final tMessageModel = MessageModel(
    id: 'msg_111',
    chatId: 'chat_001',
    senderId: 'user_125',
    receiverId: 'user_999',
    content: 'Hello, testing this model!',
    isRead: true,
    createdAt: tDateTime,
  );

  final tRawJsonMap = {
    'id': 'msg_111',
    'conversation_id': 'chat_001',
    'sender_id': 'user_125',
    'receiver_id': 'user_999',
    'content': 'Hello, testing this model!',
    'is_read': true,
    'created_at': tIsoTimeString,
  };

  test('should be a subclass of Message entity', () {
    // Assert
    expect(tMessageModel, isA<Message>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when JSON contains all database columns',
      () {
        // Act
        final result = MessageModel.fromJson(tRawJsonMap);

        // Assert
        expect(result.id, tMessageModel.id);
        expect(result.chatId, tMessageModel.chatId);
        expect(result.senderId, tMessageModel.senderId);
        expect(result.receiverId, tMessageModel.receiverId);
        expect(result.content, tMessageModel.content);
        expect(result.isRead, tMessageModel.isRead);
        expect(result.createdAt, tMessageModel.createdAt);
      },
    );

    test(
      'should fallback to safe default values when optional JSON fields are null',
      () {
        // Arrange
        final jsonWithNulls = {
          'id': 'msg_222',
          'conversation_id': 'chat_001',
          'sender_id': 'user_125',
          'receiver_id': 'user_999',
          'content': null,
          'is_read': null,
          'created_at': null,
        };

        // Act
        final result = MessageModel.fromJson(jsonWithNulls);

        // Assert
        expect(result.content, equals(''));
        expect(result.isRead, equals(false));
        expect(result.createdAt, isA<DateTime>());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a clean Supabase insert map structure excluding schema keys',
      () {
        // Act
        final result = tMessageModel.toJson();

        // Assert
        final expectedPayloadMap = {
          'conversation_id': 'chat_001',
          'sender_id': 'user_125',
          'receiver_id': 'user_999',
          'content': 'Hello, testing this model!',
          'is_read': true,
        };
        expect(result, equals(expectedPayloadMap));
      },
    );
  });
}
