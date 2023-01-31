import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:salesachiever_mobile/api/api.dart';

class LoginApi {
  final Api _api;
  final String? listName;

  LoginApi({this.listName}) : _api = Api();

  Future<String> login(
      String api, String loginName, String password, String company) async {
    Options options = Options(
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    print('$loginName $password $company $api');
//Response response = await Dio().post('$api',
    Response response = await Dio().post('$api/login',
        data: {
          'LoginName': loginName,
          'Password': password,
          'Company': company,
          'AppId': '2',
        },
        options: options);
        debugPrint("Sweety");
        log(response.data['Token'].toString());
        log(response.data.toString());

    return response.data['Token'];
  }

  Future<String> checkLicense(String localeId) async {
    Response response = await _api.get('/Licencing/$localeId/Status');
    return response.data;
  }
}
