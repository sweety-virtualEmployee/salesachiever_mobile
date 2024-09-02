import 'dart:developer';
import 'package:hive/hive.dart';


class CustomActiveFeature{
 Future<bool> activeFeatures() async {
     final box= await Hive.openBox<dynamic>('features');
      var features = box.values.toList();
      var propertyId;
    late bool isContain;

      for (int i = 0; i < features.length; i++) {
    propertyId = {
     'PROPERTY_ID': features[i]['PROPERTY_ID'],
     'ACTIVE': features[i]['ACTIVE']
  };
  if(propertyId['PROPERTY_ID'] == 60012 && propertyId['ACTIVE']== true){
      isContain = true;
      break;
  }else{
    isContain = false;
  }
}
return isContain;
}
}        