import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActionSiteTierValueProvider with ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> groupedQuestions = {};
  int currentPage = 1;
  bool isLoading = false;
  bool isLastPage = false;
  int currentIndex = 0;

  Map<String, dynamic> get getGroupedQuestions => groupedQuestions;
  bool get getIsLoading => isLoading;
  bool get getIsLastPage => isLastPage;
  int get getCurrentPage => currentPage;
  int get getCurrentIndex => currentIndex;

  setGroupedQuestions(Map<String, List<Map<String, dynamic>>> newMap) async{
    print(newMap);
    groupedQuestions = newMap;
    notifyListeners();
  }

  setIsLastPage(bool newLastPage) {
    isLastPage = newLastPage;
    notifyListeners();

  }

  setIsLoading(bool newLoading) {
    isLoading = newLoading;
  }

  setCurrentPage(int newCurrentPage) {
    currentPage = newCurrentPage;
    //notifyListeners();

  }

  setCurrentIndex(int newCurrentIndex) {
    currentIndex = newCurrentIndex;
  }

  clearData(){
    setCurrentPage(1);
    setGroupedQuestions({});
  }
}
