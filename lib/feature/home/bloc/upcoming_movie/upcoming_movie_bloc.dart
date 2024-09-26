import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
import 'package:xsis_test/feature/home/data/repository/home_repository.dart';

part 'upcoming_movie_event.dart';
part 'upcoming_movie_state.dart';

class UpcomingMovieListBloc
    extends Bloc<UpcomingMovieEvent, UpcomingMovieState> {
  UpcomingMovieListBloc() : super(UpcomingMovieListLoading()) {
    on<GetUpcomingMovieListRequest>((event, emit) async {
      await getUpcomingMovieList(event, emit);
    });
  }

  HomeRepository repository = HomeRepository();
  MovieDbResponse response = MovieDbResponse();
  List<MovieModel> listMovie = [];

  Future getUpcomingMovieList(
    GetUpcomingMovieListRequest event,
    Emitter<UpcomingMovieState> emit,
  ) async {
    try {
      emit(UpcomingMovieListLoading());

      MovieDbResponse data = await repository.getUpcomingMovie();
      response = data;
      var list = data.results ?? [];
      listMovie = list;

      emit(UpcomingMovieListLoaded());
    } catch (e) {
      Logger.print('err in bloc: ${e.toString()}');
      emit(UpcomingMovieListError(errorMessage: e.toString()));
    }
  }
}
