import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetOrCreateChat implements UseCase<Chat, String> {
  final ChatRepository _chatRepository;

  const GetOrCreateChat(this._chatRepository);

  @override
  Future<Either<Failure, Chat>> call(String targetUserId) async {
    return await _chatRepository.getOrCreateChat(targetUserId);
  }
}
