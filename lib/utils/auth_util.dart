import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class AuthUtil {
  static String getUserName() {
    return StorageUtil.getString('loginName');
  }

  static bool hasAccess(int propertyId) {
    print("acces");
    print("property id$propertyId");
    print("role sbjfhb");
    print(Hive.box<dynamic>('features')
        .values);
    dynamic feature = Hive.box<dynamic>('features')
        .values
        .firstWhere((e) => e['PROPERTY_ID'] == propertyId, orElse: () => null);
    print(feature?['ACTIVE']);

    return feature?['ACTIVE'] ?? false;
  }
}
