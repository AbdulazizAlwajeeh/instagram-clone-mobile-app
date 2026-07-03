import 'package:flutter_test/flutter_test.dart';
import 'package:yemengram/core/posts/data/models/post_model.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';

void main() {
  group('PostModel Tests', () {
    // Grouping related JSON parsing behaviors
    group('fromJson parsing mapping configurations', () {
      test(
        'should parse correctly and compute isLiked true when user join array is populated',
        () {
          final Map<String, dynamic> sampleJson = {
            'id': 'post_999',
            'media_url': 'https://example.com',
            'caption': 'Beautiful scenery',
            'likes_count': 42,
            'comments_count': 12,
            'created_at': '2026-06-30T12:00:00Z',
            'profiles': {
              'id': 'author_01',
              'username': 'yemen_explorer',
              'avatar_url': 'https://example.com',
            },
            'likes': [
              {
                'count': 1,
              }, // The database join reports a matching user link row
            ],
          };

          final result = PostModel.fromJson(sampleJson);

          expect(result, isA<Post>());
          expect(result.id, 'post_999');
          expect(result.isLiked, isTrue);
          expect(result.author.username, 'yemen_explorer');
        },
      );

      test(
        'should compute isLiked false when user join array list is completely empty',
        () {
          final Map<String, dynamic> sampleJson = {
            'id': 'post_999',
            'media_url': 'https://example.com',
            'caption':
                null, // Explicitly testing a null optional field boundary
            'likes_count': 42,
            'comments_count': 12,
            'created_at': '2026-06-30T12:00:00Z',
            'profiles': {
              'id': 'author_01',
              'username': 'yemen_explorer',
              'avatar_url': null,
            },
            'likes': [], // Empty means current viewer hasn't liked it
          };

          final result = PostModel.fromJson(sampleJson);

          expect(result.isLiked, isFalse);
          expect(result.caption, isNull);
        },
      );
    });

    // Evaluating alternative performance optimized queries
    group('fromFlatJson execution', () {
      test(
        'should map plain data parameters directly with skeletal user entity wrappers',
        () {
          final Map<String, dynamic> flatJson = {
            'id': 'flat_777',
            'user_id': 'author_01',
            'caption': 'Quick update',
            'media_url': 'https://example.com',
            'likes_count': 5,
            'comments_count': 2,
            'created_at': '2026-06-30T15:30:00Z',
            'is_liked': true,
          };

          final result = PostModel.fromFlatJson(flatJson);

          expect(result.id, 'flat_777');
          expect(result.author.id, 'author_01');
          expect(
            result.author.username,
            isEmpty,
          ); // Verifies the placeholder state strategy
          expect(result.isLiked, isTrue);
        },
      );
    });

    // Evaluating output serialization
    group('toJson formatting operations', () {
      test(
        'should structure a payload map exactly matched with relational database schema requirements',
        () {
          final postModel = PostModel(
            id: 'model_111',
            author: PostModel.fromFlatJson({
              'id': 'any',
              'user_id': 'author_01',
              'media_url': '',
              'likes_count': 0,
              'comments_count': 0,
              'created_at': '2026-06-30T00:00:00Z',
            }).author,
            // Quick clean user extract
            caption: 'Hello World',
            mediaUrl: 'https://example.com',
            likesCount: 15,
            commentsCount: 3,
            createdAt: DateTime.parse('2026-06-30T12:00:00Z'),
            isLiked: false,
          );

          final result = postModel.toJson();

          expect(result['id'], 'model_111');
          expect(result['user_id'], 'author_01');
          expect(result['caption'], 'Hello World');
          expect(
            result['created_at'],
            '2026-06-30T12:00:00.000Z',
          ); // ISO 8601 formatting confirmation
          expect(
            result.containsKey('is_liked'),
            isFalse,
          ); // Ensure transient app-level states are excluded from remote writing
        },
      );
    });
  });
}
