import 'package:flutter/material.dart';

class DynamicStaffZoneProvider extends ChangeNotifier {

  List<dynamic> _staffZone = [];
  bool isLoading = false;

  List<dynamic> get getStaffZoneEntity => _staffZone;
  bool get getIsLoading => isLoading;

  setIsLoading(bool newValue) async{
    isLoading = newValue;
  }
  setStaffZoneEntity(List<dynamic> newData) async{
    _staffZone = newData;
    notifyListeners();
  }
}