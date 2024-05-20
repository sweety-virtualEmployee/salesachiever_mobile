import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

import '../../../../utils/auth_util.dart';

class DynamicProjectApi {
  final Api _api;
  final String? listName;

  DynamicProjectApi({this.listName}) : _api = Api();

  final String api = StorageUtil.getString('api');

  Future<dynamic> getProjectTabs(String moduleId) async {
    print("api$moduleId");
    final response = await Api().getResult(
        '$api/System/System.CustomFunctionList?FunctionName=GetEntityTabs&Param1=$moduleId');
    print(response);
    return response.data;
  }

  Future<dynamic> getTabsListCount(String id, String type) async {
    final response = await Api().get('$api/~~~~~~~~~/$id/CompanyLinksCount');
    return response.data;
  }

  Future<dynamic> getProjectForm(String p1, String p2) async {
    print("p1$p1");
    final response = await Api().getResult(
        '$api/System/System.CustomFunctionList?FunctionName=GetFieldsByForm&Param1=$p1&Param2=$p2');
    print("getPRojectForm${response.data}");
    return response.data;
  }

  Future<dynamic> getProjectNotes(String typeNote, String projectId) async {
    String noteType = typeNote.substring(0, typeNote.length - 1);
    Response response = await Api().getResult('$api/$noteType/$projectId');
    return response.data;
  }

  Future<void> updateProjectNote(
      String typeNote, String notesId, String note) async {
    print("notesID4${notesId}");
    String noteType = typeNote.substring(0, typeNote.length - 1);

    Response response =
        await Api().put('$api/$noteType/$notesId', {'NOTES': note});
    log("response of update project note${response.data}");
    return response.data;
  }

  Future<dynamic> addProjectNote(String typeNote, String projectId, String note,
      String description) async {
    print("userName${AuthUtil.getUserName()}");
    String noteType = typeNote.substring(0, typeNote.length - 1);
    Response response = await Api().post('$api/$noteType/$projectId', {
      'NOTES': note,
      'DESCRIPTION': description,
      "RTF_NOTES": "",
      "SAUSER_ID": AuthUtil.getUserName()
    });
    return response.data;
  }

  Future<dynamic> getEntitySubTabForm(String p1, String p2) async {
    final response = await Api().getResult(
        '$api/System/System.CustomFunctionList?FunctionName=GetEntitySubTabs&Param1=$p1&Param2=$p2');
    print("GetSubEntityForm${response.data}");
    return response.data;
  }

  Future<dynamic> getTabListEntityApi(
      String path, String tableName, String id, int pageNumber) async {
    print("path: $path");
    print("tableName: $tableName");
    print("id: $id");
    List<dynamic> headers = [];
    var filter;
    if (tableName == "DEAL") {
      filter = [
        {
          'TableName': 'DEAL',
          'FieldName': 'DEAL_ID',
          'Comparison': '5',
          'ItemValue': id
        }
      ];
    } else if (tableName == "CONTACT") {
      filter = [
        {
          'TableName': 'VW_CONTACT_DEAL_HISTORY',
          'FieldName': 'CONT_ID',
          'Comparison': '5',
          'ItemValue': id
        }
      ];
    }
    headers.add({'key': 'filterset', 'headers': jsonEncode(filter)});

    final hasQueryParameters = path.contains('?');

    final url = hasQueryParameters
        ? '/$path'
        : '/$path?pageSize=10&pageNumber=$pageNumber';

    Response response = await Api().get(url, headers);
    print(response.data);
    return response.data;
  }


  Future<dynamic> getProject() async {
    final response = await Api().getResult(
        '$api/System/System.CustomFunctionList?FunctionName=GetFieldsByForm&Param1=P001');
    return response.data;
  }

  Future<dynamic> getLooksUpByDDL(String tableName, String fieldName,
      String returnField, int pageNumber) async {
    final response = await Api().getResult(
        '$api/system/SYSTEM.LookupsByDDL?TableName=$tableName&FieldName=$fieldName&ReturnField=$returnField&Dormant=N&PageSize=20&PageNumber=$pageNumber');
    print(response);
    return response.data;
  }

  Future<dynamic> getLooksUpByRecordId(String recordId) async {
    final response = await Api().getResult('$api$recordId');
    print(response);
    return response.data;
  }

