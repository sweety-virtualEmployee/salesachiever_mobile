import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';

class LocaleApi {
  Future<dynamic> localization(localeId) async {
    Response response = await Api().get('/localizations?localeID=$localeId');
    return response.data;
  }

  Future<dynamic> updateSelectedLocalization(localeId) async {
    Response response = await Api().post('/localization/$localeId', {});
    return response.data;
  }
}
