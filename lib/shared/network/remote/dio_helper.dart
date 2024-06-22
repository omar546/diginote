import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'http://3.75.171.189/',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
          },
      ),
    );
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 5;
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers= {
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }
  static Future<Response> getImage({
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers= {
    };
    return await dio.get(
      'http://3.75.171.189/getImg/?token=${token!}',
      queryParameters: query,
      options: Options(responseType: ResponseType.bytes
      )
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers={
    };
    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers={
      'lang': lang,
      'Authorization': token,
    };
    return dio.put(url, queryParameters: query, data: data);
  }
}

class DioHelper2 {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers= {
      'lang': lang,
      'Content-Type':'application/json',
      'Authorization': token,
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers={
      'lang': lang,
      'Authorization': token,
    };
    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers={
      'lang': lang,
      'Authorization': token,
    };
    return dio.put(url, queryParameters: query, data: data);
  }
}