import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class PotentialApi {
  final Api _api;
  final String? listName;

  PotentialApi({this.listName}) : _api = Api();

  // Future<dynamic> get(dynamic oppurtunityId) async {
  //   Response response =
  //       await _api.get('/opportunity/$oppurtunityId/potentiallinks');
  //   return response.data;
  // }

  Future<dynamic> create(dynamic oppurtunity) async {
    Response response = await _api.post('/OpportunityPotential', oppurtunity);
    return response.data;
  }

  Future<dynamic> update(String oppurtunityId, dynamic oppurtunity) async {
    Response response =
        await _api.put('/OpportunityPotential/$oppurtunityId', oppurtunity);
    return response.data;
  }

  Future<dynamic> getPotentials(String opportunityId) async {
    Response response =
        await _api.get('/opportunity/$opportunityId/PotentialLinks');
    return response.data;
  }

  Future<dynamic> search(String searchText, int pageNumber, int pageSize,
      List<dynamic>? sortBy, List<dynamic>? filterBy) async {
    List<dynamic> headers = [];

    bool classicSearch = StorageUtil.getBool('classicSearch', defValue: true);

    if (!classicSearch && searchText != '%25') {
      var filter = {
        'TableName': 'PRODUCT_TREE',
        'FieldName': 'CURRENCY_ID',
        'Comparison': '5',
        'ItemValue': '007(currencyID)',
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

    return await _api.get(
        '/OpportunityPotential/OpportunityPotential.SearchProduct?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber',
        headers);
  }

  // Future<dynamic> getById(String oppurtunityId) async {
  //   return await _api.get('/opportunity/$oppurtunityId');
  // }

  Future<dynamic> getRelatedEntity(
      String entity, String id, String type) async {
    Response response = await _api.get('/$entity/$id/$type');
    return response.data;
  }

  Future<dynamic> getUserFields() async {
    Response response = await _api.get('/userField/account');
    return response.data;
  }
}
