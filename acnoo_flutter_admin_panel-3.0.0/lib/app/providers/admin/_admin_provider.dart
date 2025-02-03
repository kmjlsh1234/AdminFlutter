import 'dart:js_interop';

import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_service.dart';
import 'package:flutter/material.dart';

import '../../models/admin/admin.dart';

class AdminProvider extends ChangeNotifier{

  Admin? _admin;
  Admin? get admin{
    return _admin;
  }

}