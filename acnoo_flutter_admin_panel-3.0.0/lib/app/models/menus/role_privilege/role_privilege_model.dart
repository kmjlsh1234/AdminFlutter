import 'package:flutter/cupertino.dart';

class RolePrivilegeModel{
  final TextEditingController nameController;
  final TextEditingController codeController;
  int readAuth;
  int writeAuth;

  RolePrivilegeModel({
    required this.nameController,
    required this.codeController,
    required this.readAuth,
    required this.writeAuth
  });

}