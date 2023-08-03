import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/5_project/api/project_api.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';

class DynamicProjectService extends EntityService {
  final ProjectApi _projectApi;

  DynamicProjectService({listName}) : _projectApi = new ProjectApi(listName: listName);


   Future<List> getProjectTabs(String moduleId) async {
    final dynamic response = await DynamicProjectApi().getProjectTabs(moduleId);
    final List<dynamic> dataResult = response;
    log("sweety ---$dataResult");
     return dataResult;
  }

  Future<dynamic> getTabsListCount(String id,String type) async {
    final dynamic response = await DynamicProjectApi().getTabsListCount(id, type);
    log("sweetytabs Count ---${response["Count"]}");
    return response;
  }

  Future<List>getEntitySubTabForm(String moduleId,String tabId) async {
     print("moduleID${moduleId}");
     print("tabId${tabId}");
    final dynamic response = await DynamicProjectApi().getEntitySubTabForm(moduleId, tabId);
    final List<dynamic> dataResult = response;
    log("subnentity values ---$dataResult");
    return dataResult;
  }

  Future<List<dynamic>> getTabListEntityApi(
      String path,String tableName,String id) async {
    print("entity${path}");
    var data = await DynamicProjectApi().getTabListEntityApi(path,tableName, id);
    print(data);
    List<dynamic> items = data['Items'];

    return items;
  }

  Future<dynamic> getLookByDDL(
      String tableName,String fieldName,String returnField,int pageNumber) async {
    var data = await DynamicProjectApi().getLooksUpByDDL(tableName,fieldName,returnField,pageNumber);
    return data;

  }

  Future<dynamic> getLookByRecordId(
      String recordId) async {
    var data = await DynamicProjectApi().getLooksUpByRecordId(recordId);
    print(data);
    return data;
  }

  Future<List<dynamic>> getSearchLookByDDL(
      String tableName,String fieldName,String returnField,String searchText) async {
    var data = await DynamicProjectApi().getSearchLooksUpByDDL(tableName,fieldName,returnField,searchText);
    print(data);
    List<dynamic> items = data['Items'];
    return items;
  }

  Future<List> getProjectForm(String p1, String p2) async {
    final dynamic response = await DynamicProjectApi().getProjectForm(p1,p2);
    final List<dynamic> dataResult = response; 
     return dataResult;
  }
  Future<List> getProject() async {
     print("getting project list");
    final dynamic response = await DynamicProjectApi().getProject();
    final List<dynamic> dataResult = response;
    return dataResult;
  }

  @override
  Future<dynamic> getEntityById(String type,String entityId) async {
     print("this api called");
    return DynamicProjectApi().getById(type,entityId);
  }

  @override
  Future<dynamic> addNewEntity(dynamic entity) async {
    return await DynamicProjectApi().create(entity);
  }

  @override
  Future<dynamic> updateEntity(String id, dynamic entity) async {
    await DynamicProjectApi().update(id, entity);
  }

  @override
  Future<dynamic> searchEntity({
    required String searchText,
    required int pageNumber,
    required int pageSize,
    required List<dynamic>? sortBy,
    required List<dynamic>? filterBy,
  }) async {
    return _projectApi.search(
        searchText, pageNumber, pageSize, sortBy, filterBy);
  }

  Future<dynamic> addProjectNote(String typeNote,String projectId, dynamic projectNote,dynamic projectDescription) async {
    if (projectNote == null || projectNote == '') projectNote = ' ';

    return DynamicProjectApi().addProjectNote(typeNote,projectId, projectNote,projectDescription);
  }

  Future<dynamic> updateProjectNote(String typeNote,
    String notesId, dynamic projectNote,) async {
    print("apicalled");
    if (projectNote == null || projectNote == '') projectNote = ' ';

    return  DynamicProjectApi().updateProjectNote(typeNote,notesId,projectNote);
  }

