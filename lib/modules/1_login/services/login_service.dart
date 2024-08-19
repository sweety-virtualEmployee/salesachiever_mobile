import 'dart:developer';
import 'package:salesachiever_mobile/exceptions/invalid_license_exception.dart';
import 'package:salesachiever_mobile/modules/1_login/api/login_api.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/services/list_manager_service.dart';
import 'package:salesachiever_mobile/shared/services/locale_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class LoginService {
  Future<void> login(
    String api,
    String loginName,
    String password,
    String company,
    String localeId,
    String firstUrl,
    String SecondUrl,
    
  ) async {
    final String token =
        await LoginApi().login(api, loginName, password, company);

    await _saveLoginDetails(token, api, loginName, company,firstUrl,SecondUrl);
    await _updateLocalization(localeId);
    await _checkLicense(localeId);
    await _fetchActiveFeatures();
    await _fetchAccessRights();

    _fetchLocale(localeId);
    _fetchDefaultLists();
    _fetchDataDictionary();
    _fetchDataDictionaryLookups();
    _fetchIpadFields();
    _fetchUserFieldProperties();
    _fetchUserFieldVisibility();
    _fetchUserFields();
    _fetchSystemCounty();
    //_fetchCurrencyValue();
    _dynamicFormData();
  }



  Future<void> _saveLoginDetails(
      String token, String api, String loginName, String company, String firstUrl,
    String SecondUrl,) async {
      if(firstUrl != SecondUrl){
         StorageUtil.putString('changeFirstUrl', SecondUrl);
        StorageUtil.putString('newUrl', SecondUrl);
      }else{
        StorageUtil.putString('firstUrl', firstUrl);
        StorageUtil.putString('changeFirstUrl', '');
      }
    StorageUtil.putString('token', token);
      log(token);
    StorageUtil.putString('api', api);
    StorageUtil.putString('loginName', loginName);
    StorageUtil.putString('company', company);
    
  }

  Future<void> _updateLocalization(localeId) async {
    // LocaleService lookupService = LocaleService();
    // await lookupService.updateSelectdLocalization(localeId);

    StorageUtil.putString('localeId', localeId);
  }

  Future<void> _checkLicense(String localeId) async {
    String status = await LoginApi().checkLicense(localeId);

    if (!status.contains("OK")) throw InvalidLicenceException();
  }

  Future<void> _fetchLocale(String localeId) async {
    LocaleService lookupService = LocaleService();
    await lookupService.localizations(localeId);
  }

  Future<void> _fetchActiveFeatures() async {
    LookupService lookupService = LookupService();
    await lookupService.getActiveFeatures();
  }

  Future<void> _fetchAccessRights() async {
    LookupService lookupService = LookupService();
    await lookupService.getAccessRights();
  }

  Future<void> _fetchDataDictionary() async {
    LookupService lookupService = LookupService();
    await lookupService.getDataDictionary();
  }

  Future<void> _fetchDataDictionaryLookups() async {
    LookupService lookupService = LookupService();
    await lookupService.getDataDictionaryLookups();
  }

  Future<void> _fetchDefaultLists() async {
    ListManagerService listManagerService = ListManagerService();
    await listManagerService.getDefaultLists();
  }

  Future<void> _dynamicFormData()async {
    LookupService lookupService = LookupService();
    await lookupService.getDynamicFormData('P001');
    await lookupService.getDynamicFormData('C001');
    await lookupService.getDynamicFormData('Q001');
    await lookupService.getDynamicFormData('A001');
    await lookupService.getDynamicFormData('O001');
    await lookupService.getDynamicFormData('D001');
  }

  Future<void> _fetchIpadFields() async {
    //check 50013 enabled
    bool dynmaicUIEnabled = AuthUtil.hasAccess(60012);
    LookupService lookupService = LookupService();
    await lookupService.getIpadFields('account', dynmaicUIEnabled);
    await lookupService.getIpadFields('contact', dynmaicUIEnabled);
    await lookupService.getIpadFields('project', dynmaicUIEnabled);
    await lookupService.getIpadFields('action', dynmaicUIEnabled);
    await lookupService.getIpadFields('deal', dynmaicUIEnabled);
    await lookupService.getIpadFields('quotation', dynmaicUIEnabled);
    await lookupService.getIpadFields('rate_agreement', dynmaicUIEnabled);
    await lookupService.getIpadFields('job_order', dynmaicUIEnabled);
    await lookupService.getIpadFields('isv', dynmaicUIEnabled);
    await lookupService.getIpadFields('accident_record', dynmaicUIEnabled);
    await lookupService.getIpadFields('initial_order', dynmaicUIEnabled);
  }

  Future<void> _fetchUserFields() async {
    LookupService lookupService = LookupService();
    await lookupService.getUserFields('account');
    await lookupService.getUserFields('contact');
    await lookupService.getUserFields('project');
    await lookupService.getUserFields('action');
    await lookupService.getUserFields('deal');
    await lookupService.getUserFields('quotation');
    await lookupService.getUserFields('rate_agreement');
    await lookupService.getUserFields('job_order');
    await lookupService.getUserFields('isv');
    await lookupService.getUserFields('accident_record');
    await lookupService.getUserFields('initial_order');
  }

  Future<void> _fetchUserFieldProperties() async {
    LookupService lookupService = LookupService();
    await lookupService.getUserFieldProperties();
  }

  Future<void> _fetchUserFieldVisibility() async {
    LookupService lookupService = LookupService();
    await lookupService.getUserFieldVisibility();
  }

  Future<void> _fetchSystemCounty() async {
    LookupService lookupService = LookupService();
    await lookupService.getSystemCounty();
  }

  Future<void> _fetchCurrencyValue() async {
    LookupService lookupService = LookupService();
    await lookupService.getCurrencyValue();
  }

}
