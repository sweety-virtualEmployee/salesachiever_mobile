import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/4_contact/api/contact_api.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';

class ContactService extends EntityService {
  final ContactApi _contactApi;

  ContactService({listName}) : _contactApi = new ContactApi(listName: listName);

  @override
  Future<dynamic> getEntity(String entityId) async {
    return _contactApi.getById(entityId);
  }

  @override
  Future<dynamic> addNewEntity(dynamic entity) async {
    return await _contactApi.create(entity);
  }

  @override
  Future<dynamic> updateEntity(String id, dynamic entity) async {
    await _contactApi.update(id, entity);
  }

  @override
  Future<dynamic> searchEntity({
    String searchText = '%25',
    int pageNumber = 0,
    int pageSize = 15,
    List<dynamic>? sortBy,
    List<dynamic>? filterBy,
  }) async {
    return _contactApi.search(
        searchText, pageNumber, pageSize, sortBy, filterBy);
  }

  Future<dynamic> addContactNote(String contactId, dynamic contactNote) async {
    if (contactNote == null || contactNote == '') contactNote = ' ';

    return _contactApi.addContactNote(contactId, contactNote);
  }

  Future<dynamic> updateContactNote(
      String contactId, dynamic contactNote) async {
    if (contactNote == null || contactNote == '') contactNote = ' ';

    return _contactApi.updateContactNote(contactId, contactNote);
  }

  Future<dynamic> getContactNote(String contactId) async {
    var data = await _contactApi.getContactNotes(contactId);
    List<dynamic> notes = data['Items'];

    return notes;
  }

  List<dynamic> getActiveFields() {
    List<dynamic> items =
        Hive.box<dynamic>('activeFields_contact').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items.where((e) => e['FIELD_NAME'] != 'CONTYPE_ID').toList();
  }

  List<dynamic> getuserFields() {
    List<dynamic> items =
        Hive.box<dynamic>('userFields_contact').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items;
  }

  bool validateEntity(dynamic contact) {
    return validateActiveFields(contact) && validateUserFields(contact);
  }

  bool validateActiveFields(dynamic contact) {
    var activeFields = getActiveFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    var invalidFields = activeFields
        .where((activeField) => mandatoryFields.any((mandatoryField) =>
            activeField['TABLE_NAME'] == mandatoryField['TABLE_NAME'] &&
            activeField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((activeField) =>
            contact[activeField['FIELD_NAME']] == null ||
            contact[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidFields.length <= 0;
  }

  bool validateUserFields(dynamic contact) {
    LookupService _lookupService = LookupService();

    var userFields = getuserFields();
    var mandatoryFields = _lookupService.getMandatoryFields();
    var visibleUserFields = _lookupService.getVisibleUserFields();

    String contactTypeId = contact['CONTYPE_ID'] ?? 'STD';

    var invalidUserFields = userFields
        .where((userField) => mandatoryFields.any((mandatoryField) =>
            userField['FIELD_TABLE'] == mandatoryField['TABLE_NAME'] &&
            userField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((userField) => visibleUserFields.any((visibleUserFields) =>
            userField['UDF_ID'] == visibleUserFields['UDF_ID'] &&
            visibleUserFields['TYPE_ID'] == contactTypeId))
        .where((activeField) =>
            contact[activeField['FIELD_NAME']] == null ||
            contact[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidUserFields.length <= 0;
  }
}
