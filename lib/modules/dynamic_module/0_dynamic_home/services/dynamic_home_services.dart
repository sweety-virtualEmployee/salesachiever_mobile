import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/0_dynamic_home/api/dynamic_home_api';



class DynamicHomeService {
  Future<List> getHomeModule() async {
    final dynamic response = await DynamicHomeApi().getHomeModule();
    final List<dynamic> dataResult = response;
    print("response$response");
    if (dataResult.isNotEmpty) {
      await Hive.box<dynamic>('homeModule').clear();
      await Hive.box<dynamic>('homeModule').addAll(dataResult);
    }
     return dataResult;
  }
}
