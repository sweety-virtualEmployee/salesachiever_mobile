import 'package:salesachiever_mobile/locale/en-UK.dart';
import 'package:salesachiever_mobile/locale/en-US.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class MessageUtil {
  static String getMessage(String key) {
    String localeId = StorageUtil.getString('localeId');

    if (localeId == '1033') {
      return enUS[key] ?? '';
    } else {
      return enUK[key] ?? '';
    }
  }
}