  Future<dynamic> getSearchLooksUpByDDL(String tableName, String fieldName,
      String returnField, String searchText) async {
    final response = await Api().getResult(
        '$api/system/SYSTEM.LookupsByDDL?TableName=$tableName&FieldName=$fieldName&ReturnField=$returnField&SearchText=$searchText&Dormant=N&PageSize=15&PageNumber=1');
    print(response);
    return response.data;
  }

  Future<dynamic> getById(String type, String id) async {
    try {
      if (type == "COMPANY") {
        final response = await Api().get('/company/$id');
        return response;
      } else if (type == "CONTACT") {
        final response = await Api().get('/contact/$id');
        return response;
      } else if (type == "ACTION") {
        final response = await Api().get('/action/$id');
        return response;
      } else if (type == "OPPORTUNITY") {
        final response = await Api().get('/opportunity/$id');
        return response;
      } else if (type == "QUOTATION") {
        final response = await Api().get('/Quotation/$id');
        return response;
      } else {
        final response = await Api().get('/project/$id');
        return response;
      }
    }catch(e){
      throw (e);
    }
  }

  Future<dynamic> create(dynamic project) async {
    Response response = await _api.post('/quotation/', project);
    return response.data;
  }


  Future<dynamic> update(String projectId, dynamic project) async {
    Response response = await _api.put('/quotation/$projectId', project);
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
        '/list/$listName?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber&systemLayout=false',
        headers);
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

  Future<dynamic> getSubscribedReports(String area, String type) async {
    print("area$area");
    final response = await Api().getResult(
        '$api/Report/Report.SubscribedReports/dba?Area=$area&Type=$type');
    print("subscribed reports");
    print(response);
    return response.data;
  }

  Future<dynamic> getStaffZoneSubscribedReports(String category) async {
    print("area$category");
    final response = await Api().getResult(
        '$api/Report/Report.SubscribedReports?id=current_user&Category=$category&Type=Profile');
    print("subscribed reports");
    print(response);
    return response.data;
  }


  Future<dynamic> getGeneratedReports(
      String reportId, String reportTitle, String id) async {
    String localeId = StorageUtil.getString('localeId');
    print("localedID$localeId");
    final response = await Api().getResult(
        '$api/Report/Report.GenerateReport?ReportId=$reportId&ReportTitle=$reportTitle&ACCT_ID=$id&PROJECT_ID=$id&CONTACT_ID=$id&DEAL_ID=$id&ACTION_ID$id&QUOTE_ID=$id&ENTITY_ID=$id&LOCALE_ID=$localeId');
    print("generated reports");
    print(response);
    return response.data;
  }

  Future<dynamic> getStaffZoneGeneratedReports(
      String reportId, String reportTitle, String id) async {
    final response = await Api().getResult(
        '$api/Report/Report.GenerateReport?ReportId=$reportId&ReportTitle=Test123&ENTITY_ID=$id');
    print("generated reports");
    print(response);
    return response.data;
  }

  Future<dynamic> markIssueAsApproved(String quoteId) async {
    final response = await Api().getResult(
        '$api/System/System.CustomFunction?FunctionName=MarkQuoteAsIssued&Param1=$quoteId');
    print("marked issued reports");
    print(response);
    return response.data;
  }

  Future<dynamic> documentMapping(String encodedFile, String projectId,
      String note, String description) async {
    Response response =
        await Api().post('$api/BlobStore/CreateDocumentEntityMapping', {
      "ENTITY_ID": "0000680221",
      "ENTITY_NAME": "ACTION",
      "BLOB_TYPE": "1",
      "BLOB_DATA": encodedFile,
      "FILENAME": "image001.jpg*0000680215",
      "DESCRIPTION": "image001.jpg",
    });
    return response.data;
  }

  Future<dynamic> getDocumentAction(String entityId) async {
    print("api$entityId");
    final response = await Api().getResult('$api/Document/$entityId;');
    print(response);
    return response.data;
  }

  Future<dynamic> getUserBranch() async {
    String user = StorageUtil.getString('loginName');
    final response = await Api().getResult(
        '$api/System/System.CustomFunctionList?FunctionName=GetUserBranches&Param1=$user');
    print("getUserBranch${response.data}");
    return response.data;
  }

  Future<dynamic> getDefaultUserBranch() async {
    String user = StorageUtil.getString('loginName');
    Response response = await Api().get(
        '/user/user.config/?userid=$user&varname=DEFAULT_BRANCH&section=DEFAULTS');
    print("default list${response.data}");
    return response.data;
  }

