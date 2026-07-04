import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:yemengram/features/chat/data/models/chat_model.dart';
import 'package:yemengram/features/chat/data/models/message_model.dart';
import 'package:yemengram/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:yemengram/features/chat/domain/entities/chat.dart';
import 'package:yemengram/features/chat/domain/entities/message.dart';

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(mockRemoteDataSource);
  });

  const tTargetUserId = 'user_999';
  const tChatId = 'chat_001';
  const tExceptionMessage = 'Network Timeout Error';
  final tDateTime = DateTime.parse('2026-07-04T12:00:00.000Z');

  final tChatModel = ChatModel(
    id: tChatId,
    userOneId: 'user_125',
    userTwoId: tTargetUserId,
    lastMessageTime: tDateTime,
    isLastMessageFromMe: true,
    otherUser: const AppUser(
      id: tTargetUserId,
      email: 'a@b.com',
      username: 'A',
    ),
  );

  final tMessageModel = MessageModel(
    id: 'msg_01',
    chatId: tChatId,
    senderId: 'user_125',
    receiverId: tTargetUserId,
    content: 'Hi',
    isRead: false,
    createdAt: tDateTime,
  );

  group('watchAllChats', () {
    test(
      'should return Right containing Stream of Chat list when successful',
      () async {
        // Arrange - Mocktail uses lambda syntax for target calls: () => method()
        when(
          () => mockRemoteDataSource.watchAllChats(),
        ).thenAnswer((_) => Stream.value([tChatModel]));

        // Act
        final result = await repository.watchAllChats();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (stream) => expect(stream, emits(isA<List<Chat>>())),
        );
        verify(() => mockRemoteDataSource.watchAllChats()).called(1);
      },
    );

    test('should return Left with ServerFailure on ServerException', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.watchAllChats(),
      ).thenThrow(ServerException(tExceptionMessage));

      // Act
      final result = await repository.watchAllChats();

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals(tExceptionMessage));
      }, (_) => fail('Should be Left'));
    });
  });

  group('getOrCreateChat', () {
    test(
      'should return Right with Chat entity when data fetch is successful',
      () async {
        // Arrange - Mocktail matches broad arguments using any() inside lambda closures
        when(
          () => mockRemoteDataSource.getOrCreateChat(any()),
        ).thenAnswer((_) async => tChatModel);

        // Act
        final result = await repository.getOrCreateChat(tTargetUserId);

        // Assert
        expect(result, equals(Right(tChatModel)));
        verify(
          () => mockRemoteDataSource.getOrCreateChat(tTargetUserId),
        ).called(1);
      },
    );

    test(
      'should return Left with ServerFailure when data source crashes',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getOrCreateChat(any()),
        ).thenThrow(ServerException(tExceptionMessage));

        // Act
        final result = await repository.getOrCreateChat(tTargetUserId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals(tExceptionMessage));
        }, (_) => fail('Should be Left'));
      },
    );
  });

  group('watchMessages', () {
    test('should return Right with message entity stream list maps', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.watchMessages(any()),
      ).thenAnswer((_) => Stream.value([tMessageModel]));

      // Act
      final result = await repository.watchMessages(tChatId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (stream) => expect(stream, emits(isA<List<Message>>())),
      );
      verify(() => mockRemoteDataSource.watchMessages(tChatId)).called(1);
    });
  });

  group('sendMessage', () {
    test(
      'should return Right with unit value when message is sent successfully',
      () async {
        // Arrange - Mocktail utilizes named parameter matchers using named: 'parameterName'
        when(
          () => mockRemoteDataSource.sendMessage(
            chatId: any(named: 'chatId'),
            receiverId: any(named: 'receiverId'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.sendMessage(
          chatId: tChatId,
          receiverId: tTargetUserId,
          content: 'Hi',
        );

        // Assert
        expect(result, equals(const Right(unit)));
        verify(
          () => mockRemoteDataSource.sendMessage(
            chatId: tChatId,
            receiverId: tTargetUserId,
            content: 'Hi',
          ),
        ).called(1);
      },
    );
  });

  group('markMessagesAsRead', () {
    test(
      'should return Right with unit when database mutation completes',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.markMessagesAsRead(any()),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.markMessagesAsRead(tChatId);

        // Assert
        expect(result, equals(const Right(unit)));
        verify(
          () => mockRemoteDataSource.markMessagesAsRead(tChatId),
        ).called(1);
      },
    );
  });
}
