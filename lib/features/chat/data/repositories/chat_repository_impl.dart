import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

/// Concrete implementation handling orchestration of data operations for the Chat feature.
///
/// Maps exceptions originating from remote infrastructure elements down to structured
/// business-layer [Failure] wrappers handled by domain use cases.
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  /// Creates a single instance of [ChatRepositoryImpl].
  const ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Stream<List<Chat>>>> watchAllChats() async {
    try {
      final chatStream = _remoteDataSource.watchAllChats();
      // Casts the stream elements up from ChatModel lists to ChatEntity lists
      final domainStream = chatStream.map(
        (models) => models.map((model) => model as Chat).toList(),
      );
      return Right(domainStream);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> getOrCreateChat(String targetUserId) async {
    try {
      final chatModel = await _remoteDataSource.getOrCreateChat(targetUserId);
      return Right(chatModel);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<List<Message>>>> watchMessages(
    String chatId,
  ) async {
    try {
      final messageStream = _remoteDataSource.watchMessages(chatId);
      // Casts the stream elements up from MessageModel lists to MessageEntity lists
      final domainStream = messageStream.map(
        (models) => models.map((model) => model as Message).toList(),
      );
      return Right(domainStream);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String chatId,
    required String receiverId,
    required String content,
  }) async {
    try {
      await _remoteDataSource.sendMessage(
        chatId: chatId,
        receiverId: receiverId,
        content: content,
      );
      return const Right(unit);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markMessagesAsRead(String chatId) async {
    try {
      await _remoteDataSource.markMessagesAsRead(chatId);
      return const Right(unit);
    } on ServerException catch (exception) {
      return Left(ServerFailure(exception.message));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
