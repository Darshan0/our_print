import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_client.dart';

class DioClient implements ApiClient {
  Dio dio;

  DioClient() {
    dio = Dio();
    dio.options = BaseOptions(
      // baseUrl: 'https://api.ourprint.in',
      //  baseUrl: 'http://192.168.43.90:1234',
      // baseUrl: 'http://7t6.in:8383',
//        baseUrl: 'http://10.0.0.101:1234',
//      connectTimeout: 10000,
//      receiveTimeout: 10000,
      //don't remove this ternary operator
      baseUrl: kReleaseMode ? 'https://api.ourprint.in' : 'http://7t6.in:8383',
    );
    dio.interceptors.add(
      PrettyDioLogger(requestBody: true, maxWidth: 120, error: true),
    );
  }

  Future<Options> getOptions({bool isAuth = true, bool isFile = false}) async {
    Map<String, dynamic> headers = {'Accept': 'application/json'};
    var token = await Prefs.getToken();
    print(token);
    if (token != null && isAuth) {
      headers['Authorization'] = token;
    }
    return Options(
      headers: headers,
      responseType: ResponseType.json,
      sendTimeout: isFile ? 120000 : 16000,
      receiveTimeout: isFile ? 120000 : 16000,
    );
  }

  @override
  Future delete(String path, {body, query}) async {
    var response = await dio.delete(
      path,
      data: body,
      queryParameters: query,
      options: await getOptions(),
    );
    return response.data;
  }

  @override
  Future get(String path, {query, bool isAuth = true}) async {
    var response = await dio.get(
      path,
      queryParameters: query,
      options: await getOptions(isAuth: isAuth),
    );
    return response.data;
  }

  @override
  Future patch(String path, body, {query}) async {
    var response = await dio.patch(
      path,
      data: body,
      queryParameters: query,
      options: await getOptions(),
    );
    return response.data;
  }

  @override
  Future post(String path, body, {query}) async {
    var response = await dio.post(
      path,
      data: body,
      queryParameters: query,
      options: await getOptions(),
    );
    return response.data;
  }

  Future postProgress(
    String path,
    body, {
    query,
    ProgressCallback onProgress,
  }) async {
    var response = await dio.post(path,
        data: body,
        queryParameters: query,
        options: await getOptions(isFile: true),
        onSendProgress: onProgress);
    return response.data;
  }

  Future patchProgress(
    String path,
    body, {
    query,
    ProgressCallback onProgress,
  }) async {
    var response = await dio.patch(path,
        data: body,
        queryParameters: query,
        options: await getOptions(isFile: true),
        onSendProgress: onProgress);
    return response.data;
  }

  @override
  Future put(String path, body, {query}) async {
    var response = await dio.put(
      path,
      data: body,
      queryParameters: query,
      options: await getOptions(),
    );
    return response.data;
  }
}