  Future<dynamic> setDefaultUserBranch(String defaultID) async {
    String user = StorageUtil.getString('loginName');
    Response response = await Api().put('/user/user.config/', {
      "SauserId": user,
      "Section": "DEFAULTS",
      "VarName": "DEFAULT_BRANCH",
      "VarValue": defaultID,
    });
    print("default list${response.data}");
    return response.data;
  }

  Future<dynamic> getSortValueApi(String listName) async {
    String user = StorageUtil.getString('loginName');
    final response = await Api().getResult(
        '$api/user/user.configListFilterSort?userid=$user&Section=M_LIST_SORT_$listName');
    return response.data;
  }

  Future<dynamic> getFilterValueApi(String listName) async {
    String user = StorageUtil.getString('loginName');
    final response = await Api().getResult(
        '$api/user/user.configListFilterSort?userid=$user&Section=M_LIST_FILTER_$listName');
    return response.data;
  }

  Future<dynamic> setSortValue(
      String listName, String fieldName, String sortValue) async {
    String user = StorageUtil.getString('loginName');
    Response response = await Api().put('/user/user.config/', {
      "SauserId": user,
      "Section": "M_LIST_SORT_$listName",
      "VarName": fieldName,
      "VarValue": sortValue
    });
    print("sort value list${response.data}");
    return response.data;
  }

  Future<dynamic> setFilterValue(String listName, String fieldName,
      String sortValue, String comparison) async {
    String user = StorageUtil.getString('loginName');
    Response response = await Api().put('/user/user.config/', {
      "SauserId": user,
      "Section": "M_LIST_FILTER_$listName",
      "VarName": fieldName,
      "VarValue": "${comparison} : ${sortValue}"
    });
    print("sort value list${response.data}");
    return response.data;
  }

  Future<dynamic> deleteSortApi(String varname,String type,String listName) async {
    String user = StorageUtil.getString('loginName');
    final response = await Api().delete(
        '$api/user/user.configListFilterSort?VarName=$varname&userid=$user&Section=M_LIST_${type}_${listName}');
    return response.data;
  }


  Future<dynamic> getStaffZoneEntityApi(String tableName,String fieldName,String staffZoneType,String id,int page,List<dynamic>? sortBy,List<dynamic>? filterBy) async {
    List<dynamic> headers = [];
    print("sort by odf sort by $sortBy");
    var filter = [{"TableName": tableName,"FieldName":fieldName,"Comparison":5,"ItemValue":id}];
    if (sortBy != null) {
      headers.add({'key': 'SortSet', 'headers': jsonEncode(sortBy)});
    }
    if (filterBy != null)
      filterBy.add(filter);
    else
      filterBy = filter;
    print("sort by odf sort by $filterBy");

    headers.add({'key': 'FilterSet', 'headers': jsonEncode(filter)});
    final response = await Api().get(
        '$api$staffZoneType?PageSize=10&PageNumber=$page',headers);
    return response.data;
  }

  Future<dynamic> createStaffZoneEntity(dynamic entity,String staffZoneType) async {
    Response response = await _api.post('/Entity/Entity.$staffZoneType', entity);
    return response.data;
  }

  Future<dynamic> updateStaffZoneEntity(String id, dynamic entity,String staffZoneType) async {
    print("update apju");
    Response response = await _api.put('/Entity/Entity.$staffZoneType', entity);
    return response.data;
  }

  Future<dynamic> getSubTabsValue(String listName,String fieldName,String fieldValue) async {
    final response = await Api().getResult(
        '$api/List/$listName?Fieldname=$fieldName&FieldValue=$fieldValue');
    return response.data;
  }

  Future<dynamic> copyStaffZoneEntity(String staffZoneType,String entityId) async {
    Response response = await _api.post('/Entity/Entity.CopyRecord?EntityName=$staffZoneType&sourceUniqueId=$entityId',{});
    return response.data;
  }

  Future<dynamic> addEntityNote(String entityType,String entityId, String note,String description) async {
    Response response =
    await _api.post('/' + entityType + 'Note' + '/' + entityId, {'NOTES': note,'DESCRIPTION':description});
    return response.data;
  }

  Future<dynamic> getEntityNotes(String entityType,String entityId) async {
    Response response = await _api.get('/$entityType/$entityId/notes');
    return response.data;
  }

  Future<void> updateEntityNote(String entityType,String noteId, String note, String description) async {
    Response response =
    await _api.put('/' + entityType + 'Note' + '/' + noteId, {'NOTES': note,'DESCRIPTION':description});
    return response.data;
  }
}
