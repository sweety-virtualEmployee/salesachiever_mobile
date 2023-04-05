import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/5_project/api/project_api.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';

class ProjectService extends EntityService {
  final ProjectApi _projectApi;

  ProjectService({listName}) : _projectApi = new ProjectApi(listName: listName);

  @override
  Future<dynamic> getEntity(String entityId) async {
    var data = _projectApi.getById(entityId);
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

    return _projectApi.addProjectNote(projectId, projectNote,"");
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
        Hive.box<dynamic>('activeFields_project').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));
    log("activefields-----${items.toString()}");

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
