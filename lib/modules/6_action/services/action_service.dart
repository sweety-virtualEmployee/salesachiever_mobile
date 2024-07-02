import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/6_action/api/action_api.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';

class ActionService extends EntityService {
  final ActionApi _actionApi;

  ActionService({listName}) : _actionApi = new ActionApi(listName: listName);

  @override
  Future<dynamic> getEntity(String entityId) async {
    return _actionApi.getById(entityId);
  }

  @override
  Future<dynamic> addNewEntity(dynamic entity) async {
    return _actionApi.create(entity);
  }

  @override
  Future<void> updateEntity(String id, dynamic entity) async {
    return _actionApi.update(id, entity);
  }

  @override
  Future<dynamic> searchEntity({
    required String searchText,
    required int pageNumber,
    required int pageSize,
    required List<dynamic>? sortBy,
    required List<dynamic>? filterBy,
  }) async {
    return _actionApi.search(
        searchText, pageNumber, pageSize, sortBy, filterBy);
  }

  Future<List<dynamic>> getByDate(DateTime startDate, DateTime endDate) async {
    var data = await _actionApi.getByDate(startDate, endDate, 'current_user');

    List<dynamic> items = data['Items'];

    return items;
  }

  Future<dynamic> addActionNote(String actionId, dynamic actionNote) async {
    if (actionNote == null || actionNote == '') actionNote = ' ';

    return _actionApi.addActionNote(actionId, actionNote);
  }

  Future<dynamic> updateActionNote(String actionId, dynamic actionNote) async {
    if (actionNote == null || actionNote == '') actionNote = ' ';

    return _actionApi.updateActionNote(actionId, actionNote);
  }

  Future<dynamic> getActionNote(String actionId) async {
    var data = await _actionApi.getActionNotes(actionId);
    List<dynamic> notes = data['Items'];

    return notes;
  }

  List<dynamic> getActiveFields() {
    List<dynamic> items =
        Hive.box<dynamic>('activeFields_action').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items
        .where((e) => e['FIELD_NAME'] != 'ACTION_TYPE_ID')
        .where((e) => e['FIELD_NAME'] != 'NOTES')
        .toList();
  }
  List<dynamic> getDynamicActiveFields() {
    List<dynamic> items =
    Hive.box<dynamic>('dynamicFormFields_A001').values.toList();
    print("length of items");
    print(items.length);

    items.sort((a, b) => a['DISLAY_ORDER'].compareTo(b['DISLAY_ORDER']));

    return items
        .where((e) => e['FIELD_NAME'] != 'ACTION_TYPE_ID')
        .where((e) => e['FIELD_NAME'] != 'NOTES')
        .toList();
  }

  List<dynamic> getuserFields() {
    List<dynamic> items =
        Hive.box<dynamic>('userFields_action').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items;
  }

  bool validateEntity(dynamic action) {
    return validateActiveFields(action) &&
        validateUserFields(action) &&
        validateCompnay(action);
  }

  bool validateActiveFields(dynamic action) {
    var activeFields = getActiveFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    var invalidFields = activeFields
        .where((activeField) => mandatoryFields.any((mandatoryField) =>
            activeField['TABLE_NAME'] == mandatoryField['TABLE_NAME'] &&
            activeField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((activeField) =>
            action[activeField['FIELD_NAME']] == null ||
            action[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidFields.length <= 0;
  }

  bool





  validateCompnay(dynamic action) {
    return action != null &&
        (action['CLASS'] == 'G' || action['ACCT_ID'] != null);
  }

  bool validateUserFields(dynamic action) {
    LookupService _lookupService = LookupService();

    var userFields = getuserFields();
    var mandatoryFields = _lookupService.getMandatoryFields();
    var visibleUserFields = _lookupService.getVisibleUserFields();

    String actionTypeId = action['ACTION_TYPE_ID'] ?? 'STD';

    var invalidUserFields = userFields
        .where((userField) => mandatoryFields.any((mandatoryField) =>
            userField['FIELD_TABLE'] == mandatoryField['TABLE_NAME'] &&
            userField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((userField) => visibleUserFields.any((visibleUserFields) =>
            userField['UDF_ID'] == visibleUserFields['UDF_ID'] &&
            visibleUserFields['TYPE_ID'] == actionTypeId))
        .where((activeField) =>
            action[activeField['FIELD_NAME']] == null ||
            action[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidUserFields.length <= 0;
  }

  @override
  Future<dynamic> siteQuestionApi(String actionId,int pageNumber) async {
    return _actionApi.siteQuestion(actionId,pageNumber);
  }
  @override
  Future<dynamic> updateQuestionAnswer(dynamic answer) async {
    return _actionApi.updateQuestion(answer);
  }
}
