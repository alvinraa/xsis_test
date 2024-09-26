import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
import 'package:xsis_test/feature/home/data/repository/home_repository.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieListBloc
    extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  TopRatedMovieListBloc() : super(TopRatedMovieListLoading()) {
    on<GetTopRatedMovieListRequest>((event, emit) async {
      await getTopRatedMovieList(event, emit);
    });
  }

  HomeRepository repository = HomeRepository();
  MovieDbResponse response = MovieDbResponse();
  List<MovieModel> listMovie = [];

  Future getTopRatedMovieList(
    GetTopRatedMovieListRequest event,
    Emitter<TopRatedMovieState> emit,
  ) async {
    try {
      emit(TopRatedMovieListLoading());

      MovieDbResponse data = await repository.getTopRatedMovie();
      response = data;
      var list = data.results ?? [];
      listMovie = list;

      emit(TopRatedMovieListLoaded());
    } catch (e) {
      Logger.print('err in bloc: ${e.toString()}');
      emit(TopRatedMovieListError(errorMessage: e.toString()));
    }
  }
}
