part of 'popular_movie_bloc.dart';

@immutable
sealed class PopularMovieState {}

final class PopularMovieListInitial extends PopularMovieState {}

class PopularMovieListLoading extends PopularMovieState {}

class PopularMovieListLoadMoreLoading extends PopularMovieState {}

class PopularMovieListLoaded extends PopularMovieState {
  PopularMovieListLoaded();
}

class PopularMovieListError extends PopularMovieState {
  final String? errorMessage;
  PopularMovieListError({this.errorMessage});
}
