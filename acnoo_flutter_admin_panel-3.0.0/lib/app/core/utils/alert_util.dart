import 'package:flutter/material.dart';

class AlertUtil{
  static void popupSuccessDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(''),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }

  static void viewSuccessDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(''),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        });
  }
}