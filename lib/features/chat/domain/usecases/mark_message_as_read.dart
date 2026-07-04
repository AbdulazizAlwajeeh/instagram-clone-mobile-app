import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

/// Business use case responsible for flagging received unread messages as read.
///
/// Triggers database mutation pathways through [ChatRepository] to reset localized
/// unread badge metrics for a dedicated conversation lane.
class MarkMessagesAsRead implements UseCase<Unit, String> {
  final ChatRepository _chatRepository;

  /// Creates a single immutable instance of [MarkMessagesAsRead].
  const MarkMessagesAsRead(this._chatRepository);

  @override
  Future<Either<Failure, Unit>> call(String chatId) async {
    return await _chatRepository.markMessagesAsRead(chatId);
  }
}
