import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/core/posts/domain/entities/post.dart';
import 'package:yemengram/core/usecase/usecase.dart';
import 'package:yemengram/features/explore/domain/usecases/get_all_posts.dart';
import 'package:yemengram/features/explore/presentation/bloc/explore_bloc.dart';

class MockGetAllPosts extends Mock implements GetAllPosts {}

class MockPost extends Mock implements Post {}

void main() {
  late ExploreBloc exploreBloc;
  late MockGetAllPosts mockGetAllPosts;

  setUp(() {
    mockGetAllPosts = MockGetAllPosts();
    exploreBloc = ExploreBloc(getAllPosts: mockGetAllPosts);
    registerFallbackValue(const NoParams());
  });

  tearDown(() {
    exploreBloc.close();
  });

  final tPostsList = [MockPost()];
  const tErrorMessage = 'Failed to fetch explore feed';

  test('initial state should be ExploreInitial with empty post selection', () {
    expect(exploreBloc.state, isA<ExploreInitial>());
    expect(exploreBloc.state.posts, anyOf(isNull, isEmpty));
  });

  group('ExploreFetchRequested', () {
    blocTest<ExploreBloc, ExploreState>(
      'emits [ExploreLoading, ExploreSuccess] when posts fetch completes successfully',
      build: () {
        when(
          () => mockGetAllPosts(any(that: isA<NoParams>())),
        ).thenAnswer((_) async => Right(tPostsList));
        return exploreBloc;
      },
      act: (bloc) => bloc.add(const ExploreFetchRequested()),
      expect: () => [
        isA<ExploreLoading>().having(
          (s) => s.posts,
          'posts',
          anyOf(isNull, isEmpty),
        ),
        isA<ExploreSuccess>().having(
          (s) => s.posts,
          'posts',
          equals(tPostsList),
        ),
      ],
      verify: (_) {
        verify(() => mockGetAllPosts(any(that: isA<NoParams>()))).called(1);
      },
    );

    blocTest<ExploreBloc, ExploreState>(
      'emits [ExploreLoading, ExploreFailure] when posts fetch ends in server exception failure',
      build: () {
        when(
          () => mockGetAllPosts(any(that: isA<NoParams>())),
        ).thenAnswer((_) async => const Left(ServerFailure(tErrorMessage)));
        return exploreBloc;
      },
      act: (bloc) => bloc.add(const ExploreFetchRequested()),
      // Use simple type assertions in expect to avoid nested .having() property crashes on null fields
      expect: () => [isA<ExploreLoading>(), isA<ExploreFailure>()],
      // Perform the deep value assertions safely here where we can use
      // standard Dart casting
      verify: (bloc) {
        expect(bloc.state, isA<ExploreState>());
        final finalState = bloc.state;
        expect(finalState.posts, anyOf(isNull, isEmpty));
        expect((finalState as dynamic).errorMessage, equals(tErrorMessage));
      },
    );
  });

  group('ExploreRefreshRequested', () {
    blocTest<ExploreBloc, ExploreState>(
      'emits [ExploreLoading, ExploreSuccess] and updates with new posts on user swipe refresh request',
      build: () {
        when(
          () => mockGetAllPosts(any(that: isA<NoParams>())),
        ).thenAnswer((_) async => Right(tPostsList));
        return exploreBloc;
      },
      act: (bloc) => bloc.add(const ExploreRefreshRequested()),
      expect: () => [
        isA<ExploreLoading>().having(
          (s) => s.posts,
          'posts',
          anyOf(isNull, isEmpty),
        ),
        isA<ExploreSuccess>().having(
          (s) => s.posts,
          'posts',
          equals(tPostsList),
        ),
      ],
    );
  });
}
