import 'dart:ui';

import 'package:flutter/material.dart';

class PopupUtil {
  static Future<void> showReturnPopupDialog<T extends Widget>({required BuildContext context, required T dialog, required VoidCallback callBack}) async{
    bool? isSuccess = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: dialog,
        );
      },
    );

    if (isSuccess != null && isSuccess) {
      callBack();
    }
  }

  static Future<void> showPopupDialog<T extends Widget>({required BuildContext context, required T dialog}) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: dialog,
        );
      },
    );
  }
}