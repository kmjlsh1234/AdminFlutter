import 'error_code.dart';
import 'error_code.dart';

class CustomException implements Exception{
  final ErrorCode errorCode;
  CustomException(this.errorCode);
}