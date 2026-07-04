import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/create_post/domain/repositories/create_post_repository.dart';
import 'package:yemengram/features/create_post/domain/usecases/create_post_usecase.dart';

// Mock engine setup via mocktail framework definitions
class MockCreatePostRepository extends Mock implements CreatePostRepository {}

class MockFile extends Mock implements File {}

/// Fake implementation of [File] required for mocktail parameter fallback tracking.
class FakeFile extends Fake implements File {}

void main() {
  late CreatePost usecase;
  late MockCreatePostRepository mockRepository;
  late MockFile mockFile;

  const tCaption = 'UseCase Validation Caption';
  const tAuthorId = 'user_account_uuid_string';
  late CreatePostParams tParams;

  setUpAll(() {
    // Registering fallback matching constraints prevents sound null-safety exceptions
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockRepository = MockCreatePostRepository();
    mockFile = MockFile();
    usecase = CreatePost(mockRepository);
    tParams = CreatePostParams(
      caption: tCaption,
      mediaFile: mockFile,
      authorId: tAuthorId,
    );
  });

  group('CreatePost UseCase Orchestration Suite', () {
    test(
      'should successfully delegate parameters and forward Right(unit) from repository layer',
      () async {
        // arrange
        when(
          () => mockRepository.createPost(
            caption: any(named: 'caption', that: isA<String>()),
            mediaFile: any(named: 'mediaFile', that: isA<File>()),
            authorId: any(named: 'authorId', that: isA<String>()),
          ),
        ).thenAnswer((_) async => const Right(unit));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Right(unit));
        verify(
          () => mockRepository.createPost(
            caption: tCaption,
            mediaFile: mockFile,
            authorId: tAuthorId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should cleanly pass through Left(Failure) wrapper structure when repository interaction reports an execution fault',
      () async {
        // arrange
        const failureMessage = 'Domain pipeline validation failure';
        when(
          () => mockRepository.createPost(
            caption: any(named: 'caption', that: isA<String>()),
            mediaFile: any(named: 'mediaFile', that: isA<File>()),
            authorId: any(named: 'authorId', that: isA<String>()),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure(failureMessage)));

        // act
        final result = await usecase(tParams);

        // assert
        // Folding eliminates structural instance reference errors by pulling values directly out
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message, failureMessage);
        }, (_) => fail('Expected Left side failure block return pathway'));
        verify(
          () => mockRepository.createPost(
            caption: tCaption,
            mediaFile: mockFile,
            authorId: tAuthorId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
