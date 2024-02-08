import 'package:flutter/material.dart';

class DynamicTabProvide extends ChangeNotifier {
  Map<String, dynamic> _entity = {};
  Map<String, dynamic> _temporaryEntity = {};
  List<dynamic> _tabData = [];
  bool _readonly = true;


  Map<String, dynamic> get getEntity => _entity;
  Map<String, dynamic> get getTemporaryEntity => _temporaryEntity;
  List<dynamic> get getTabData => _tabData;
  bool get getReadOnly => _readonly;

   setEntity(Map<String, dynamic> newMap) async{
    _entity = newMap;
     notifyListeners();
  }
  setTemporaryEntity(Map<String, dynamic> newMap) async{
    _temporaryEntity = newMap;
    notifyListeners();
  }
   setData(List<dynamic> newData) {
     print("Set data $newData");
    _tabData = newData;
    notifyListeners();
  }

  setReadOnly(bool newRead) {
     print("new REad$newRead");
    _readonly = newRead;
    notifyListeners();
  }
}
