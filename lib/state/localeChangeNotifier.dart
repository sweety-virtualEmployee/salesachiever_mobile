import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';

class LocaleChangeNotifier extends ChangeNotifier {
  final List<Locale> _locales = [];

  UnmodifiableListView<Locale> get locales => UnmodifiableListView(_locales);

  void updateLocale(List<Locale> locales) {
    _locales.clear();
    _locales.addAll(locales);
    notifyListeners();
  }
}
