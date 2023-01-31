import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class ContactApi {
  final Api _api;
  final String? listName;

  ContactApi({this.listName}) : _api = Api();

  Future<dynamic> create(dynamic contact) async {
    Response response = await _api.post('/contact/', contact);
    return response.data;
  }

  Future<void> update(String contactId, dynamic contact) async {
    Response response = await _api.put('/contact/$contactId', contact);
    return response.data;
  }

  Future<dynamic> search(String searchText, int pageNumber, int pageSize,
      List<dynamic>? sortBy, List<dynamic>? filterBy) async {
    List<dynamic> headers = [];

    bool classicSearch = StorageUtil.getBool('classicSearch', defValue: true);

    if (!classicSearch && searchText != '%25') {
      var filter = {
        'TableName': 'CONTACT',
        'FieldName': 'FIRSTNAME',
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

    return await _api.get(
        '/list/$listName?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber&systemLayout=true',
        headers);
  }

  Future<dynamic> getById(String contactId) async {
    return await _api.get('/contact/$contactId');
  }

  Future<dynamic> addContactNote(String contactId, String note) async {
    Response response =
        await _api.post('/contactNote/$contactId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getContactNotes(String contactId) async {
    Response response = await _api.get('/contact/$contactId/notes');
    return response.data;
  }

  Future<void> updateContactNote(String contactId, String note) async {
    Response response =
        await _api.put('/contactNote/$contactId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getUserFields() async {
    Response response = await _api.get('/userField/contact');
    return response.data;
  }
}
