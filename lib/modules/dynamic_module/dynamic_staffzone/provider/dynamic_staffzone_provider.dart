import 'package:flutter/material.dart';

class DynamicStaffZoneProvider extends ChangeNotifier {

  List<dynamic> _staffZone = [];
  bool isLoading = false;
  bool isLastPage = false;
  int pageNumber = 1;

  List<dynamic> get getStaffZoneEntity => _staffZone;
  bool get getIsLoading => isLoading;
  bool get getIsLastPage => isLastPage;
  int get getPageNumber => pageNumber;

  setIsLoading(bool newValue) async{
    isLoading = newValue;
  }
  setIsLastPage(bool isLastPageValue) async{
    isLastPage = isLastPageValue;
  }
  setPageNumber(int pageNo) async{
    pageNumber = pageNo;
  }
  setStaffZoneEntity(List<dynamic> newData) async{
    print("new dtaa");
    print(newData.length);
    _staffZone.addAll(newData);
    notifyListeners();
  }

  void clearData() {
    _staffZone.clear();
    isLoading = false;
    isLastPage = false;
    pageNumber = 1;
  }

}