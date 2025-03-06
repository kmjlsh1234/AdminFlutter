import 'package:intl/intl.dart';

class DateUtil {

  static const localDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss';
  static const dateTimeFormat = 'yyyy/MM/dd';

  //DATETIME -> STRING(서버에서 데이터 받아서 파싱할 때 사용)
  static String convertDateTimeToString(DateTime? date) {
    if(date != null){
      return DateFormat(dateTimeFormat).format(date);
    }
    return '';
  }

  //서버로 TimePicker에서 LocalDateTime으로 전송 시 사용
  static String? convertToLocalDateTime(String? date){
    if(date == null || date.isEmpty){
      return null;
    }
    if(date != null) {
      DateTime dateTime = DateFormat(dateTimeFormat).parse(date);
      return DateFormat(localDateTimeFormat).format(dateTime);
    }
    return null;
  }



  /*
  static String? convertDateTimeToLocalDateTime(DateTime? date){
    if(date == null){
      return null;
    }
    DateFormat outputFormat = DateFormat(localDateTimeFormat);
    return outputFormat.format(date);
  }

  //STRING -> LOCALDATETIME
  static String? convertStringToLocalDateTime(String? dateStr) {
    if(dateStr == null || dateStr.isEmpty) return null;

    DateFormat inputFormat = DateFormat("dd/MM/yyyy"); // 현재 형식
    DateFormat outputFormat = DateFormat(localDateTimeFormat); // ISO 8601
    DateTime parsedDate = inputFormat.parse(dateStr);

    return outputFormat.format(parsedDate);
  }

  //STRING -> DATETIME
  static DateTime convertStringToDateTime(String dateStr){
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    return inputFormat.parse(dateStr);
  }
  */
}
