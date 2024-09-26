import 'package:dio/dio.dart';
import 'package:xsis_test/core/client/client.dart';
import 'package:xsis_test/core/common/endpoint.dart';
import 'package:xsis_test/core/common/logger.dart';
import 'package:xsis_test/feature/home/data/model/moviedb_response_model.dart';

class HomeRepository {
  Dio dio = Client().dio;
  late Response response;

  // get now playing
  Future<MovieDbResponse> getNowPlayingMovie() async {
    Logger.print('--- HomeRepository @getNowPlayingMovie : ---');
    try {
      var endPoint = Endpoint.nowPlaying;
      response = await dio.get(endPoint);

      var responseData = response.data;
      MovieDbResponse result = MovieDbResponse.fromJson(responseData);

      return result;
    } on DioException catch (e) {
      throw e.message ?? '-';
    }
  }

  // get popular
  Future<MovieDbResponse> getPopularMovie() async {
    Logger.print('--- HomeRepository @getPopularMovie : ---');
    try {
      var endPoint = Endpoint.popular;
      response = await dio.get(endPoint);

      var responseData = response.data;
      MovieDbResponse result = MovieDbResponse.fromJson(responseData);

      return result;
    } on DioException catch (e) {
      throw e.message ?? '-';
    }
  }

  // get top rated
  Future<MovieDbResponse> getTopRatedMovie() async {
    Logger.print('--- HomeRepository @getTopRatedMovie : ---');
    try {
      var endPoint = Endpoint.topRated;
      response = await dio.get(endPoint);

      var responseData = response.data;
      MovieDbResponse result = MovieDbResponse.fromJson(responseData);

      return result;
    } on DioException catch (e) {
      throw e.message ?? '-';
    }
  }

  // get upcoming
  Future<MovieDbResponse> getUpcomingMovie() async {
    Logger.print('--- HomeRepository @getUpcomingMovie : ---');
    try {
      var endPoint = Endpoint.upcoming;
      response = await dio.get(endPoint);

      var responseData = response.data;
      MovieDbResponse result = MovieDbResponse.fromJson(responseData);

      return result;
    } on DioException catch (e) {
      throw e.message ?? '-';
    }
  }
}
