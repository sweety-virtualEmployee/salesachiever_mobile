import 'package:flutter/material.dart';

class DynamicTabProvide extends ChangeNotifier {
  Map<String, dynamic> _entity = {};
  List<dynamic> _tabData = [];
  bool _readonly = true;


  Map<String, dynamic> get getEntity => _entity;
  List<dynamic> get getTabData => _tabData;
  bool get getReadOnly => _readonly;

   setEntity(Map<String, dynamic> newMap) async{
     print("set entity${newMap}");
    _entity = newMap;
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
