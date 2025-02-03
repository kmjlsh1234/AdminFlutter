import 'dart:html';

import 'package:acnoo_flutter_admin_panel/app/core/utils/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../error/error_code.dart';

class DioFactory{
  static List<String> excludeURL = [
    '/admin/login',
    '/admin/v1/join',
  ];

  static Dio createDio(BuildContext context){
    final Dio dio = Dio();
    dio.interceptors.add(
        InterceptorsWrapper(
            onRequest: (options, handler) {
              final requestPath = options.path;
              if (!excludeURL.contains(requestPath)) {
                final jwtToken = window.localStorage['jwt'];
                if (jwtToken != null) {
                  options.headers['Authorization'] = jwtToken;
                }
              }
              options.headers['Content-Type'] = 'application/json';
              return handler.next(options); // 요청 계속 진행
            },
            onError: (DioException e, handler) {
              if(e.response?.statusCode != 200 && e.response?.statusCode != 204){
                handleError(e, context);
                return;
              }
              return handler.next(e); // 에러 계속 진행
            }
        )
    );
    return dio;
  }

  static void handleError(DioException e, BuildContext context){
    if(e.response != null){
      if(e.response?.statusCode == 401) {
        GoRouter.of(context).go('/authentication/signin');
      } else{
        final Map<String, dynamic> responseData = e.response?.data;
        int code = responseData['errorCode'] ?? 0;
        ErrorCode errorCode = ErrorCode.getByCode(code);
        ErrorDialog.showError(context, errorCode);
      }
    }else{
      ErrorCode errorCode = ErrorCode.getByCode(0);
      ErrorDialog.showError(context, errorCode);
    }
  }
}