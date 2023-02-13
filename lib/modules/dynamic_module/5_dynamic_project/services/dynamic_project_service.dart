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


   Future<List> getProjectTabs() async {
    final dynamic response = await DynamicProjectApi().getProjectTabs();
    final List<dynamic> dataResult = response;
    log("sweety ---$dataResult");
     return dataResult;
  }
  Future<List>getEntitySubTabForm(String moduleId,String tabId) async {
     print("moduleID${moduleId}");
     print("tabId${tabId}");
    final dynamic response = await DynamicProjectApi().getEntitySubTabForm(moduleId, tabId);
    final List<dynamic> dataResult = response;
    log("subnentity values ---$dataResult");
    return dataResult;
  }
  Future<List> getProjectForm(String p1, String p2) async {
    final dynamic response = await DynamicProjectApi().getProjectForm(p1,p2);
    final List<dynamic> dataResult = response; 
     return dataResult;
  }
  Future<List> getProject() async {
    final dynamic response = await DynamicProjectApi().getProject();
    final List<dynamic> dataResult = response;
    return dataResult;
  }
  //  Future<List> getActiveFeaturesEntity() async {
  //   final dynamic response = await DynamicProjectApi().getActiveFeaturesEntity();
  //   final List<dynamic> dataResult = response;
  //    return dataResult;
  // }

  @override
  Future<dynamic> getEntity(String entityId) async {
    return _projectApi.getById(entityId);
  }

  @override
  Future<dynamic> addNewEntity(dynamic entity) async {
    return await _projectApi.create(entity);
  }

  @override
  Future<dynamic> updateEntity(String id, dynamic entity) async {
    await _projectApi.update(id, entity);
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

  Future<dynamic> addProjectNote(String projectId, dynamic projectNote) async {
    if (projectNote == null || projectNote == '') projectNote = ' ';

    return _projectApi.addProjectNote(projectId, projectNote);
  }

  Future<dynamic> updateProjectNote(
      String projectId, dynamic projectNote) async {
    if (projectNote == null || projectNote == '') projectNote = ' ';

    return _projectApi.updateProjectNote(projectId, projectNote);
  }

  Future<dynamic> getProjectNote(String projectId) async {
    var data = await _projectApi.getProjectNotes(projectId);
    List<dynamic> notes = data['Items'];
    return notes;
  }

  List<dynamic> getActiveFields() {
    List<dynamic> items =
        Hive.box<dynamic>('projectForm').values.toList();
    print("items---"+items.toString());

    //items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

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

    String projectTypeId = project['PROJECT_TYPE_ID'] ?? 'STD';

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
}
