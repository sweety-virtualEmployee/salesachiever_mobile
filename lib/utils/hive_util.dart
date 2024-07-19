import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';

class HiveUtil {
  static List<Locale> getLocales(String contextId) {
    List<Locale> result = Hive.box<Locale>('locales')
        .values
        .where((locale) => locale.contextId == contextId)
        .toList();

    result.sort((a, b) => a.displayValue.compareTo(b.displayValue));

    return result;
  }

  static String getContextId(
      String entityType, String tableName, String fieldName) {
    print("tablename$tableName");
    var result = Hive.box<dynamic>('dataDictionaryLookups').values.firstWhere(
        (e) => e['TABLE_NAME'] == tableName && e['FIELD_NAME'] == fieldName,
        orElse: () => null);


    if (result == null) return '';

    if (result['LOOKUP_TABLE'] == 'USER_LOOKUP') {
      // var ufid = '';
      var ufid = Hive.box<dynamic>('userFields_${tableName.toLowerCase()}').values.firstWhere(
          (e) => e['FIELD_TABLE'] == tableName && e['FIELD_NAME'] == fieldName);
      print("uufid$ufid");
      return '${result['LOOKUP_TABLE']}.${ufid['UDF_ID']}.${result['LOOKUP_KEYFIELD']}';
    } else
      return '${result['LOOKUP_TABLE']}.${result['LOOKUP_KEYFIELD']}';
  }
}
