import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/posts/domain/entities/comment.dart';
import 'package:yemengram/core/posts/domain/usecases/add_comment.dart';
import 'package:yemengram/core/posts/domain/usecases/get_post_by_id.dart';
import 'package:yemengram/core/posts/domain/usecases/get_post_comments.dart';
import 'package:yemengram/core/posts/domain/usecases/toggle_lilke_post.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_bloc.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_event.dart';
import 'package:yemengram/core/posts/presentation/bloc/post_details_state.dart';

class MockGetPostById extends Mock implements GetPostById {}

class MockToggleLikePost extends Mock implements ToggleLikePost {}

class MockGetPostComments extends Mock implements GetPostComments {}

class MockAddComment extends Mock implements AddComment {}

void main() {
  late PostDetailBloc bloc;
  late MockGetPostById mockGetPostById;
  late MockToggleLikePost mockToggleLikePost;
  late MockGetPostComments mockGetPostComments;
  late MockAddComment mockAddComment;

  const tPostId = 'post_123';

  final tPost = Post(
    id: tPostId,
    author: const AppUser(id: '1', email: 'e', username: 'u'),
    mediaUrl: 'https://example.com',
    likesCount: 5,
    commentsCount: 2,
    createdAt: DateTime.now(),
    isLiked: false,
  );

  final tComments = [
    const Comment(
      id: '1',
      postId: tPostId,
      userId: '1',
      username: 'u',
      avatarUrl: '',
      text: 'Cool',
      createdAt: '',
    ),
  ];

  setUp(() {
    mockGetPostById = MockGetPostById();
    mockToggleLikePost = MockToggleLikePost();
    mockGetPostComments = MockGetPostComments();
    mockAddComment = MockAddComment();

    bloc = PostDetailBloc(
      getPostById: mockGetPostById,
      toggleLikePost: mockToggleLikePost,
      getPostComments: mockGetPostComments,
      addComment: mockAddComment,
    );
  });

  // Always close the bloc stream controller to prevent resource memory leaks
  tearDown(() {
    bloc.close();
  });

  // Base fallback registration needed for mocktail parameter matching evaluations
  setUpAll(() {
    registerFallbackValue(const AddCommentParams(postId: '', text: ''));
  });

  group('PostDetailBloc State Machine Tests', () {
    test('initial state should be exactly PostDetailInitial', () {
      expect(bloc.state, const PostDetailInitial());
    });

    blocTest<PostDetailBloc, PostDetailState>(
      'should emit [PostDetailLoading, PostDetailSuccess] when full content fetch succeeds',
      build: () {
        when(
          () => mockGetPostById(tPostId),
        ).thenAnswer((_) async => Right(tPost));
        return bloc;
      },
      act: (b) => b.add(const PostDetailFetchRequested(postId: tPostId)),
      expect: () => [isA<PostDetailLoading>(), isA<PostDetailSuccess>()],
      verify: (_) {
        verify(() => mockGetPostById(tPostId)).called(1);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'should emit [PostDetailLoading, PostDetailFailure] when remote usecase execution fails',
      build: () {
        when(
          () => mockGetPostById(tPostId),
        ).thenAnswer((_) async => const Left(ServerFailure('Fetch failure')));
        return bloc;
      },
      act: (b) => b.add(const PostDetailFetchRequested(postId: tPostId)),
      expect: () => [isA<PostDetailLoading>(), isA<PostDetailFailure>()],
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'should emit comments payload list updating active records on successful evaluation tracks',
      build: () {
        when(
          () => mockGetPostComments(tPostId),
        ).thenAnswer((_) async => Right(tComments));
        return bloc;
      },
      // Instantiating seed states directly into memory so we can bypass initial fetches
      seed: () => PostDetailSuccess(tPost, comments: const []),
      act: (b) =>
          b.add(const PostDetailCommentsFetchRequested(postId: tPostId)),
      expect: () => [isA<PostDetailLoading>(), isA<PostDetailSuccess>()],
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'should optimistically update and step increment local commentsCount upon submission successes',
      build: () {
        // Stub the initial comment posting use case action
        when(
          () => mockAddComment(any()),
        ).thenAnswer((_) async => const Right(unit));
        // Stub for the automatic background re-fetch event chain triggered on success
        when(
          () => mockGetPostComments(tPostId),
        ).thenAnswer((_) async => Right(tComments));
        return bloc;
      },
      seed: () => PostDetailSuccess(tPost, comments: tComments),
      act: (b) => b.add(
        const PostDetailCommentSubmitted(postId: tPostId, text: 'New Comment'),
      ),
      verify: (b) {
        // Asserting that the final emitted state containing the post record reflects commentsCount = 3 (2 original + 1)
        expect(b.state, isA<PostDetailSuccess>());
        final successState = b.state as PostDetailSuccess;
        final Post finalPost = successState.post as Post;
        expect(finalPost.commentsCount, 3);
      },
    );
  });
}
