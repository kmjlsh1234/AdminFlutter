import 'dart:developer';
import 'package:acnoo_flutter_admin_panel/app/core/error/custom_exception.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import '../error/error_code.dart';
class FileUtil{

  //파일 확장자 가져오기
  static Future<String> getFileExtension(String url, Uint8List data) async {
    String? mimeType = lookupMimeType(url, headerBytes: data);
    if (mimeType != null) {
      log('extension : ${mimeType.split('/').last}');
      return mimeType.split('/').last;
    }
    throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
  }

  //Blob URL을 Unit8List로 변환
  static Future<Uint8List> fetchBlobImage(String blobUrl) async {
    final response = await http.get(Uri.parse(blobUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes; // Uint8List 반환
    } else {
      throw CustomException(ErrorCode.FAIL_TO_CONVERT_FILE);
    }
  }
}