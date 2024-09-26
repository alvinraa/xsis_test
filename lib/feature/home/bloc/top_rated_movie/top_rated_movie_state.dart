part of 'top_rated_movie_bloc.dart';

@immutable
sealed class TopRatedMovieState {}

final class TopRatedMovieListInitial extends TopRatedMovieState {}

class TopRatedMovieListLoading extends TopRatedMovieState {}

class TopRatedMovieListLoadMoreLoading extends TopRatedMovieState {}

class TopRatedMovieListLoaded extends TopRatedMovieState {
  TopRatedMovieListLoaded();
}

class TopRatedMovieListError extends TopRatedMovieState {
  final String? errorMessage;
  TopRatedMovieListError({this.errorMessage});
}
