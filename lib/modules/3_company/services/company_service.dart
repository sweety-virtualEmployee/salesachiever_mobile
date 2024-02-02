import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/3_company/api/company_api.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';

class CompanyService extends EntityService {
  final CompanyApi _companyApi;

  CompanyService({listName}) : _companyApi = new CompanyApi(listName: listName);

  @override
  Future<dynamic> getEntity(String entityId) async {
    return _companyApi.getById(entityId);
  }

  @override
  Future<dynamic> addNewEntity(dynamic entity) async {
    return _companyApi.create(entity);
  }

  @override
  Future<dynamic> updateEntity(String id, dynamic entity) async {
    return _companyApi.update(id, entity);
  }

  @override
  Future<dynamic> searchEntity({
    required String searchText,
    required int pageNumber,
    required int pageSize,
    required List<dynamic>? sortBy,
    required List<dynamic>? filterBy,
  }) async {
    return _companyApi.search(
        searchText, pageNumber, pageSize, sortBy, filterBy);
  }

  Future<List<dynamic>> getRelatedEntity(
      String entity, String id, String type) async {
    print("entity${entity}");
    print("type${type}");
    print("id${id}");
    var data = await _companyApi.getRelatedEntity(entity, id, type);
    List<dynamic> items = data['Items'];

    return items;
  }

  Future<dynamic> addCompanyNote(String companyId, dynamic companyNote) async {
    if (companyNote == null || companyNote == '') companyNote = ' ';

    return _companyApi.addCompanyNote(companyId, companyNote);
  }

  Future<dynamic> updateCompanyNote(
      String companyId, dynamic companyNote) async {
    if (companyNote == null || companyNote == '') companyNote = ' ';

    return _companyApi.updateCompanyNote(companyId, companyNote);
  }

  Future<dynamic> getCompanyNote(String companyId) async {
    var data = await _companyApi.getCompanyNotes(companyId);
    List<dynamic> notes = data['Items'];

    return notes;
  }

  List<dynamic> getActiveFields() {
    List<dynamic> items =
        Hive.box<dynamic>('activeFields_account').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items.where((e) => e['FIELD_NAME'] != 'ACCT_TYPE_ID').toList();
  }
  List<dynamic> getDynamicActiveFields() {
    List<dynamic> items =
    Hive.box<dynamic>('dynamicFormFields_C001').values.toList();
    print("length of items");
    print(items.length);

    items.sort((a, b) => a['DISLAY_ORDER'].compareTo(b['DISLAY_ORDER']));

    return items.where((e) => e['FIELD_NAME'] != 'ACCT_TYPE_ID').toList();
  }

  List<dynamic> getuserFields() {
    List<dynamic> items =
        Hive.box<dynamic>('userFields_account').values.toList();

    items.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    return items;
  }

  bool validateEntity(dynamic company) {
    return validateActiveFields(company) && validateUserFields(company);
  }

  bool validateActiveFields(dynamic company) {
    var activeFields = getActiveFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    var invalidFields = activeFields
        .where((activeField) => mandatoryFields.any((mandatoryField) =>
            activeField['TABLE_NAME'] == mandatoryField['TABLE_NAME'] &&
            activeField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((activeField) =>
            company[activeField['FIELD_NAME']] == null ||
            company[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidFields.length <= 0;
  }

  bool validateUserFields(dynamic company) {
    LookupService _lookupService = LookupService();

    var userFields = getuserFields();
    var mandatoryFields = _lookupService.getMandatoryFields();
    var visibleUserFields = _lookupService.getVisibleUserFields();

    String companyTypeId = company['ACCT_TYPE_ID'] ?? 'STD';

    var invalidUserFields = userFields
        .where((userField) => mandatoryFields.any((mandatoryField) =>
            userField['FIELD_TABLE'] == mandatoryField['TABLE_NAME'] &&
            userField['FIELD_NAME'] == mandatoryField['FIELD_NAME']))
        .where((userField) => visibleUserFields.any((visibleUserFields) =>
            userField['UDF_ID'] == visibleUserFields['UDF_ID'] &&
            visibleUserFields['TYPE_ID'] == companyTypeId))
        .where((activeField) =>
            company[activeField['FIELD_NAME']] == null ||
            company[activeField['FIELD_NAME']] == '')
        .toList();

    return invalidUserFields.length <= 0;
  }
}
