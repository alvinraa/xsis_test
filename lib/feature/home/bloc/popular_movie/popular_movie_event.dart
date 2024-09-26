part of 'popular_movie_bloc.dart';

@immutable
sealed class PopularMovieEvent {}

class GetPopularMovieListRequest extends PopularMovieEvent {
  final bool isLoadMore;
  GetPopularMovieListRequest({
    this.isLoadMore = false,
  });
}
