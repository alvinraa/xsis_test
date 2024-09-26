part of 'top_rated_movie_bloc.dart';

@immutable
sealed class TopRatedMovieEvent {}

class GetTopRatedMovieListRequest extends TopRatedMovieEvent {
  final bool isLoadMore;
  GetTopRatedMovieListRequest({
    this.isLoadMore = false,
  });
}
