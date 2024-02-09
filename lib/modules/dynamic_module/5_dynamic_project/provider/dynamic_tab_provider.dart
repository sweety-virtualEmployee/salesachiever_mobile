import 'package:flutter/material.dart';

class DynamicTabProvide extends ChangeNotifier {
  Map<String, dynamic> _companyEntity = {};
  Map<String, dynamic> _projectEntity = {};
  Map<String, dynamic> _contactEntity = {};
  Map<String, dynamic> _actionEntity = {};
  Map<String, dynamic> _opportunityEntity = {};
  Map<String, dynamic> _quotationEntity = {};
  List<dynamic> _temporaryTabData = [];
  List<dynamic> _tabCompanyData = [];
  List<dynamic> _tabContactData = [];
  List<dynamic> _tabProjectData = [];
  List<dynamic> _tabActionData = [];
  List<dynamic> _tabOpportunityData = [];
  List<dynamic> _tabQuotationData = [];
  bool _readonly = true;


  Map<String, dynamic> get getCompanyEntity => _companyEntity;
  Map<String, dynamic> get getProjectEntity => _projectEntity;
  Map<String, dynamic> get getContactEntity => _contactEntity;
  Map<String, dynamic> get getActionEntity => _actionEntity;
  Map<String, dynamic> get getOpportunityEntity => _opportunityEntity;
  Map<String, dynamic> get getQuotationEntity => _quotationEntity;
  List<dynamic> get getTemporaryTabData => _temporaryTabData;
  List<dynamic> get getCompanyTabData => _tabCompanyData;
  List<dynamic> get getContactTabData => _tabContactData;
  List<dynamic> get getActionTabData => _tabActionData;
  List<dynamic> get getProjectTabData => _tabProjectData;
  List<dynamic> get getOpportunityTabData => _tabOpportunityData;
  List<dynamic> get getQuotationTabData => _tabQuotationData;
  bool get getReadOnly => _readonly;

   setCompanyEntity(Map<String, dynamic> newMap) async{
    _companyEntity = newMap;
     notifyListeners();
  }
  setProjectEntity(Map<String, dynamic> newMap) async{
    _projectEntity = newMap;
    notifyListeners();
  }
  setContactEntity(Map<String, dynamic> newMap) async{
    _contactEntity = newMap;
    notifyListeners();
  }
  setActionEntity(Map<String, dynamic> newMap) async{
    _actionEntity = newMap;
    notifyListeners();
  }
  setOpportunityEntity(Map<String, dynamic> newMap) async{
    _opportunityEntity = newMap;
    notifyListeners();
  }
  setQuotationEntity(Map<String, dynamic> newMap) async{
    _quotationEntity = newMap;
    notifyListeners();
  }

  setTemporaryData(List<dynamic> newData) {
    _temporaryTabData = newData;
    notifyListeners();
  }

   setCompanyData(List<dynamic> newData) {
    _tabCompanyData = newData;
    notifyListeners();
  }
  setContactData(List<dynamic> newData) {
    _tabContactData = newData;
    notifyListeners();
  }
  setActionData(List<dynamic> newData) {
    _tabActionData = newData;
    notifyListeners();
  }
  setProjectData(List<dynamic> newData) {
    _tabProjectData = newData;
    notifyListeners();
  }
  setOpportunityData(List<dynamic> newData) {
    _tabOpportunityData = newData;
    notifyListeners();
  }
  setQuotationData(List<dynamic> newData) {
    _tabQuotationData = newData;
    notifyListeners();
  }

  setReadOnly(bool newRead) {
     print("new REad$newRead");
    _readonly = newRead;
    notifyListeners();
  }
}
