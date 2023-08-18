import 'dart:convert';

import 'package:salesachiever_mobile/api/api.dart';

class LookupApi {
  Future<dynamic> getSystemActiveFeatures() async {
    final response = await Api().get('/System/0/ActiveFeatures');
    return response.data;
  }

  Future<dynamic> getSystemLookups() async {
    final response = await Api().get('/System/Lookups');
    return response.data;
  }

  Future<dynamic> getDataDictionary() async {
    final response = await Api().get('/System/0/DataDictionary');
    return response.data;
  }

  Future<dynamic> getDataDictionaryLookups() async {
    final response = await Api().get('/System/0/DataDictionaryLookups');
    return response.data;
  }

  Future<dynamic> getIpadFields(String entityType) async {
    final response = await Api()
        .get('/system/Ipad.FieldsOrderOfTable?TABLENAME=$entityType');
    return response.data;
  }

  Future<dynamic> getUserFields(String entityType) async {
    final response = await Api().get('/UserField/$entityType');
    return response.data;
  }

  Future<dynamic> getUserFieldProperties() async {
    final response = await Api().get('/User/User.FieldProperties');
    return response.data;
  }

  Future<dynamic> getContactusEmail() async {
    final response = await Api()
        .get('/system/system.settings?VarName=ContactUsEmailAddress');
    return response.data;
  }

  Future<dynamic> getAccessRights(String user) async {
    final response = await Api().get('/User/$user/AccessRights');
    return response.data;
  }

  Future<dynamic> getSystemCounty() async {
    final response = await Api().get('/System/Lookups.County/null');
    return response.data;
  }

  Future<dynamic> getUserFieldVisibility() async {
    final response = await Api().get('/UserField/UserField.Visibility');
    return response.data;
  }
  Future<dynamic> getCurrencyValue() async {
    List<dynamic> headers = [];
    var filter = [{"TableName":"DATA_DICT_FORMAT","FieldName":"TABLE_NAME","Comparison":"5","ItemValue":""}];

    headers.add({'key': 'filterset', 'headers': jsonEncode(filter)});
    final dynamic response  = await  Api().get('/list/CURFORMAT?pageSize=10&pageNumber=1',headers);
    return response.data;
  }
}
