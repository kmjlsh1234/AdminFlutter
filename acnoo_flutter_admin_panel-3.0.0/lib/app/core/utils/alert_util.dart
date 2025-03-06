import 'package:flutter/material.dart';

class AlertUtil{

  static void successDialog({required BuildContext context, required String message, required String buttonText, required VoidCallback? onPressed}) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(''),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  if (onPressed != null) {
                    onPressed();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(buttonText),
              ),
            ],
          );
        });
  }
}