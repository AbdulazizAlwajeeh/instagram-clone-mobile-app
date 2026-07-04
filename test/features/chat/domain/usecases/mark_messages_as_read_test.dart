import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/chat/domain/repositories/chat_repository.dart';
import 'package:yemengram/features/chat/domain/usecases/mark_message_as_read.dart';

/// Reusable mock class implementing the core domain contract definition.
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MarkMessagesAsRead useCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    useCase = MarkMessagesAsRead(mockChatRepository);
  });

  const tChatId = 'conversation_id_xyz';
  const tFailureMessage =
      'Failed to execute read acknowledgement status mutation.';

  test(
    'should forward chatId parameters to repository and return Right(unit) on success',
    () async {
      // Arrange
      when(
        () => mockChatRepository.markMessagesAsRead(any()),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase(tChatId);

      // Assert
      expect(result, equals(const Right(unit)));
      verify(() => mockChatRepository.markMessagesAsRead(tChatId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );

  test(
    'should return Left with Failure when database mutation pipeline encounters errors',
    () async {
      // Arrange
      when(
        () => mockChatRepository.markMessagesAsRead(any()),
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
      verify(() => mockChatRepository.markMessagesAsRead(tChatId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
