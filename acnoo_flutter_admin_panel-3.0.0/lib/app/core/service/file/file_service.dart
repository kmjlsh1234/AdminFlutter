import 'dart:developer';
import 'dart:io';

import 'package:acnoo_flutter_admin_panel/app/core/constants/file/file_category.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

import '../../app_config/app_config.dart';
import '../../constants/file/file_type.dart';
import '../../repository/file/file_server_client.dart';
import '../../utils/dio_factory.dart';

class FileService{
  late FileServerClient client = FileServerClient();

  Future<String> uploadFile(FileCategory fileCategory, FileType fileType, FormData formData) async{
    return await client.uploadFile(fileCategory, fileType, formData);
  }
}