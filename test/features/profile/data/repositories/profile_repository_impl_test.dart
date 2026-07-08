import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/data/models/post_model.dart';
import 'package:yemengram/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:yemengram/features/profile/data/models/user_profile_model.dart';
import 'package:yemengram/features/profile/data/repositories/profile_repository_impl.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockRemoteDataSource);
  });

  const tUserId = 'user-id-123';
  const tUsername = 'johndoe';

  final tUserProfileModel = const UserProfileModel(
    id: tUserId,
    username: tUsername,
    fullName: 'John Doe',
    postsCount: 5,
    followersCount: 10,
    followingCount: 15,
    isFollowing: false,
  );

  group('getUserProfile', () {
    test(
      'should return Right(UserProfile) when data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getUserProfile(any(that: isA<String>())),
        ).thenAnswer((_) async => tUserProfileModel);

        final result = await repository.getUserProfile(tUserId);

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Should not emit a failure'),
          (profile) => expect(profile, tUserProfileModel),
        );
        verify(() => mockRemoteDataSource.getUserProfile(tUserId)).called(1);
      },
    );

    test(
      'should return Left(ServerFailure) when data source throws a ServerException',
      () async {
        when(
          () => mockRemoteDataSource.getUserProfile(any(that: isA<String>())),
        ).thenThrow(const ServerException('Remote service failure'));

        final result = await repository.getUserProfile(tUserId);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Remote service failure');
        }, (success) => fail('Should not emit a success payload'));
      },
    );

    test(
      'should return Left(ServerFailure) when data source throws an unhandled error',
      () async {
        when(
          () => mockRemoteDataSource.getUserProfile(any(that: isA<String>())),
        ).thenThrow(Exception('Unexpected error'));

        final result = await repository.getUserProfile(tUserId);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(
            (failure as ServerFailure).message,
            'Exception: Unexpected error',
          );
        }, (success) => fail('Should not emit a success payload'));
      },
    );
  });

  group('getUserPosts', () {
    final tPostModels = <PostModel>[];

    test(
      'should return Right(List<Post>) when data source retrieval succeeds',
      () async {
        when(
          () => mockRemoteDataSource.getUserPosts(any(that: isA<String>())),
        ).thenAnswer((_) async => tPostModels);

        final result = await repository.getUserPosts(tUserId);

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Should not fail'),
          (posts) => expect(posts, tPostModels),
        );
      },
    );

    test(
      'should return Left(ServerFailure) when data source post extraction fails',
      () async {
        when(
          () => mockRemoteDataSource.getUserPosts(any(that: isA<String>())),
        ).thenThrow(const ServerException('Failed to fetch posts'));

        final result = await repository.getUserPosts(tUserId);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Failed to fetch posts');
        }, (success) => fail('Should not pass'));
      },
    );
  });

  group('followUser', () {
    test(
      'should return Right(unit) when operation completes successfully',
      () async {
        when(
          () => mockRemoteDataSource.followUser(any(that: isA<String>())),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.followUser(tUserId);

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Should not fail'),
          (success) => expect(success, unit),
        );
      },
    );

    test(
      'should return Left(ServerFailure) on follow failure exceptions',
      () async {
        when(
          () => mockRemoteDataSource.followUser(any(that: isA<String>())),
        ).thenThrow(const ServerException('Unable to follow'));

        final result = await repository.followUser(tUserId);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Unable to follow');
        }, (success) => fail('Should not pass'));
      },
    );
  });

  group('unfollowUser', () {
    test(
      'should return Right(unit) when unfollow action completes successfully',
      () async {
        when(
          () => mockRemoteDataSource.unfollowUser(any(that: isA<String>())),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.unfollowUser(tUserId);

        expect(result.isRight(), isTrue);
      },
    );

    test(
      'should return Left(ServerFailure) on unfollow failure exceptions',
      () async {
        when(
          () => mockRemoteDataSource.unfollowUser(any(that: isA<String>())),
        ).thenThrow(const ServerException('Unable to unfollow'));

        final result = await repository.unfollowUser(tUserId);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Unable to unfollow');
        }, (success) => fail('Should not pass'));
      },
    );
  });

  group('editProfile', () {
    test(
      'should forward request to data source and return Right(unit)',
      () async {
        when(
          () => mockRemoteDataSource.editProfile(
            username: any(named: 'username'),
            fullName: any(named: 'fullName'),
            bio: any(named: 'bio'),
            imageFile: any(named: 'imageFile'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.editProfile(
          username: 'newname',
          bio: 'newbio',
        );

        expect(result.isRight(), isTrue);
        verify(
          () => mockRemoteDataSource.editProfile(
            username: 'newname',
            bio: 'newbio',
          ),
        ).called(1);
      },
    );

    test(
      'should return Left(ServerFailure) when profile modification fails',
      () async {
        when(
          () => mockRemoteDataSource.editProfile(
            username: any(named: 'username'),
            fullName: any(named: 'fullName'),
            bio: any(named: 'bio'),
            imageFile: any(named: 'imageFile'),
          ),
        ).thenThrow(const ServerException('Failed updating profile'));

        final result = await repository.editProfile(username: 'newname');

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, 'Failed updating profile');
        }, (success) => fail('Should not pass'));
      },
    );
  });

  group('checkUsernameAvailability', () {
    test(
      'should return Right(true) when username is free to register',
      () async {
        when(
          () => mockRemoteDataSource.checkUsernameAvailability(
            any(that: isA<String>()),
          ),
        ).thenAnswer((_) async => true);

        final result = await repository.checkUsernameAvailability(tUsername);

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Should not fail'),
          (available) => expect(available, isTrue),
        );
      },
    );

    test(
      'should return Left(ServerFailure) when verification encounters database errors',
      () async {
        when(
          () => mockRemoteDataSource.checkUsernameAvailability(
            any(that: isA<String>()),
          ),
        ).thenThrow(const ServerException('Availability query failed'));

        final result = await repository.checkUsernameAvailability(tUsername);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(
            (failure as ServerFailure).message,
            'Availability query failed',
          );
        }, (success) => fail('Should not pass'));
      },
    );
  });
}
