import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'error_code.dart';

class ErrorHandler{

  static void handleError<E>(E e, BuildContext context){

    //api통신 오류일 경우
    if(e is DioException){
      if(e.response != null){
        final Map<String, dynamic> responseData = e.response?.data;
        int code = responseData['errorCode'] ?? 0;
        ErrorCode errorCode = ErrorCode.getByCode(code);

        //토큰 오류
        if(errorCode.errorCode >= 140001 && errorCode.errorCode <= 140003){
          GoRouter.of(context).go('/authentication/signin');
          return;
        }
        showError(context, errorCode.message);
      }else{
        showError(context, e.message.toString());
      }
    }

    //개별 정의 오류일 경우
    else if (e is CustomException){
      if(e.errorCode == ErrorCode.JWT_TOKEN_MISSING){
        GoRouter.of(context).go('/authentication/signin');
        return;
      }
      showError(context, e.errorCode.message);
    } else{
      showError(context, e.toString());
    }
  }

  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}