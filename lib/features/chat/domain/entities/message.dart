/// Core business entity representing an individual chat transmission block.
///
/// Encapsulates the immutable payload properties, timeline logs, and delivery
/// context signatures for a single message record in the domain space.
class Message {
  /// The unique verification key identifying this individual message entry.
  final String id;

  /// The reference identifier pointing to the parent communication channel table entry.
  final String chatId;

  /// The identity reference key belonging to the account that generated this entry.
  final String senderId;

  /// The identity reference key belonging to the target account designated as the destination.
  final String receiverId;

  /// The descriptive message body context characters contained in this instance payload.
  final String content;

  /// A mutation state tracking parameter defining if the destination profile read this element.
  final bool isRead;

  /// The point-in-time chronological record specifying exactly when this entry was processed.
  final DateTime createdAt;

  /// Creates an immutable instance of [Message].
  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });
}
