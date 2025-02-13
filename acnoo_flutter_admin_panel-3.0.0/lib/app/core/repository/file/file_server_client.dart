import 'package:acnoo_flutter_admin_panel/app/core/constants/file/file_category.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:dio/dio.dart';

import '../../app_config/app_config.dart';
import '../../constants/file/file_type.dart';
import '../../error/error_code.dart';

class FileServerClient{
  final dio = Dio();

  //파일 업로드
  Future<String> uploadFile(FileCategory fileCategory, FileType fileType, FormData data) async {
    String url = "${AppConfig.fileServerUrl}/file/mng/v1/${AppConfig.admin_file_server_key}/upload/${fileCategory.category}/${fileType.type}";
    Response res = await dio.post(url, data: data);
    String path = res.data['path'] ?? () => throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
    return "${AppConfig.fileServerUrl}/file/mng/v1/${AppConfig.admin_file_server_key}/download/${fileCategory.category}/${fileType.type}?path=$path";
  }
}