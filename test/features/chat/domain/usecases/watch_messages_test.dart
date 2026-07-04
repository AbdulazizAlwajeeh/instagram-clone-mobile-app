import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/chat/domain/entities/message.dart';
import 'package:yemengram/features/chat/domain/repositories/chat_repository.dart';
import 'package:yemengram/features/chat/domain/usecases/watch_messages.dart';

/// Reusable mock class implementing the core domain contract definition.
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late WatchMessages useCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    useCase = WatchMessages(mockChatRepository);
  });

  const tChatId = 'chat_channel_123';
  const tFailureMessage = 'Unable to establish database stream connection.';

  final tMessageList = [
    Message(
      id: 'msg_001',
      chatId: tChatId,
      senderId: 'user_1',
      receiverId: 'user_2',
      content: 'Hello World',
      isRead: true,
      createdAt: DateTime.now(),
    ),
  ];

  test(
    'should return Right containing Stream of Message lists when repository execution is successful',
    () async {
      // Arrange
      when(
        () => mockChatRepository.watchMessages(any()),
      ).thenAnswer((_) async => Right(Stream.value(tMessageList)));

      // Act
      final result = await useCase(tChatId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail(
          'Execution path should yield a successful Right result mapping.',
        ),
        (stream) => expect(stream, emits(equals(tMessageList))),
      );
      verify(() => mockChatRepository.watchMessages(tChatId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );

  test(
    'should return Left with Failure variant when repository execution drops',
    () async {
      // Arrange
      when(
        () => mockChatRepository.watchMessages(any()),
      ).thenAnswer((_) async => const Left(ServerFailure(tFailureMessage)));

      // Act
      final result = await useCase(tChatId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(tFailureMessage));
        },
        (_) => fail(
          'Execution path should fail and map down into a Left branch context.',
        ),
      );
      verify(() => mockChatRepository.watchMessages(tChatId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
