import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';
import 'package:yemengram/features/chat/domain/repositories/chat_repository.dart';
import 'package:yemengram/features/chat/domain/usecases/get_or_create_chat.dart';

/// Reusable mock class implementing the core domain contract definition.
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late GetOrCreateChat useCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    useCase = GetOrCreateChat(mockChatRepository);
  });

  const tTargetUserId = 'user_target_777';
  const tFailureMessage =
      'Unable to verify or allocate chat table channel allocation parameters.';

  final tChatEntity = Chat(
    id: 'allocated_chat_channel_id',
    lastMessage: null,
    lastMessageTime: DateTime.now(),
    isLastMessageFromMe: false,
    otherUser: const AppUser(
      id: tTargetUserId,
      email: 'target@yemengram.com',
      username: 'yemen_chat_partner',
    ),
    unreadCount: 0,
  );

  test(
    'should forward targetUserId parameters to repository and return Right(Chat) on success',
    () async {
      // Arrange
      when(
        () => mockChatRepository.getOrCreateChat(any()),
      ).thenAnswer((_) async => Right(tChatEntity));

      // Act
      final result = await useCase(tTargetUserId);

      // Assert
      expect(result, equals(Right(tChatEntity)));
      verify(() => mockChatRepository.getOrCreateChat(tTargetUserId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );

  test(
    'should return Left with Failure when backend lookup orchestration experiences errors',
    () async {
      // Arrange
      when(
        () => mockChatRepository.getOrCreateChat(any()),
      ).thenAnswer((_) async => const Left(ServerFailure(tFailureMessage)));

      // Act
      final result = await useCase(tTargetUserId);

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
      verify(() => mockChatRepository.getOrCreateChat(tTargetUserId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
