import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';

class ActionApi {
  final Api _api;
  final String? listName;

  ActionApi({this.listName}) : _api = Api();

  Future<dynamic> create(dynamic action) async {
    print("Action creadte $action");
    Response response = await _api.post('/action/', action);
    return response.data;
  }

  Future<dynamic> update(String actionId, dynamic action) async {
    Response response = await _api.put('/action/$actionId', action);
    return response.data;
  }

  Future<dynamic> search(String searchText, int pageNumber, int pageSize,
      List<dynamic>? sortBy, List<dynamic>? filterBy) async {
    List<dynamic> headers = [];

    if (sortBy != null)
      headers.add({'key': 'SortSet', 'headers': jsonEncode(sortBy)});

    if (filterBy != null)
      headers.add({'key': 'FilterSet', 'headers': jsonEncode(filterBy)});

    return await _api.get(
        '/list/$listName?searchText=$searchText&pageSize=$pageSize&pageNumber=$pageNumber&systemLayout=true',
        headers);
  }

  Future<dynamic> getById(String actionId) async {
    return await _api.get('/action/$actionId');
  }

  Future<dynamic> getByDate(
      DateTime startDate, DateTime endDate, String user) async {
    Response response = await _api.get(
        '/action/Actions.ByDate?StartDate=$startDate&EndDate=$endDate&SauserID=$user');

    return response.data;
  }

  Future<dynamic> addActionNote(String actionId, String note) async {
    Response response =
        await _api.post('/actionNote/$actionId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getActionNotes(String actionId) async {
    Response response = await _api.get('/action/$actionId/notes');
    return response.data;
  }

  Future<void> updateActionNote(String actionId, String note) async {
    Response response =
        await _api.put('/actionNote/$actionId', {'NOTES': note});
    return response.data;
  }

  Future<dynamic> getUserFields() async {
    Response response = await _api.get('/userField/action');
    return response.data;
  }

  Future<dynamic> siteQuestion(String actionId,int pageNumber) async {
    List<dynamic> headers = [];
    var filter = {
      'TableName': 'VW_ACTION_QUESTIONS',
      'FieldName': 'ACTION_ID',
      'Comparison': '2',
      'ItemValue': actionId,
    };
    headers.add({'key': 'FilterSet', 'headers': jsonEncode([filter])});
    print("herad$headers");
    Response response = await _api.get(
        '/LIST/ACQUES?SystemLayout=false&pageSize=300&pageNumber=$pageNumber', headers);
    return response.data;
  }

  Future<void> updateQuestion(dynamic answer) async {
    Response response =
    await _api.put('/ActionQuestion/', answer);
    return response.data;
  }

  Future<void> actionQuestionReportApi() async {
    Response response = await _api.get('/system/system.settings?varname=ActionQuestionRpt');
    return response.data;
  }

  Future<void> questionReportApi(String reportId, String actionId) async {
    Response response = await _api.get('/ACTION/Actions.QuestionReport?ReportId=$reportId&ActionId=$actionId');
    return response.data;
  }

  Future<void> getTableTierCategoryValues() async {
    Response response = await _api.get('/System/Table.Data/tbl_TIER2/?searchtext=%25&pageSize=-1&pageNumber=0');
    return response.data;
  }

  Future<dynamic> updateActionCategory(String actionId, dynamic image) async {
    Response response = await _api.put('/Document/$actionId', {
      "ENTITY_ID": image["ENTITY_ID"],
      "ENTITY_NAME": "ACTION",
      "BLOB_TYPE": image["BLOB_TYPE"],
      "BLOB_ID": image["BLOB_ID"],
      "FILENAME": image["FILENAME"],
      "DESCRIPTION": image["DESCRIPTION"],
      "ABORT": image["ABORT"],
      "SHOW_PHOTO": image["SHOW_PHOTO"],
      "CATEGORY_ID": image["CATEGORY_ID"],
    });
    return response.data;
  }
}
