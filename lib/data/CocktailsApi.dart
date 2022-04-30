import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  return dio;
});

final apiProvider = Provider((ref) => CocktailsApi(ref.read));

const apiUrl = 'http://www.thecocktaildb.com/api/json/v1/1/';

class CocktailsApi {
  CocktailsApi(this._read);

  final Reader _read;

  Future<Response<Map<String, Object?>>> fetchCocktailsByLetter(
    String letter, {
    CancelToken? cancelToken,
  }) async {
    final response = await _get('search.php',
        cancelToken: cancelToken, queryParameters: {'f': 'a'});
    return response;
  }

  Future<Response<Map<String, Object?>>> _get(
    String path, {
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final response = await _read(dioProvider).get<Map<String, Object?>>(apiUrl + path,
        cancelToken: cancelToken,
        queryParameters: <String, Object?>{...?queryParameters});
    return response;
  }
}
