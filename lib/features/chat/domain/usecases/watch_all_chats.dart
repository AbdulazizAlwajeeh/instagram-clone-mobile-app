import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class WatchAllChats implements UseCase<Stream<List<Chat>>, NoParams> {
  final ChatRepository _chatRepository;

  const WatchAllChats(this._chatRepository);

  @override
  Future<Either<Failure, Stream<List<Chat>>>> call(
    NoParams params,
  ) async {
    return await _chatRepository.watchAllChats();
  }
}
