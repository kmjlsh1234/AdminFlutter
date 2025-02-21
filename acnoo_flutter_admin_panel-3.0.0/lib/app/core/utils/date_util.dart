import 'package:intl/intl.dart';

class DateUtil {
  static String convertDateTime(DateTime? date) {
    if(date != null){
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }

    return 'N/A';
  }
}