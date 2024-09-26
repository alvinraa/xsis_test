part of 'upcoming_movie_bloc.dart';

@immutable
sealed class UpcomingMovieEvent {}

class GetUpcomingMovieListRequest extends UpcomingMovieEvent {
  final bool isLoadMore;
  GetUpcomingMovieListRequest({
    this.isLoadMore = false,
  });
}
