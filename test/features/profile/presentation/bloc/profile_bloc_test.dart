import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/app_user/domain/entities/app_user.dart';
import 'package:yemengram/core/app_user/presentation/cubit/current_user_cubit.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/features/profile/domain/entities/user_profile.dart';
import 'package:yemengram/features/profile/domain/usecases/fetch_user_posts.dart';
import 'package:yemengram/features/profile/domain/usecases/fetch_user_profile.dart';
import 'package:yemengram/features/profile/domain/usecases/follow_user.dart';
import 'package:yemengram/features/profile/domain/usecases/unfollow_user.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_event.dart';
import 'package:yemengram/features/profile/presentation/bloc/profile_state.dart';

// explicit mock definitions utilizing mocktail signatures
class MockFetchUserProfile extends Mock implements FetchUserProfile {}

class MockFetchUserPosts extends Mock implements FetchUserPosts {}

class MockCurrentUserCubit extends Mock implements CurrentUserCubit {}

class MockFollowUser extends Mock implements FollowUser {}

class MockUnfollowUser extends Mock implements UnfollowUser {}

class MockUserProfile extends Mock implements UserProfile {}

class MockPost extends Mock implements Post {}

class MockCurrentUserLoggedIn extends Mock implements CurrentUserLoggedIn {
  @override
  AppUser get user => const AppUser(
    id: 'logged_in_uid',
    email: 'user@yemengram.com',
    username: 'active_session_owner',
    avatarUrl: null,
  );
}

void main() {
  late ProfileBloc profileBloc;
  late MockFetchUserProfile mockFetchUserProfile;
  late MockFetchUserPosts mockFetchUserPosts;
  late MockCurrentUserCubit mockCurrentUserCubit;
  late MockFollowUser mockFollowUser;
  late MockUnfollowUser mockUnfollowUser;

  late MockUserProfile mockProfileEntity;
  late List<Post> tPostsList;

  setUp(() {
    mockFetchUserProfile = MockFetchUserProfile();
    mockFetchUserPosts = MockFetchUserPosts();
    mockCurrentUserCubit = MockCurrentUserCubit();
    mockFollowUser = MockFollowUser();
    mockUnfollowUser = MockUnfollowUser();

    mockProfileEntity = MockUserProfile();
    tPostsList = [MockPost()];

    when(() => mockProfileEntity.id).thenReturn('target_uid');
    when(() => mockProfileEntity.followersCount).thenReturn(10);
    when(() => mockProfileEntity.isFollowing).thenReturn(false);

    profileBloc = ProfileBloc(
      fetchUserProfile: mockFetchUserProfile,
      fetchUserPosts: mockFetchUserPosts,
      currentUserCubit: mockCurrentUserCubit,
      followUser: mockFollowUser,
      unfollowUser: mockUnfollowUser,
    );
  });

  tearDown(() {
    profileBloc.close();
  });

  test('initial state should be ProfileInitial', () {
    expect(profileBloc.state, isA<ProfileInitial>());
  });

  blocTest<ProfileBloc, ProfileState>(
    'emits [ProfileLoadSuccess] skipping ProfileLoading during silent refreshing transactions',
    build: () {
      when(
        () => mockCurrentUserCubit.state,
      ).thenReturn(MockCurrentUserLoggedIn());
      when(
        () => mockFetchUserProfile(any(that: isA<String>())),
      ).thenAnswer((_) async => Right(mockProfileEntity));
      when(
        () => mockFetchUserPosts(any(that: isA<String>())),
      ).thenAnswer((_) async => Right(tPostsList));
      return profileBloc;
    },
    act: (bloc) =>
        bloc.add(const ProfileRefreshRequested(userId: 'target_uid')),
    expect: () => [isA<ProfileLoadSuccess>()],
  );

  group('Follow / Unfollow Status Modifications Interaction Triggers', () {
    final mutatedProfile = MockUserProfile();

    setUp(() {
      when(
        () => mockProfileEntity.copyWith(
          isFollowing: any(named: 'isFollowing'),
          followersCount: any(named: 'followersCount'),
        ),
      ).thenReturn(mutatedProfile);
    });

    blocTest<ProfileBloc, ProfileState>(
      'performs optimistic mutation update and executes downstream follow transaction on repository blocks',
      build: () {
        when(
          () => mockFollowUser(any(that: isA<String>())),
        ).thenAnswer((_) async => const Right(unit));
        return profileBloc;
      },
      seed: () => ProfileLoadSuccess(
        profile: mockProfileEntity,
        isMe: false,
        posts: const [],
      ),
      act: (bloc) => bloc.add(
        const ProfileFollowToggleRequested(targetUserId: 'target_uid'),
      ),
      expect: () => [
        isA<ProfileLoadSuccess>().having(
          (s) => s.profile,
          'optimistic profile set replacement',
          mutatedProfile,
        ),
      ],
      verify: (_) {
        verify(() => mockFollowUser('target_uid')).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'performs structural automatic state rollback execution targeting context frames when data requests return errors',
      build: () {
        when(() => mockFollowUser(any(that: isA<String>()))).thenAnswer(
          (_) async => const Left(ServerFailure('Network disconnected')),
        );
        return profileBloc;
      },
      seed: () => ProfileLoadSuccess(
        profile: mockProfileEntity,
        isMe: false,
        posts: const [],
      ),
      act: (bloc) => bloc.add(
        const ProfileFollowToggleRequested(targetUserId: 'target_uid'),
      ),
      expect: () => [
        isA<ProfileLoadSuccess>().having(
          (s) => s.profile,
          'optimistic modification applied',
          mutatedProfile,
        ),
        isA<ProfileLoadSuccess>().having(
          (s) => s.profile,
          'rollback execution restored baseline snapshot parameters',
          mockProfileEntity,
        ),
      ],
    );
  });
}
