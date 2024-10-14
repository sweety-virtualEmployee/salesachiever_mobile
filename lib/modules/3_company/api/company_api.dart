import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class CompanyApi {
  final Api _api;
  final String? listName;

  CompanyApi({this.listName}) : _api = Api();

  Future<dynamic> create(dynamic company) async {
    Response response = await _api.post('/company/', company);
    return response.data;
  }

  Future<dynamic> update(String companyId, dynamic company) async {
    Response response = await _api.put('/company/$companyId', company);
    return response.data;
  }

  Future<dynamic> search(String searchText, int pageNumber, int pageSize,
      List<dynamic>? sortBy, List<dynamic>? filterBy) async {
    List<dynamic> headers = [];

    bool classicSearch = StorageUtil.getBool('classicSearch', defValue: true);

    if (!classicSearch && searchText != '%25') {
      var filter = {
        'TableName': 'ACCOUNT',
        'FieldName': 'ACCTNAME',
        'Comparison': '2',
        'ItemValue': searchText,
      };

      if (filterBy != null)
        filterBy.add(filter);
      else
        filterBy = [filter];
    }

    if (sortBy != null)
      headers.add({'key': 'SortSet', 'headers': jsonEncode(sortBy)});

    if (filterBy != null)
      headers.add({'key': 'FilterSet', 'headers': jsonEncode(filterBy)});
      //log("****************header****************");
     // log("header result"+headers.toString());

    return await _api.get(
        '/list/$listName?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber&systemLayout=true',
        headers);
  }

  Future<dynamic> getById(String companyId) async {
    return await _api.get('/company/$companyId');
  }

  Future<dynamic> getRelatedEntity(
      String entity, String id, String type) async {
    Response response = await _api.get('/$entity/$id/$type');
    return response.data;
  }

  Future<dynamic> addCompanyNote(String companyId, String note) async {
    Response response =
        await _api.post('/companyNote/$companyId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getCompanyNotes(String companyId) async {
    Response response = await _api.get('/company/$companyId/notes');
    return response.data;
  }

  Future<void> updateCompanyNote(String companyId, String note) async {
    Response response =
        await _api.put('/companyNote/$companyId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getUserFields() async {
    Response response = await _api.get('/userField/account');
    return response.data;
  }
}
