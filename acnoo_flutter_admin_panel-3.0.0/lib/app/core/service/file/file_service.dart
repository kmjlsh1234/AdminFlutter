import 'package:dio/dio.dart';

import '../../../constants/file/file_category.dart';
import '../../../constants/file/file_type.dart';
import '../../repository/file/file_server_repository.dart';

class FileService{
  late FileServerRepository repository = FileServerRepository();

  Future<String> uploadFile(FileCategory fileCategory, FileType fileType, FormData formData) async{
    return await repository.uploadFile(fileCategory, fileType, formData);
  }
}