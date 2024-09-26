import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';
import 'package:xsis_test/feature/search/data/repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchLoading()) {
    on<GetSearchRequest>((event, emit) async {
      await getSearch(event, emit);
    });
  }

  SearchRepository repository = SearchRepository();
  MovieDbResponse response = MovieDbResponse();
  List<MovieModel> listMovie = [];

  Future getSearch(
    GetSearchRequest event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchLoading());

      MovieDbResponse data = await repository.searchMovie(
        keyword: event.keyword,
      );
      response = data;
      var list = data.results ?? [];
      listMovie = list;

      emit(SearchSuccess());
    } catch (e) {
      Logger.print('err in bloc: ${e.toString()}');
      emit(SearchError(errorMessage: e.toString()));
    }
  }
}
