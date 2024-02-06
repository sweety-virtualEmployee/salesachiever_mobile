import 'package:flutter/material.dart';

class DynamicTabProvide extends ChangeNotifier {
  Map<String, dynamic> _entity = {};

  Map<String, dynamic> get getEntity => _entity;

   setEntity(Map<String, dynamic> newMap) {
     print("set entity${newMap}");
    _entity = newMap;
    notifyListeners();
  }
}
