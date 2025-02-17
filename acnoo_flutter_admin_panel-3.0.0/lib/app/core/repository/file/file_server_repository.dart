import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:dio/dio.dart';

import '../../../constants/file/file_category.dart';
import '../../../constants/file/file_type.dart';
import '../../app_config/server_config.dart';
import '../../error/error_code.dart';

class FileServerRepository {
  final dio = Dio();

  //파일 업로드
  Future<String> uploadFile(FileCategory fileCategory, FileType fileType, FormData data) async {
    String url = "${ServerConfig.fileServerUrl}/file/mng/v1/${ServerConfig.admin_file_server_key}/upload/${fileCategory.value}/${fileType.value}";
    Response res = await dio.post(url, data: data);
    String path = res.data['path'] ?? () => throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
    return "${ServerConfig.fileServerUrl}/file/mng/v1/${ServerConfig.admin_file_server_key}/download/${fileCategory.value}/${fileType.value}?path=$path";
  }
}