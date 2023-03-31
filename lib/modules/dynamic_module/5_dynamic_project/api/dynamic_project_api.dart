import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class DynamicProjectApi {
  final Api _api;
  final String? listName;

  DynamicProjectApi({this.listName}) : _api = Api();

   final String api = StorageUtil.getString('api');
  Future<dynamic> getProjectTabs() async {
    final response = await Api().getResult('$api/System/System.CustomFunctionList?FunctionName=GetEntityTabs&Param1=005');
    return response.data;
  }

  Future<dynamic> getTabsListCount(String id,String type) async {
    final response = await Api().get('$api/Project/$id/CompanyLinksCount');
    return response.data;
  }

  Future<dynamic> getProjectForm(String p1,String p2) async {
    final response = await Api().getResult('$api/System/System.CustomFunctionList?FunctionName=GetFieldsByForm&Param1=$p1 &Param2=$p2');
    print("getPRojectForm${response.data}");
    return response.data;
  }

  Future<dynamic> getEntitySubTabForm(String p1,String p2) async {
    final response = await Api().getResult('$api/System/System.CustomFunctionList?FunctionName=GetEntitySubTabs&Param1=$p1&Param2=$p2');
     print("GetSubEntityForm${response.data}");
    return response.data;
  }

  Future<dynamic> getTabListEntityApi(
      String path) async {
    Response response = await _api.get('/${path}');
    return response.data;
  }

  Future<dynamic> getProject() async {
    final response = await Api().getResult('$api/System/System.CustomFunctionList?FunctionName=GetFieldsByForm&Param1=P001');
    // final response = await Api().getResult('$api/System/System.CustomFunctionList?FunctionName=GetFieldsByForm&Param1=P001');
    return response.data;
  }
  //  Future<dynamic> getActiveFeaturesEntity() async {
  //   final response = await Api().getResult('$api/System/System.CustomFunctionList?FunctionName=GetFieldDataByForm&Param1=P001&Param2=000000000065');
  //   return response.data;
  // }

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

  Future<dynamic> addProjectNote(String projectId, String note) async {
    Response response =
        await _api.post('/projectNote/$projectId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getProjectNotes(String projectId) async {
    Response response = await _api.get('/project/$projectId/notes');
    return response.data;
  }

  Future<void> updateProjectNote(String projectId, String note) async {
    Response response =
        await _api.put('/projectNote/$projectId', {'NOTES': note});
       // log("response of update project note${response.data}");
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
   // log("response of get project link${response.data}");
    return response.data;
  }

  Future<dynamic> updateProjectAccountLink(
      String linkId, dynamic projectAccountLink) async {
    Response response =
        await _api.put('/ProjectAccountLink/$linkId', projectAccountLink);
      //  log("response of update project link${response.data}");
    return response.data;
  }

  Future<dynamic> deleteProjectAccountLink(String linkId) async {
    Response response = await _api.delete('/ProjectAccountLink/$linkId');
    return response.data;
  }
}
