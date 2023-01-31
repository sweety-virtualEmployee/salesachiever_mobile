import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/data/main_menu.dart';
import 'package:salesachiever_mobile/modules/0_home/models/home_menu_item.dart';

import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class HomeService {
  static List<HomeMenuItem> getMenuItems(Box<Locale> box) {
    final List<HomeMenuItem> menuItems = mainMenu
        .map(
          (e) => HomeMenuItem(
            key: e['key'],
            title: LangUtil.getString(e['context'], e['title']),
            subtitle: LangUtil.getString(e['context'], e['subtitle']),
            image: e['image'],
            hasChild: e['hasChild'],
            accessCode: e['accessCode']
          ),
        )
        .toList();

    return menuItems;
  }
}
