import 'package:cocktails_app/data/models/drinks_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90
  ));
  return dio;
});

final apiProvider = Provider((ref) => CocktailsApi(ref.read));

const apiUrl = 'http://www.thecocktaildb.com/api/json/v1/1/';

class CocktailsApi {
  CocktailsApi(this._read);

  final Reader _read;

  Future<DrinksResponse> fetchCocktailsByLetter(
    String letter, {
    CancelToken? cancelToken,
  }) async {
    final response = await _get('search.php',
        cancelToken: cancelToken, queryParameters: {'f': 'a'}
    );

    return DrinksResponse.fromJson(response.data!);
  }

  Future<Response<Map<String, dynamic>>> _get(
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
