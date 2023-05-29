

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  late Dio _dio;

  Api() {
    final uri = StorageUtil.getString('api');

    BaseOptions options = BaseOptions(
      baseUrl: uri,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
      connectTimeout: 120000,
      receiveTimeout: 300000,
    );

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before request is sent
        final token = StorageUtil.getString('token');

        options.headers.addAll(
          {'Authorization': 'Token $token'},
        );

        print('Request(${options.method}): ${options.uri}');

        if (options.data != null) print('Request: ${options.data}');
        if (options.headers.length > 0) print('Request: ${options.headers}');

        return handler.next(options); //continue
        // If you want to resolve the request with some custom data，
        // you can resolve a `Response` object eg: return `dio.resolve(response)`.
        // If you want to reject the request with a error message,
        // you can reject a `DioError` object eg: return `dio.reject(dioError)`
      },
      onResponse: (response, handler) {
        print('Response: ${response.realUri}');
        // Do something with response data
        return handler.next(response); // continue
        // If you want to reject the request with a error message,
        // you can reject a `DioError` object eg: return `dio.reject(dioError)`
      },
      onError: (DioError e, handler) {
        print('Error: ${e.response}');

        var message =
            MessageUtil.getMessage(e.response?.statusCode.toString() ?? '500');

        var error = DioError(requestOptions: e.requestOptions, error: message);

        // Do something with response error
        return handler.next(error); //continue
        // If you want to resolve the request with some custom data，
        // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      },
    ));
  }

  Future<dynamic> get(String path, [List<dynamic>? headers]) async {
    var companyModule;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('myTimestampKey');
    try {
      print("checking of headers");
      print(headers);
       headers?.forEach(
          (header) => _dio.options.headers[header['key']] = header['headers']);
      companyModule = await _dio.get(path,options: Options(headers: {"TableName":"ACCOUNT","FieldName":"ACCTNAME","SortOrder":2,"SortIndex":0},

      ));
       int timestamp = DateTime.now().millisecondsSinceEpoch;

       final prefs = await SharedPreferences.getInstance();
       prefs.setInt('myTimestampKey', timestamp);

       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
       print("dateTime${dateTime}");
       print("dateTime${timestamp}");
      return companyModule;
    } catch (e) {
      print("error");
      print(e.toString());
      print(e);
      throw (e);
    }
  }
     
     Future<dynamic> getResult(String path, ) async {
    var companyModule;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('myTimestampKey');
    try {
    var  token =  StorageUtil.getString('token');
      companyModule = await _dio.get(path,options: Options(method: "GET", headers: { "Authorization": "Token $token","Accept": "application/json" }));
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('myTimestampKey', timestamp);

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return companyModule;
    } catch (e) {
      print(e);
      throw (e);
    }
  }
    

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('myTimestampKey');
    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('myTimestampKey', timestamp);

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      print("dateTime${dateTime}");
      print("dateTime${timestamp}");
      return await _dio.post(path, data: data);
    } catch (e) {
      throw (e);
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('myTimestampKey');
    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('myTimestampKey', timestamp);

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      print("dateTime${dateTime}");
      print("dateTime${timestamp}");
      return await _dio.put(path, data: data);
    } catch (e) {
      throw (e);
    }
  }

  Future<dynamic> delete(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('myTimestampKey');
    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('myTimestampKey', timestamp);

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      print("dateTime${dateTime}");
      print("dateTime${timestamp}");
      return await _dio.delete(path);
    } catch (e) {
      throw (e);
    }
  }
}
