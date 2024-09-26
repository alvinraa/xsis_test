part of 'now_playing_movie_list_bloc.dart';

@immutable
sealed class NowPlayingMovieListState {}

final class NowPlayingMovieListInitial extends NowPlayingMovieListState {}

class NowPlayingMovieListLoading extends NowPlayingMovieListState {}

class NowPlayingMovieListLoadMoreLoading extends NowPlayingMovieListState {}

class NowPlayingMovieListLoaded extends NowPlayingMovieListState {
  NowPlayingMovieListLoaded();
}

class NowPlayingMovieListError extends NowPlayingMovieListState {
  final String? errorMessage;
  NowPlayingMovieListError({this.errorMessage});
}
