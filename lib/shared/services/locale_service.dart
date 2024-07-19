import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/shared/api/locale_api.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';

class LocaleService {
  Future<void> localizations(String localeId) async {
    final List<dynamic> response = await LocaleApi().localization(localeId);

    List<Locale> locales =
        response.map((locale) => Locale.fromJson(locale)).toList();

    await Hive.box<Locale>('locales').clear();
    await Hive.box<Locale>('locales').addAll(locales);
  }

  Future<void> updateSelectdLocalization(localeId) async {
    await LocaleApi().updateSelectdLocalization(localeId);
  }
}
