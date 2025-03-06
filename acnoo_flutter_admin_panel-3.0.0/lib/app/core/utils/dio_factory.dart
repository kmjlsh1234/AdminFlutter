import 'dart:developer';
import 'dart:html';

import 'package:dio/dio.dart';

class DioFactory{

  static List<String> excludeURL = [
    '/admin/login',
    '/admin/v1/join',
  ];

  static Dio createDio(){
    final Dio dio = Dio();
    dio.interceptors.add(
        InterceptorsWrapper(
            onRequest: (options, handler) {
              final requestPath = options.path;
              if (!excludeURL.contains(requestPath)) {
                final jwtToken = window.localStorage['jwt'];
                if (jwtToken != null) {
                  options.headers['Authorization'] = jwtToken;
                } else {
                  options.headers['Authorization'] = '';
                }
              }
              options.headers['Content-Type'] = 'application/json';
              return handler.next(options); // 요청 계속 진행
            },
            onError: (DioException e, handler) {
              log(e.message.toString());
              return handler.next(e); // 에러 계속 진행
            }
        )
    );
    return dio;
  }
}