  Future<dynamic> getProjectNote(String typeNote,String projectId) async {
    var data = await DynamicProjectApi().getProjectNotes(typeNote,projectId);
    print("Data${data}");
    dynamic notes = data;
    return notes;
  }

  List<dynamic> getActiveFields() {
    List<dynamic> items =
        Hive.box<dynamic>('projectForm').values.toList();
    print("items---"+items.toString());


    return items.where((e) => e['FIELD_NAME'] != 'PROJECT_TYPE_ID').toList();
  }

  List<dynamic> getuserFields() {
    List<dynamic> items =
        Hive.box<dynamic>('userFields_project').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items;
  }

  Future<dynamic> createProjectAccountLink(dynamic projectAccountLink) async {
    return _projectApi.createProjectAccountLink(projectAccountLink);
  }

  Future<dynamic> getProjectAccountLink(String linkId) async {
    return _projectApi.getProjectAccountLink(linkId);
  }

  Future<dynamic> updateProjectAccountLink(
      String linkId, dynamic projectAccountLink) async {
    return _projectApi.updateProjectAccountLink(linkId, projectAccountLink);
  }

  Future<dynamic> deleteProjectAccountLink(String linkId) async {
    return _projectApi.deleteProjectAccountLink(linkId);
  }

  bool validateEntity(dynamic project) {
    return validateActiveFields(project) && validateUserFields(project);
  }

  bool validateActiveFields(dynamic project) {
    var activeFields = getActiveFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    var invalidFields = activeFields
        .where((activeField) => mandatoryFields.any((mandatoryField) =>
            activeField['TABLE_NAME'] == mandatoryField['TABLE_NAME'] &&
            activeField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((activeField) =>
            project[activeField['FIELD_NAME']] == null ||
            project[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidFields.length <= 0;
  }

  bool validateUserFields(dynamic project) {
    LookupService _lookupService = LookupService();

    var userFields = getuserFields();
    var mandatoryFields = _lookupService.getMandatoryFields();
    var visibleUserFields = _lookupService.getVisibleUserFields();

    String projectTypeId = project['QUOTE_TYPE_ID'] ?? 'STD';

    var invalidUserFields = userFields
        .where((userField) => mandatoryFields.any((mandatoryField) =>
            userField['FIELD_TABLE'] == mandatoryField['TABLE_NAME'] &&
            userField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((userField) => visibleUserFields.any((visibleUserFields) =>
            userField['UDF_ID'] == visibleUserFields['UDF_ID'] &&
            visibleUserFields['TYPE_ID'] == projectTypeId))
        .where((activeField) =>
            project[activeField['FIELD_NAME']] == null ||
            project[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidUserFields.length <= 0;
  }

  Future<List> getSubScribedReports(String area,String type) async {
    final dynamic response = await DynamicProjectApi().getSubscribedReports(area,type);
    final List<dynamic> dataResult = response;
    log("subscripbed values ---$dataResult");
    return dataResult;
  }

  Future<String> getGeneratedReports(String reportId,String reportTitle,String id) async {
    final dynamic response = await DynamicProjectApi().getGeneratedReports(reportId,reportTitle,id);
    final String dataResult = response;
    log("subscripbed values ---$dataResult");
    return dataResult;
  }

  Future<dynamic> markQuoteAsIssued(String quoteId) async {
    final dynamic response = await DynamicProjectApi().markIssueAsApproved(quoteId);
    return response;
  }


  List<dynamic> getDynamicActiveFields() {
    List<dynamic> items =
    Hive.box<dynamic>('activeFields_quotation').values.toList();
    print("length of items");
    print(items.length);

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items.where((e) => e['FIELD_NAME'] != 'QUOTE_TYPE_ID').toList();

  }

  Future<dynamic> getDocuments(String entityId) async {
    final dynamic response = await DynamicProjectApi().getDocumentAction(entityId);
    log("document section$response");
    return response;
  }
}
