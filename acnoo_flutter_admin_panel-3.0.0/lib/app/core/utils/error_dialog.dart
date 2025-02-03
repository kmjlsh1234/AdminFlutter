import 'dart:developer';

import 'package:flutter/material.dart';

import '../error/error_code.dart';

class ErrorDialog {

  static void showError(BuildContext context, ErrorCode errorCode) {
    log('errorCode : ${errorCode.errorCode}');
    log('message : ${errorCode.message.toString()}');

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
          content: Text(errorCode.message),
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