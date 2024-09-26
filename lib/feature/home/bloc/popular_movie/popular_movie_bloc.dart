import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
import 'package:xsis_test/feature/home/data/repository/home_repository.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieListBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  PopularMovieListBloc() : super(PopularMovieListLoading()) {
    on<GetPopularMovieListRequest>((event, emit) async {
      await getPopularMovieList(event, emit);
    });
  }

  HomeRepository repository = HomeRepository();
  MovieDbResponse response = MovieDbResponse();
  List<MovieModel> listMovie = [];

  Future getPopularMovieList(
    GetPopularMovieListRequest event,
    Emitter<PopularMovieState> emit,
  ) async {
    try {
      emit(PopularMovieListLoading());

      MovieDbResponse data = await repository.getPopularMovie();
      response = data;
      var list = data.results ?? [];
      listMovie = list;

      emit(PopularMovieListLoaded());
    } catch (e) {
      Logger.print('err in bloc: ${e.toString()}');
      emit(PopularMovieListError(errorMessage: e.toString()));
    }
  }
}
