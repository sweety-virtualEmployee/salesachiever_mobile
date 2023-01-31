import 'package:hive/hive.dart';

part 'locale.g.dart';

@HiveType(typeId: 0)
class Locale {
  @HiveField(0)
  final String contextId;

  @HiveField(1)
  final String itemId;

  @HiveField(2)
  final String localeId;

  @HiveField(3)
  final String displayValue;

  Locale(this.contextId, this.itemId, this.localeId, this.displayValue);

  factory Locale.fromJson(Map<String, dynamic> json) {
    Locale locale = new Locale(
      json['ContextId'],
      json['ItemId'],
      json['LocaleId'],
      json['DisplayValue'],
    );

    return locale;
  }

  Map<String, dynamic> toJson() {
    return {
      'ContextId': contextId,
      'ItemId': itemId,
      'LocaleId': localeId,
      'DisplayValue': displayValue,
    };
  }
}
