import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class AuthUtil {
  static String getUserName() {
    return StorageUtil.getString('loginName');
  }

  static bool hasAccess(int propertyId) {
    dynamic feature = Hive.box<dynamic>('features')
        .values
        .firstWhere((e) => e['PROPERTY_ID'] == propertyId, orElse: () => null);
    return feature?['ACTIVE'] ?? false;
  }
}
