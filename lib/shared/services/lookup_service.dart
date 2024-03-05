import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/data/static_ui/action_fields.dart';
import 'package:salesachiever_mobile/data/static_ui/company_fields.dart';
import 'package:salesachiever_mobile/data/static_ui/contact_fields.dart';
import 'package:salesachiever_mobile/data/static_ui/potentialFields.dart';
import 'package:salesachiever_mobile/data/static_ui/project_fields.dart';
import 'package:salesachiever_mobile/data/static_ui/opportunity_fields.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/shared/api/lookup_api.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';

class LookupService {
  Future<void> getActiveFeatures() async {
    final dynamic response = await LookupApi().getSystemActiveFeatures();

    if (response != null) {
      final List<dynamic> activeFeatures = response['Items'];
      log("activefeature$activeFeatures");

      await Hive.box<dynamic>('features').clear();
      await Hive.box<dynamic>('features').addAll(activeFeatures);
    }
  }

  Future<void> getDataDictionary() async {
    final dynamic response = await LookupApi().getDataDictionary();

    if (response != null) {
      final List<dynamic> dataDictionary = response['Items'];
      print("sweety---$dataDictionary");
      await Hive.box<dynamic>('dataDictionary').clear();
      await Hive.box<dynamic>('dataDictionary').addAll(dataDictionary);
    }
  }

  Future<void> getDataDictionaryLookups() async {
    final dynamic response = await LookupApi().getDataDictionaryLookups();

    if (response != null) {
      final List<dynamic> dataDictionaryLookups = response['Items'];

      await Hive.box<dynamic>('dataDictionaryLookups').clear();
      await Hive.box<dynamic>('dataDictionaryLookups')
          .addAll(dataDictionaryLookups);
    }
  }

  Future<void> getDynamicFormData(String entityId) async{
    final dynamic response = await DynamicProjectApi().getProjectForm(entityId,"Init");
    print("response of the value dynamic form");
    print(response);
    await Hive.box<dynamic>('dynamicFormFields_$entityId').clear();
    await Hive.box<dynamic>('dynamicFormFields_$entityId').addAll(response);
  }

  Future<void> getIpadFields(String entityType, bool dynmaicUIEnabled) async {
    List<dynamic> iPadFields = [];
    print("check the dynamic ui enable for this section$dynmaicUIEnabled$entityType");
    if (dynmaicUIEnabled) {
      final dynamic response = await LookupApi().getIpadFields(entityType);
      print("response of the value");
      print(response);

      if (response != null) {
        iPadFields = response['Items'];
      }
    } else {
      if (entityType.toLowerCase() == 'account')
        iPadFields = companyFields;
      else if (entityType.toLowerCase() == 'contact')
        iPadFields = contactFileds;
      else if (entityType.toLowerCase() == 'project')
        iPadFields = projectFields;
      else if (entityType.toLowerCase() == 'action')
        iPadFields = actionFileds;
      else if(entityType.toLowerCase() == 'deal')
        iPadFields = opportunityFields;
      else if(entityType.toLowerCase() == 'quotation')
        iPadFields = opportunityFields;
      else if(entityType.toLowerCase() == 'deal_potential')
        iPadFields = potentialFields;
      else if(entityType.toLowerCase() == 'rate_agreement')
        iPadFields = potentialFields;
      else if(entityType.toLowerCase() == 'job_order')
        iPadFields = potentialFields;
      else if(entityType.toLowerCase() == 'isv')
        iPadFields = potentialFields;
      else if(entityType.toLowerCase() == 'accident_record')
        iPadFields = potentialFields;
      else if(entityType.toLowerCase() == 'initial_order')
        iPadFields = potentialFields;
    }

    await Hive.box<dynamic>('activeFields_$entityType').clear();
    await Hive.box<dynamic>('activeFields_$entityType').addAll(iPadFields);
  }

  Future<void> getUserFields(String entityType) async {
    final dynamic response = await LookupApi().getUserFields(entityType);
    print("entutyyype${entityType}resposne$response");
    if (response != null) {
      final List<dynamic> userFields = response['Items'];

      await Hive.box<dynamic>('userFields_$entityType').clear();
      await Hive.box<dynamic>('userFields_$entityType').addAll(userFields);
    }
  }

  Future<void> getUserFieldProperties() async {
    final dynamic response = await LookupApi().getUserFieldProperties();

    if (response != null) {
      final List<dynamic> userFieldProperties = response['Items'];

      log("useertfirekl,gsdf${userFieldProperties.toString()}");

      await Hive.box<dynamic>('userFieldProperties').clear();
      await Hive.box<dynamic>('userFieldProperties')
          .addAll(userFieldProperties);
    }
  }

  Future<void> getSystemCounty() async {
    final dynamic response = await LookupApi().getSystemCounty();

    if (response != null) {
      final List<dynamic> systemCounty = response['Items'];

      await Hive.box<dynamic>('county').clear();
      await Hive.box<dynamic>('county').addAll(systemCounty);
    }
  }

  Future<void> getAccessRights() async {
    bool upgradedTo_1_0_10 = AuthUtil.hasAccess(40009);
    String userName =
        upgradedTo_1_0_10 ? 'current_user' : AuthUtil.getUserName();

    final dynamic response = await LookupApi().getAccessRights(userName);

    if (response != null) {
      final List<dynamic> accessRights = response;

      await Hive.box<dynamic>('accessRights').clear();
      await Hive.box<dynamic>('accessRights').addAll(accessRights);
    }
  }

  List<dynamic> getMandatoryFields() {
    List<dynamic> items =
        Hive.box<dynamic>('userFieldProperties').values.toList();
    return items
        .where((e) =>
            e['PROPERTY_ID'].toString() == '2' &&
            e['PROPERTY_VALUE'].toString() == 'Y')
        .toList();
  }

  Future<String> getContactusEmail() async {
    final dynamic response = await LookupApi().getContactusEmail();
    return response['Items'][0]['VAR_VALUE'];
  }

  Future<void> getUserFieldVisibility() async {
    final dynamic response = await LookupApi().getUserFieldVisibility();

    if (response != null) {
      final List<dynamic> userFieldVisibility = response['Items'];

      await Hive.box<dynamic>('userFieldVisibility').clear();
      await Hive.box<dynamic>('userFieldVisibility')
          .addAll(userFieldVisibility);
    }
  }

  List<dynamic> getVisibleUserFields() {
    return Hive.box<dynamic>('userFieldVisibility').values.toList();
  }

  List<dynamic> getDefaultValues(String entityType) {
    var defaultValues = Hive.box<dynamic>('userFieldProperties')
        .values
        .where((e) =>
            e['TABLE_NAME'] == entityType.toUpperCase() &&
            e['PROPERTY_ID'] == 8)
        .toList();

    return defaultValues;
  }

  Future<dynamic> getCurrencyValue() async {
    final dynamic response = await LookupApi().getCurrencyValue();

    if (response != null) {
      final List<dynamic> currencyValue = response['Items'];

      await Hive.box<dynamic>('currencyValue').clear();
      await Hive.box<dynamic>('currencyValue')
          .addAll(currencyValue);
    }
  }

  List<dynamic> getDefaultCurrencyValues(String entityType) {
    print("cherkcnskjabhjskhbjak");
    print(Hive.box<dynamic>('currencyValue')
        .values.toList());
    print("entity of currency${entityType}");
    var defaultValues = Hive.box<dynamic>('currencyValue')
        .values
        .where((e) =>
    e['FIELD_NAME'] == entityType.toUpperCase())
        .toList();
    print(defaultValues);
    return defaultValues;
  }

}
