import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/posts/domain/entities/post.dart';
import '../../domain/usecases/get_all_posts.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetAllPosts _getAllPosts;

  ExploreBloc({required GetAllPosts getAllPosts})
      : _getAllPosts = getAllPosts,
        super(const ExploreInitial()) {
    on<ExploreFetchRequested>(_onFetchRequested);
    on<ExploreRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onFetchRequested(
      ExploreFetchRequested event,
      Emitter<ExploreState> emit,
      ) async {
    // If we already have posts, keep showing them during a background loading state
    emit(ExploreLoading(posts: state.posts));

    final result = await _getAllPosts(const NoParams());

    result.fold(
          (failure) => emit(ExploreFailure(errorMessage: failure.message, posts: state.posts)),
          (posts) => emit(ExploreSuccess(posts: posts)),
    );
  }

  Future<void> _onRefreshRequested(
      ExploreRefreshRequested event,
      Emitter<ExploreState> emit,
      ) async {
    emit(ExploreLoading(posts: state.posts));

    final result = await _getAllPosts(const NoParams());

    result.fold(
          (failure) => emit(ExploreFailure(errorMessage: failure.message, posts: state.posts)),
          (posts) => emit(ExploreSuccess(posts: posts)),
    );
  }
}
