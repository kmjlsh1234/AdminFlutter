

import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/file/file_category.dart';
import '../../../constants/file/file_type.dart';
import '../../error/error_code.dart';
import '../../repository/file/file_server_repository.dart';

class FileService{
  late FileServerRepository repository = FileServerRepository();

  Future<String> uploadFile(FileCategory fileCategory, FileType fileType, FormData formData) async{
    return await repository.uploadFile(fileCategory, fileType, formData);
  }

  Future<String> uploadFileTest(XFile? file, FileCategory fileCategory, FileType fileType) async {
    if(file == null) {
      throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
    }
    Uint8List? bytes = await file.readAsBytes();
    MultipartFile multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
    FormData formData = FormData.fromMap({"file": multipartFile});
    return await repository.uploadFile(fileCategory, fileType, formData);
  }
}