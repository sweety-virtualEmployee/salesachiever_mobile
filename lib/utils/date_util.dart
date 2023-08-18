import 'package:intl/intl.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class DateUtil {
  static String getFormattedDate(String? date) {
    if (date == null || date == '') {
      return '';
    }

    var localeId = StorageUtil.getString('localeId');
    print("locale id $localeId");
    var dt = DateTime.parse(date);
    if(localeId == "1033"){
      var formatter = new DateFormat('MMM dd, yyyy');
      String formatted = formatter.format(dt);
      return formatted;
    }
    else{
      var formatter = new DateFormat('dd MMM, yyyy');
      String formatted = formatter.format(dt);
      return formatted;
    }



  }

  static String getFormattedTime(String? date) {
    if (date == null || date == '') {
      return '';
    }

    var dt = DateTime.parse(date);
    var formatter = new DateFormat('h:mm a');
    String formatted = formatter.format(dt);
    return formatted;
  }

  static String getCurrencyValue(dynamic value){
    print("value is shown or not$value");
    if (value == null || value == '') {
      return '';
    }

    NumberFormat currencyFormatter = NumberFormat('#,##0.00', 'en_US'); // Format pattern and locale
    String formattedValue = currencyFormatter.format(value / 100);  // Assuming the value is in cents
    return formattedValue;
  }

  static String getFormattedDateTime(String? date) {
    if (date == null || date == '') {
      return '';
    }

    var dt = DateTime.parse(date);
    var formatter = new DateFormat('MMM dd, yyyy HH:mm');
    String formatted = formatter.format(dt);
    return formatted;
  }

  static String formatDate(String dateStr, String timeStr) {
    if(dateStr.contains("T")){
      List<String> arrActionDate = dateStr.split("T");
      String strDate = arrActionDate[0];
      List<String> arrActionTime = timeStr.split(" ");
      String strTime = arrActionTime[1];
      String formattedDate = "$strDate $strTime";
      return formattedDate;

    }
    else{
      List<String> arrActionDate = dateStr.split(" ");
      String strDate = arrActionDate[0];
      List<String> arrActionTime = timeStr.split(" ");
      String strTime = arrActionTime[1];

      String formattedDate = "$strDate $strTime";
      return formattedDate;

    }


  }
}
