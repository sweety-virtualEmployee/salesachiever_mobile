import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/0_dynamic_home/api/dynamic_home_api';



class DynamicHomeService {
  Future<List> getHomeModule() async {
    final dynamic response = await DynamicHomeApi().getHomeModule();
    final List<dynamic> dataResult = response; 
    if (dataResult.isNotEmpty) {
      await Hive.box<dynamic>('homeModule').clear();
      await Hive.box<dynamic>('homeModule').addAll(dataResult);
      log("Home Module${jsonEncode(dataResult)}");
    }
     return dataResult;
  }
  
  // Future<dynamic> getEntityModules() async {
  //   try {
  //     Response response = await Api().get('System/System.CustomFunctionList?FunctionName=GetEntityModules');

  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       print('${response.statusCode} : ${response.data.toString()}');
  //       throw response.statusCode.toString();
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

}
