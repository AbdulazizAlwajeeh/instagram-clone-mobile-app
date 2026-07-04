import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/chat/domain/repositories/chat_repository.dart';
import 'package:yemengram/features/chat/domain/usecases/send_message.dart';

/// Reusable mock class implementing the core domain repository contract definition.
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late SendMessage useCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    useCase = SendMessage(mockChatRepository);
  });

  const tChatId = 'chat_101';
  const tReceiverId = 'user_abc';
  const tContent = 'Automated clean domain logic message test payload.';
  const tFailureMessage = 'Server dropped the connection payload transaction.';

  const tParams = SendMessageParams(
    chatId: tChatId,
    receiverId: tReceiverId,
    content: tContent,
  );

  test(
    'should pass parameters correctly and return Right(unit) on successful repository transmission',
    () async {
      // Arrange - Match named parameters inside Mocktail closure signatures cleanly
      when(
        () => mockChatRepository.sendMessage(
          chatId: any(named: 'chatId'),
          receiverId: any(named: 'receiverId'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, equals(const Right(unit)));
      verify(
        () => mockChatRepository.sendMessage(
          chatId: tChatId,
          receiverId: tReceiverId,
          content: tContent,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );

  test(
    'should intercept execution drops and return Left with Failure variant',
    () async {
      // Arrange
      when(
        () => mockChatRepository.sendMessage(
          chatId: any(named: 'chatId'),
          receiverId: any(named: 'receiverId'),
          content: any(named: 'content'),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure(tFailureMessage)));

      // Act
      final result = await useCase(tParams);

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
      verify(
        () => mockChatRepository.sendMessage(
          chatId: tChatId,
          receiverId: tReceiverId,
          content: tContent,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
