part of 'upcoming_movie_bloc.dart';

@immutable
sealed class UpcomingMovieState {}

final class UpcomingMovieListInitial extends UpcomingMovieState {}

class UpcomingMovieListLoading extends UpcomingMovieState {}

class UpcomingMovieListLoadMoreLoading extends UpcomingMovieState {}

class UpcomingMovieListLoaded extends UpcomingMovieState {
  UpcomingMovieListLoaded();
}

class UpcomingMovieListError extends UpcomingMovieState {
  final String? errorMessage;
  UpcomingMovieListError({this.errorMessage});
}
