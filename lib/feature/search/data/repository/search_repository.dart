import 'package:dio/dio.dart';
import 'package:xsis_test/core/client/client.dart';
import 'package:xsis_test/core/common/endpoint.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';

class SearchRepository {
  Dio dio = Client().dio;
  late Response response;

  // get now playing
  Future<MovieDbResponse> searchMovie({required String keyword}) async {
    Logger.print('--- SearchRepository @searchMovie : ---');
    try {
      var endPoint = Endpoint.searchMovie;
      var param = {"query": keyword};

      response = await dio.get(
        endPoint,
        queryParameters: param,
      );

      var responseData = response.data;
      MovieDbResponse result = MovieDbResponse.fromJson(responseData);

      return result;
    } on DioException catch (e) {
      throw e.message ?? '-';
    }
  }
}
