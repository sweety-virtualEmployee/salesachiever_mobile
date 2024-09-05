import 'package:flutter/material.dart';

class DynamicTabProvide extends ChangeNotifier {
  Map<String, dynamic> _companyEntity = {};
  Map<String, dynamic> _projectEntity = {};
  Map<String, dynamic> _contactEntity = {};
  Map<String, dynamic> _actionEntity = {};
  Map<String, dynamic> _opportunityEntity = {};
  Map<String, dynamic> _quotationEntity = {};
  bool _readonly = true;


  Map<String, dynamic> get getCompanyEntity => _companyEntity;
  Map<String, dynamic> get getProjectEntity => _projectEntity;
  Map<String, dynamic> get getContactEntity => _contactEntity;
  Map<String, dynamic> get getActionEntity => _actionEntity;
  Map<String, dynamic> get getOpportunityEntity => _opportunityEntity;
  Map<String, dynamic> get getQuotationEntity => _quotationEntity;
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



  setReadOnly(bool newRead) {
     print("new REad$newRead");
    _readonly = newRead;
    notifyListeners();
  }
}
