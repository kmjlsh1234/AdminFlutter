import 'dart:developer';

import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'error_dialog.dart';
import 'error_code.dart';

class ErrorHandler{

  static void handleError<E>(E e, BuildContext context){
    log(e.toString());
    if(e is DioException){
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
        ErrorDialog.showError(context, ErrorCode.UNKNOWN_ERROR);
      }
    } else if (e is CustomException){
      if(e.errorCode == ErrorCode.JWT_TOKEN_MISSING){
        GoRouter.of(context).go('/authentication/signin');
        return;
      }
      ErrorDialog.showError(context, e.errorCode);
    } else{
      ErrorDialog.showError(context, ErrorCode.UNKNOWN_ERROR);
    }

  }
}