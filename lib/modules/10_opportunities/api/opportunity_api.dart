import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';

class OpportunityApi {
  final Api _api;
  final String? listName;

  OpportunityApi({this.listName}) : _api = Api();

  Future<dynamic> create(dynamic oppurtunity) async {
    Response response = await _api.post('/opportunity/', oppurtunity);
    return response.data;
  }

  Future<dynamic> update(String oppurtunityId, dynamic oppurtunity) async {
    Response response = await _api.put('/opportunity/$oppurtunityId', oppurtunity);
    return response.data;
  }

  Future<dynamic> search(String searchText, int pageNumber, int pageSize,
      List<dynamic>? sortBy, List<dynamic>? filterBy) async {
    List<dynamic> headers = [];

    // bool classicSearch = StorageUtil.getBool('classicSearch', defValue: true);

    // if (!classicSearch && searchText != '%25') {
    //   var filter = {
    //     'TableName': 'ACCOUNT',
    //     'FieldName': 'ACCTNAME',
    //     'Comparison': '2',
    //     'ItemValue': searchText,
    //   };

    //   if (filterBy != null)
    //     filterBy.add(filter);
    //   else
    //     filterBy = [filter];
    // }

    if (sortBy != null)
      headers.add({'key': 'SortSet', 'headers': jsonEncode(sortBy)});

    if (filterBy != null)
      headers.add({'key': 'FilterSet', 'headers': jsonEncode(filterBy)});

    return await _api.get(
        '/list/$listName?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber&systemLayout=true',
        headers);
  }

  Future<dynamic> getById(String oppurtunityId) async {
    return await _api.get('/opportunity/$oppurtunityId');
  }

  Future<dynamic> getRelatedEntity(
      String entity, String id, String type) async {
    Response response = await _api.get('/$entity/$id/$type');
    return response.data;
  }

  Future<dynamic> addDealNote(String companyId, String note) async {
    Response response =
        await _api.post('/opportunityNote/$companyId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getDealNotes(String dealId) async {
    Response response = await _api.get('/opportunityNote/$dealId');
    return response.data;
  }

  Future<void> updateDealNote(String companyId, String note) async {
    Response response =
        await _api.put('/opportunityNote/$companyId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getUserFields() async {
    Response response = await _api.get('/userField/account');
    return response.data;
  }

  Future<dynamic> getCompanyOppLink(String linkId) async {
    Response response = await _api.get('/OpportunityCompanyLink/$linkId');
    return response.data;
  }

  Future<dynamic> deleteCompanyOppLink(String linkId) async {
    Response response = await _api.delete('/OpportunityCompanyLink/$linkId');
    return response.data;
  }

  Future<void> updateCompanyOppLink(String linkId, dynamic deal) async {
    Response response =
        await _api.put('/OpportunityCompanyLink/$linkId', deal);
    return response.data;
  }
  
  Future<dynamic> addCompanyOppLink(dynamic deal) async {
    Response response =
        await _api.post('/OpportunityCompanyLink', deal);
    return response.data;
  }

}
