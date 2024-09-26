import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
import 'package:xsis_test/feature/home/data/repository/home_repository.dart';

part 'now_playing_movie_list_event.dart';
part 'now_playing_movie_list_state.dart';

class NowPlayingMovieListBloc
    extends Bloc<NowPlayingMovieListEvent, NowPlayingMovieListState> {
  NowPlayingMovieListBloc() : super(NowPlayingMovieListLoading()) {
    on<GetNowPlayingMovieListRequest>((event, emit) async {
      await getNowPlayingMovieList(event, emit);
    });
  }

  HomeRepository repository = HomeRepository();
  MovieDbResponse response = MovieDbResponse();
  List<MovieModel> listMovie = [];

  Future getNowPlayingMovieList(
    GetNowPlayingMovieListRequest event,
    Emitter<NowPlayingMovieListState> emit,
  ) async {
    try {
      emit(NowPlayingMovieListLoading());

      MovieDbResponse data = await repository.getNowPlayingMovie();
      response = data;
      var list = data.results ?? [];
      listMovie = list;

      emit(NowPlayingMovieListLoaded());
    } catch (e) {
      Logger.print('err in bloc: ${e.toString()}');
      emit(NowPlayingMovieListError(errorMessage: e.toString()));
    }
  }
}
