import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesachiever_mobile/state/localeChangeNotifier.dart';

final localeChangeNotifierProvider =
    ChangeNotifierProvider.autoDispose<LocaleChangeNotifier>((ref) {
  return LocaleChangeNotifier();
});
