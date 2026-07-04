import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';
import 'package:yemengram/features/chat/domain/repositories/chat_repository.dart';
import 'package:yemengram/features/chat/domain/usecases/watch_all_chats.dart';

/// Reusable mock class implementing the core domain repository contract definition.
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late WatchAllChats useCase;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    useCase = WatchAllChats(mockChatRepository);
  });

  const tFailureMessage = 'Could not fetch remote chat channels stream.';

  final tChatsList = [
    Chat(
      id: 'chat_id_abc',
      lastMessage: 'Clean implementation works flawlessly.',
      lastMessageTime: DateTime.now(),
      isLastMessageFromMe: false,
      otherUser: const AppUser(
        id: 'other_user_123',
        email: 'other@yemengram.com',
        username: 'yemen_coder',
      ),
      unreadCount: 2,
    ),
  ];

  test(
    'should return Right containing Stream of Chat lists when repository execution completes successfully',
    () async {
      // Arrange
      when(
        () => mockChatRepository.watchAllChats(),
      ).thenAnswer((_) async => Right(Stream.value(tChatsList)));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail(
          'Execution path should yield a successful Right result mapping.',
        ),
        (stream) => expect(stream, emits(equals(tChatsList))),
      );
      verify(() => mockChatRepository.watchAllChats()).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );

  test(
    'should return Left with Failure variant when repository pipeline collapses',
    () async {
      // Arrange
      when(
        () => mockChatRepository.watchAllChats(),
      ).thenAnswer((_) async => const Left(ServerFailure(tFailureMessage)));

      // Act
      final result = await useCase(NoParams());

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
      verify(() => mockChatRepository.watchAllChats()).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    },
  );
}
