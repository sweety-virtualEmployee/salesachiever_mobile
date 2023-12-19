import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/api/potential_api.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';

class PotentialService extends EntityService {
  final PotentialApi _oppApi;

  PotentialService({listName}) : _oppApi = new PotentialApi(listName: listName);

  Future<dynamic> getPotentials(String oppurtunityId) async {
    return _oppApi.getPotentials(oppurtunityId);
  }
  // @override
  // Future<dynamic> getEntity(String entityId) async {
  //   return _oppApi.getById(entityId);
  // }

  @override
  Future<dynamic> addNewEntity(dynamic entity) async {
    return _oppApi.create(entity);
  }

  @override
  Future<dynamic> updateEntity(String id, dynamic entity) async {
    return _oppApi.update(id, entity);
  }

    @override
  Future<dynamic> searchEntity({
    required String searchText,
    required int pageNumber,
    required int pageSize,
    required List<dynamic>? sortBy,
    required List<dynamic>? filterBy,
  }) async {
    return _oppApi.search(
        searchText, pageNumber, pageSize, sortBy, filterBy);
  }

  Future<List<dynamic>> getRelatedEntity(
      String entity, String id, String type) async {
    var data = await _oppApi.getRelatedEntity(entity, id, type);
    List<dynamic> items = data['Items'];

    return items;
  }

  List<dynamic> getActiveFields() {
    List<dynamic> items =
        Hive.box<dynamic>('activeFields_deal_potential').values.toList();

      items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items.where((e) => e['FIELD_NAME'] != 'ACCT_TYPE_ID').toList();
  }

  List<dynamic> getuserFields() {
    List<dynamic> items =
        Hive.box<dynamic>('userFields_deal_potential').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items;
  }

  bool validateEntity(dynamic deal) {
    return validateActiveFields(deal) && validateUserFields(deal);
  }

  bool validateActiveFields(dynamic deal) {
    var activeFields = getActiveFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    var invalidFields = activeFields
        .where((activeField) => mandatoryFields.any((mandatoryField) =>
            activeField['TABLE_NAME'] == mandatoryField['TABLE_NAME'] &&
            activeField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((activeField) =>
            deal[activeField['FIELD_NAME']] == null ||
            deal[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidFields.length <= 0;
  }

  bool validateUserFields(dynamic deal) {
    LookupService _lookupService = LookupService();

    var userFields = getuserFields();
    var mandatoryFields = _lookupService.getMandatoryFields();
    var visibleUserFields = _lookupService.getVisibleUserFields();

    String dealId = deal['DEAL_TYPE_ID'] ?? 'STD';

    var invalidUserFields = userFields
        .where((userField) => mandatoryFields.any((mandatoryField) =>
            userField['FIELD_TABLE'] == mandatoryField['TABLE_NAME'] &&
            userField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((userField) => visibleUserFields.any((visibleUserFields) =>
            userField['UDF_ID'] == visibleUserFields['UDF_ID'] &&
            visibleUserFields['TYPE_ID'] == dealId))
        .where((activeField) =>
            dealId[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidUserFields.length <= 0;
  }
}
