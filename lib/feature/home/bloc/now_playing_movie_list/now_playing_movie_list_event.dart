part of 'now_playing_movie_list_bloc.dart';

@immutable
sealed class NowPlayingMovieListEvent {}

class GetNowPlayingMovieListRequest extends NowPlayingMovieListEvent {
  final bool isLoadMore;
  GetNowPlayingMovieListRequest({
    this.isLoadMore = false,
  });
}
