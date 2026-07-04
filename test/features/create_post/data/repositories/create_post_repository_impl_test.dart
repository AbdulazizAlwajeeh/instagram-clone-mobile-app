import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/exceptions.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/create_post/data/datasources/create_post_remote_data_source.dart';
import 'package:yemengram/features/create_post/data/repositories/create_post_repository_impl.dart';

// Mock dependency implementations via mocktail engine framework layers
class MockCreatePostRemoteDataSource extends Mock
    implements CreatePostRemoteDataSource {}

class MockFile extends Mock implements File {}

/// Fake implementation of [File] required for mocktail argument matching fallback registration.
class FakeFile extends Fake implements File {}

void main() {
  late CreatePostRepositoryImpl repository;
  late MockCreatePostRemoteDataSource mockRemoteDataSource;
  late MockFile mockFile;

  const tCaption = 'Clean Architecture Text Caption';
  const tAuthorId = 'user_uuid_primary_key_99';

  setUpAll(() {
    // Registering fallback values is required by mocktail when using any() matchers with non-primitive types
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockRemoteDataSource = MockCreatePostRemoteDataSource();
    mockFile = MockFile();
    repository = CreatePostRepositoryImpl(mockRemoteDataSource);
  });

  group('createPost business layer repository implementation tests', () {
    test(
      'should return Right(unit) when remote network pipeline execution executes perfectly',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.createPost(
            caption: any(named: 'caption', that: isA<String>()),
            mediaFile: any(named: 'mediaFile', that: isA<File>()),
            authorId: any(named: 'authorId', that: isA<String>()),
          ),
        ).thenAnswer((_) async => Future<void>.value());

        // act
        final result = await repository.createPost(
          caption: tCaption,
          mediaFile: mockFile,
          authorId: tAuthorId,
        );

        // assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.createPost(
            caption: tCaption,
            mediaFile: mockFile,
            authorId: tAuthorId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when the infrastructure engine throws ServerException',
      () async {
        // arrange
        const exceptionMessage = 'Cloud bucket or table level RLS error';
        when(
          () => mockRemoteDataSource.createPost(
            caption: any(named: 'caption', that: isA<String>()),
            mediaFile: any(named: 'mediaFile', that: isA<File>()),
            authorId: any(named: 'authorId', that: isA<String>()),
          ),
        ).thenThrow(const ServerException(exceptionMessage));

        // act
        final result = await repository.createPost(
          caption: tCaption,
          mediaFile: mockFile,
          authorId: tAuthorId,
        );

        // assert
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, exceptionMessage);
        }, (_) => fail('Expected Left but got Right'));
      },
    );

    test(
      'should return Left(ServerFailure) when unexpected generic exceptions or platform faults crop up',
      () async {
        // arrange
        const genericErrorMessage =
            'Fatal disk reading or driver framework panic';
        when(
          () => mockRemoteDataSource.createPost(
            caption: any(named: 'caption', that: isA<String>()),
            mediaFile: any(named: 'mediaFile', that: isA<File>()),
            authorId: any(named: 'authorId', that: isA<String>()),
          ),
        ).thenThrow(genericErrorMessage);

        // act
        final result = await repository.createPost(
          caption: tCaption,
          mediaFile: mockFile,
          authorId: tAuthorId,
        );

        // assert
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, genericErrorMessage);
        }, (_) => fail('Expected Left but got Right'));
      },
    );
  });
}
