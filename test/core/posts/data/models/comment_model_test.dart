import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/posts/data/models/comment_model.dart';
import 'package:yemengram/core/posts/domain/entities/comment.dart';

void main() {
  group('CommentModel Tests', () {
    group('fromJson parsing mapping configurations', () {
      test('should parse correctly with a valid standard payload mapping', () {
        final Map<String, dynamic> sampleJson = {
          'id': 'comment_123',
          'post_id': 'post_999',
          'user_id': 'user_456',
          'username': 'yemen_dev',
          'avatar_url': 'https://example.com',
          'message': 'This is an amazing post!',
          'created_at': '2026-06-30T12:00:00Z',
        };

        final result = CommentModel.fromJson(sampleJson);

        expect(result, isA<Comment>());
        expect(result.id, 'comment_123');
        expect(result.text, 'This is an amazing post!');
        expect(result.avatarUrl, 'https://example.com');
      });

      test(
        'should fall back to an empty string safely if avatar_url is missing or null',
        () {
          final Map<String, dynamic> sampleJson = {
            'id': 'comment_124',
            'post_id': 'post_999',
            'user_id': 'user_456',
            'username': 'yemen_dev',
            'avatar_url': null, // Simulating null database fallback slot
            'message': 'No profile picture here.',
            'created_at': '2026-06-30T12:05:00Z',
          };

          final result = CommentModel.fromJson(sampleJson);

          expect(
            result.avatarUrl,
            isEmpty,
          ); // Verifies fallback mapping rule safety
        },
      );
    });

    group('toJson formatting operations', () {
      test(
        'should structure a payload map exactly matched with relational database schema requirements',
        () {
          const commentModel = CommentModel(
            id: 'comment_777',
            postId: 'post_999',
            userId: 'user_456',
            username: 'yemen_dev',
            avatarUrl: 'https://example.com',
            text: 'Uploading a comment',
            createdAt: '2026-06-30T12:10:00Z',
          );

          final result = commentModel.toJson();

          expect(result['id'], 'comment_777');
          expect(result['post_id'], 'post_999');
          expect(result['user_id'], 'user_456');
          expect(
            result['message'],
            'Uploading a comment',
          ); // Verifies structural field renaming from entity text to DB message
          expect(result['avatar_url'], 'https://example.com');
        },
      );
    });
  });
}
