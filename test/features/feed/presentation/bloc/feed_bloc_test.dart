import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/app_user/presentation/cubit/current_user_cubit.dart';
import 'package:yemengram/core/posts/domain/entities/comment.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/posts/domain/usecases/add_comment.dart';
import 'package:yemengram/core/posts/domain/usecases/get_post_comments.dart';
import 'package:yemengram/core/posts/domain/usecases/toggle_lilke_post.dart';
import 'package:yemengram/features/feed/domain/usecases/get_followed_users_posts.dart';
import 'package:yemengram/features/feed/presentation/bloc/feed_bloc.dart';

// Standalone structural definitions representing the external feature interfaces
class MockGetFollowedUsersPosts extends Mock implements GetFollowedUsersPosts {}

class MockCurrentUserCubit extends Mock implements CurrentUserCubit {}

class MockToggleLikePost extends Mock implements ToggleLikePost {}

class MockGetPostComments extends Mock implements GetPostComments {}

class MockAddComment extends Mock implements AddComment {}

class MockPost extends Mock implements Post {}

class MockComment extends Mock implements Comment {}

class MockUser extends Mock implements AppUser {}

void main() {
  late FeedBloc feedBloc;
  late MockGetFollowedUsersPosts mockGetFollowedUsersPosts;
  late MockCurrentUserCubit mockCurrentUserCubit;
  late MockToggleLikePost mockToggleLikePost;
  late MockGetPostComments mockGetPostComments;
  late MockAddComment mockAddComment;

  late MockUser tUser;
  late List<MockPost> tPosts;
  late List<MockComment> tComments;

  setUpAll(() {
    registerFallbackValue(GetFollowedUsersPostsParams(userId: ''));
    registerFallbackValue(AddCommentParams(postId: '', text: ''));
  });

  setUp(() {
    mockGetFollowedUsersPosts = MockGetFollowedUsersPosts();
    mockCurrentUserCubit = MockCurrentUserCubit();
    mockToggleLikePost = MockToggleLikePost();
    mockGetPostComments = MockGetPostComments();
    mockAddComment = MockAddComment();

    tUser = MockUser();
    tPosts = [MockPost(), MockPost()];
    tComments = [MockComment()];

    // Configuration of standard data entities to support properties accessed during mutations
    for (var post in tPosts) {
      when(() => post.id).thenReturn('post-id');
      when(() => post.isLiked).thenReturn(false);
      when(() => post.likesCount).thenReturn(10);
      when(() => post.commentsCount).thenReturn(2);
      when(() => post.createdAt).thenReturn(DateTime.now());
      when(
        () => post.copyWith(
          id: any(named: 'id'),
          isLiked: any(named: 'isLiked'),
          likesCount: any(named: 'likesCount'),
          commentsCount: any(named: 'commentsCount'),
        ),
      ).thenReturn(post);
    }

    feedBloc = FeedBloc(
      getFollowedUsersPosts: mockGetFollowedUsersPosts,
      currentUserCubit: mockCurrentUserCubit,
      toggleLikePost: mockToggleLikePost,
      getPostComments: mockGetPostComments,
      addComment: mockAddComment,
    );
  });

  tearDown(() {
    feedBloc.close();
  });

  test('initial state should be initialized with default status values', () {
    expect(feedBloc.state.status, equals(FeedStatus.initial));
    expect(feedBloc.state.posts, isEmpty);
  });

  group('FeedFetchInitialPosts', () {
    blocTest<FeedBloc, FeedState>(
      'emits [loading, failure] when active user session is missing from context',
      build: () {
        when(() => mockCurrentUserCubit.state).thenReturn(CurrentUserInitial());
        return feedBloc;
      },
      act: (bloc) => bloc.add(FeedFetchInitialPosts()),
      expect: () => [
        isA<FeedState>().having(
          (s) => s.status,
          'status',
          equals(FeedStatus.loading),
        ),
        isA<FeedState>()
            .having((s) => s.status, 'status', equals(FeedStatus.failure))
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              equals('User session not found.'),
            ),
      ],
    );

    blocTest<FeedBloc, FeedState>(
      'emits [loading, success] when fetching timeline entries resolves successfully',
      build: () {
        when(() => tUser.id).thenReturn('user-id-123');
        when(
          () => mockCurrentUserCubit.state,
        ).thenReturn(CurrentUserLoggedIn(tUser));
        when(
          () => mockGetFollowedUsersPosts(
            any(that: isA<GetFollowedUsersPostsParams>()),
          ),
        ).thenAnswer((_) async => Right(tPosts));
        return feedBloc;
      },
      act: (bloc) => bloc.add(FeedFetchInitialPosts()),
      expect: () => [
        isA<FeedState>().having(
          (s) => s.status,
          'status',
          equals(FeedStatus.loading),
        ),
        isA<FeedState>()
            .having((s) => s.status, 'status', equals(FeedStatus.success))
            .having((s) => s.posts, 'posts', equals(tPosts)),
      ],
    );
  });

  group('FeedPostLikeTapped', () {
    blocTest<FeedBloc, FeedState>(
      'emits modified post collection layout when toggle action processes cleanly',
      seed: () => FeedState(status: FeedStatus.success, posts: tPosts),
      build: () {
        when(
          () => mockToggleLikePost(any(that: isA<String>())),
        ).thenAnswer((_) async => const Right(unit));
        return feedBloc;
      },
      act: (bloc) => bloc.add(const FeedPostLikeTapped(postId: 'post-id')),
      expect: () => [
        isA<FeedState>().having((s) => s.posts, 'posts', isNotEmpty),
      ],
      verify: (_) {
        verify(() => mockToggleLikePost('post-id')).called(1);
      },
    );
  });

  group('CommentsFetchRequested', () {
    blocTest<FeedBloc, FeedState>(
      'emits loading flag changes followed by comment collection payload injection maps',
      build: () {
        when(
          () => mockGetPostComments(any(that: isA<String>())),
        ).thenAnswer((_) async => Right(tComments));
        return feedBloc;
      },
      act: (bloc) => bloc.add(const CommentsFetchRequested(postId: 'post-id')),
      expect: () => [
        isA<FeedState>().having(
          (s) => s.isFetchingComments,
          'isFetchingComments',
          isTrue,
        ),
        isA<FeedState>()
            .having((s) => s.isFetchingComments, 'isFetchingComments', isFalse)
            .having(
              (s) => s.activeComments,
              'activeComments',
              equals(tComments),
            ),
      ],
    );
  });
}
