import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class ProjectApi {
  final Api _api;
  final String? listName;

  ProjectApi({this.listName}) : _api = Api();

  Future<dynamic> create(dynamic project) async {
    Response response = await _api.post('/project/', project);
    return response.data;
  }

  Future<dynamic> update(String projectId, dynamic project) async {
    Response response = await _api.put('/project/$projectId', project);
    return response.data;
  }

  Future<dynamic> search(String searchText, int pageNumber, int pageSize,
      List<dynamic>? sortBy, List<dynamic>? filterBy) async {
    print("let see if this api getting called$sortBy");
    List<dynamic> headers = [];

    bool classicSearch = StorageUtil.getBool('classicSearch', defValue: true);

    if (!classicSearch && searchText != '%25') {
      var filter = {
        'TableName': 'PROJECT',
        'FieldName': 'PROJECT_TITLE',
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

    return await Api().get(
        '/list/$listName?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber&systemLayout=true',
        headers);
  }

  Future<dynamic> getById(String projectId) async {
  
return await _api.get('/project/$projectId');
  }

  Future<dynamic> addProjectNote(String projectId, String note,String description) async {
   print("userName${AuthUtil.getUserName()}");
    Response response =
        await _api.post('/projectNote/$projectId', {
          'NOTES': note,
          'DESCRIPTION':description,
          "RTF_NOTES": "",
          "SAUSER_ID": AuthUtil.getUserName()});
    return response.data;
  }

  Future<dynamic> getProjectNotes(String projectId) async {
    Response response = await _api.get('/ProjectNote/$projectId');
    return response.data;
  }

  Future<void> updateProjectNote(String notesId,String note) async {
    print("notesID4${notesId}");

    Response response =
        await _api.put('/projectNote/$notesId', {'NOTES': note});
        log("response of update project note${response.data}");
    return response.data;
  }

  Future<dynamic> getUserFields() async {
    Response response = await _api.get('/userField/project');
    // log("response of user fields${response.data}");
    return response.data;
  }

  Future<dynamic> createProjectAccountLink(dynamic projectAccountLink) async {
    Response response =
        await _api.post('/ProjectAccountLink', projectAccountLink);
      //  log("response of create account${response.data}");
    return response.data;
  }

  Future<dynamic> getProjectAccountLink(String linkId) async {
    Response response = await _api.get('/ProjectAccountLink/$linkId');
    return response.data;
  }

  Future<dynamic> updateProjectAccountLink(
      String linkId, dynamic projectAccountLink) async {
    Response response =
        await _api.put('/ProjectAccountLink/$linkId', projectAccountLink);
    return response.data;
  }

  Future<dynamic> deleteProjectAccountLink(String linkId) async {
    Response response = await _api.delete('/ProjectAccountLink/$linkId');
    return response.data;
  }
}
