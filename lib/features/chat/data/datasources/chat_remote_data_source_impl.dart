import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/app_user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_remote_data_source.dart';

/// Concrete implementation of [ChatRemoteDataSource] using Supabase.
///
/// Communicates directly with Supabase Realtime streams and database tables.
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _supabaseClient;

  const ChatRemoteDataSourceImpl(this._supabaseClient);

  /// Helper getter to fetch the authenticated user's unique identity key.
  String get _currentUserId => _supabaseClient.auth.currentUser!.id;

  @override
  Stream<List<ChatModel>> watchAllChats() {
    return _supabaseClient
        .from('chats')
        .stream(primaryKey: ['id'])
        .order('last_message_time', ascending: false)
        .asyncMap((rawRows) async {
          final List<ChatModel> activeChats = [];

          for (final row in rawRows) {
            final userOne = row['user_one'] as String;
            final userTwo = row['user_two'] as String;

            // Free tier connection optimization: Bypass sorting logic processing
            // if the authenticated session identity is not part of this chat entity.
            if (userOne != _currentUserId && userTwo != _currentUserId) {
              continue;
            }

            final String otherUserId = userOne == _currentUserId
                ? userTwo
                : userOne;

            try {
              // 1. Fetch the raw profile information of the secondary participant
              final profileRow = await _supabaseClient
                  .from('profiles')
                  .select()
                  .eq('id', otherUserId)
                  .single();

              final otherUser = AppUserModel.fromJson(profileRow);

              // 2. Fetch the current unread count matrix for this target user channel
              final unreadResponse = await _supabaseClient
                  .from('messages')
                  .select('id')
                  .eq('conversation_id', row['id'])
                  .eq('is_read', false)
                  .eq('sender_id', otherUserId);

              final unreadCount = unreadResponse.length;

              // 3. Construct the clean ChatModel container
              activeChats.add(
                ChatModel.fromJson(
                  row,
                  currentUserId: _currentUserId,
                  otherUserEntity: otherUser,
                  unreadCount: unreadCount,
                ),
              );
            } catch (_) {
              // Gracefully skip corrupted, missing profiles, or deleted user references
              continue;
            }
          }
          return activeChats;
        });
  }

  @override
  Future<ChatModel> getOrCreateChat(String targetUserId) async {
    try {
      // Enforce the alphanumeric database order rule to match constraint rules
      final List<String> sortedIds = [_currentUserId, targetUserId]..sort();
      final userOne = sortedIds.first;
      final userTwo = sortedIds.last;

      // Attempt to retrieve a matching existing communication row
      final existingChat = await _supabaseClient
          .from('chats')
          .select()
          .eq('user_one', userOne)
          .eq('user_two', userTwo)
          .maybeSingle();

      Map<String, dynamic> chatRow;

      if (existingChat == null) {
        // Safe creation initialization block if no row exists yet
        chatRow = await _supabaseClient
            .from('chats')
            .insert({'user_one': userOne, 'user_two': userTwo})
            .select()
            .single();
      } else {
        chatRow = existingChat;
      }

      // Populate targeted profile payload data to complete initialization
      final profileRow = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', targetUserId)
          .single();

      final otherUser = AppUserModel.fromJson(profileRow);

      return ChatModel.fromJson(
        chatRow,
        currentUserId: _currentUserId,
        otherUserEntity: otherUser,
        unreadCount: 0,
      );
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Stream<List<MessageModel>> watchMessages(String chatId) {
    return _supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', chatId)
        .order('created_at', ascending: true)
        .map(
          (rawRows) =>
              rawRows.map((row) => MessageModel.fromJson(row)).toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String receiverId,
    required String content,
  }) async {
    try {
      // Payload preparation configuration schema structure
      final messagePayload = {
        'conversation_id': chatId,
        'sender_id': _currentUserId,
        'receiver_id': receiverId,
        'content': content,
        'is_read': false,
      };

      await _supabaseClient.from('messages').insert(messagePayload);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      await _supabaseClient
          .from('messages')
          .update({'is_read': true})
          .eq('conversation_id', chatId)
          .eq('receiver_id', _currentUserId);
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
