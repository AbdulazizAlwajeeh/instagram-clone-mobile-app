import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

/// Domain repository interface defining the contract for managing Chat features.
///
/// Serves as the functional bridge between the Domain business rules and the Data
/// infrastructure layers, isolating entities from direct database dependencies.
abstract class ChatRepository {
  /// Retrieves a real-time reactive stream of all active 1-on-1 chats for the authenticated user.
  ///
  /// The stream automatically filters and builds [Chat] components by identifying
  /// the secondary participant relative to the current logged-in user session.
  ///
  /// Returns a [Failure] on the left side if the stream cannot be initialized,
  /// or a [Stream] of [List<Chat>] on the right side.
  Future<Either<Failure, Stream<List<Chat>>>> watchAllChats();

  /// Establishes or retrieves an existing chat conversation with another specific user.
  ///
  /// This operation checks the structural boundaries of the database to find an existing
  /// communication channel between the two distinct profiles. If none is found, it safely
  /// initializes a new persistent entry.
  ///
  /// Returns a [Failure] on the left side, or the active [Chat] on the right side.
  Future<Either<Failure, Chat>> getOrCreateChat(String targetUserId);

  /// Retrieves a real-time reactive stream of message logs within a specific chat conversation.
  ///
  /// The resulting history is sequentially ordered by creation timeline vectors to ensure
  /// contextual layout alignment within chronological bubble view grids.
  ///
  /// Returns a [Failure] on the left side, or a [Stream] of [List<Message>] on the right side.
  Future<Either<Failure, Stream<List<Message>>>> watchMessages(String chatId);

  /// Dispatches a textual message transaction from the authenticated session context.
  ///
  /// This operation simultaneously records the payload record inside the persistent engine
  /// and updates cache markers on the parent channel context to maintain real-time sync.
  ///
  /// Returns a [Failure] on the left side, or a structural confirmation [Unit] on the right side.
  Future<Either<Failure, Unit>> sendMessage({
    required String chatId,
    required String receiverId,
    required String content,
  });

  /// Updates the read acknowledgement status for all incoming unread items inside a conversation.
  ///
  /// This mutates unread state attributes across matching data targets where the active user session
  /// figures strictly as the message receiver destination, resetting localized unread counts.
  ///
  /// Returns a [Failure] on the left side, or a structural confirmation [Unit] on the right side.
  Future<Either<Failure, Unit>> markMessagesAsRead(String chatId);
}
