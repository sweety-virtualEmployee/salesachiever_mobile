import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class LangUtil {
  static String getString(String contextId, String itemId, {Box<Locale>? box}) {
    if (box == null) box = Hive.box<Locale>('locales');
    List<Locale> result = box.values
        .where((locale) =>
    locale.contextId == contextId && locale.itemId == itemId)
        .toList();
    var localeId = StorageUtil.getString('localeId');

    if(result.isNotEmpty){
      return result.length > 0
          ? result.first.displayValue
          : 'E:$localeId:$contextId:$itemId';
    }else{
      List<Locale> result = box.values
          .where((locale) =>
      locale.localeId == localeId && locale.itemId == itemId)
          .toList();

      return result.length > 0
          ? result.first.displayValue
          : 'E:$localeId:$contextId:$itemId';
    }

  }

  static String getLocaleString(String itemId, {Box<Locale>? box}) {
    var localeId = StorageUtil.getString('localeId');

    if (box == null) box = Hive.box<Locale>('locales');
    print("localesvalue  ${box.values}");
    List<Locale> result = box.values
        .where((locale) =>
    locale.localeId == localeId && locale.itemId == itemId)
        .toList();

    return result.length > 0
        ? result.first.displayValue
        : 'E:$localeId:$localeId:$itemId';
  }
  static String getStringNew(var fieldData,int i) {
    String first = fieldData[i]['FIELD_TABLE']!=null?fieldData[i]['FIELD_TABLE']:"";
    String second = fieldData[i]['FIELD_DESC']!=null?fieldData[i]['FIELD_DESC']:"";
    return  first + second;



  }

  static String getListValue(String contextId, String itemId) {
    List<Locale> result = Hive.box<Locale>('locales')
        .values
        .where((locale) =>
            locale.contextId.toLowerCase() == contextId.toLowerCase() &&
            locale.itemId.toLowerCase() == itemId.toLowerCase())
        .toList();

    return result.length > 0 ? result.first.displayValue : '';
  }

  static String getMultiListValue(String contextId, String itemId) {
    print("item id check${itemId}");
    print("item id check${contextId}");
    List<Locale> result = Hive.box<Locale>('locales')
        .values
        .where((locale) => locale.contextId == contextId && itemId.contains(locale.itemId))
        .toList();

    print("result$result");

    return result.length > 0 ? result.map((e) => e.displayValue).join(",") : '';
  }

  static List<Locale> getLocaleList(String contextId) {
    print("conetxexid$contextId");
    List<Locale> result = Hive.box<Locale>('locales')
        .values
        .where((locale) => locale.contextId == contextId)
        .toList();
    print("result$result");

    return result;
  }
}
