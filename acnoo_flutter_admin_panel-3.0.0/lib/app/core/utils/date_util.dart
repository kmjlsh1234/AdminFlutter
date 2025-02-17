import 'package:intl/intl.dart';

class DateUtil {

  //DATETIME -> STRING
  static String convertDateTimeToString(DateTime? date) {
    if(date != null){
      return DateFormat("dd/MM/yyyy").format(date);
    }
    return '';
  }

  static String? convertDateTimeToLocalDateTime(DateTime? date){
    if(date == null){
      return null;
    }
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return outputFormat.format(date);
  }

  //STRING -> LOCALDATETIME
  static String? convertStringToLocalDateTime(String? dateStr) {
    if(dateStr == null || dateStr.isEmpty) return null;

    DateFormat inputFormat = DateFormat("dd/MM/yyyy"); // 현재 형식
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss"); // ISO 8601
    DateTime parsedDate = inputFormat.parse(dateStr);

    return outputFormat.format(parsedDate);
  }

  //STRING -> DATETIME
  static DateTime convertStringToDateTime(String dateStr){
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    return inputFormat.parse(dateStr);
  }
}
