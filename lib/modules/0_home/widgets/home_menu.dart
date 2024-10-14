import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salesachiever_mobile/modules/0_home/services/home_service.dart';
import 'package:salesachiever_mobile/modules/0_home/widgets/home_menu_item.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';

class HomeMenu extends StatelessWidget {
  HomeMenu({
    required this.itemSelectedCallback,
    required this.selectedItem,
  });

  final ValueChanged<String> itemSelectedCallback;
  final String selectedItem;

  List<Widget> _generateMenu(Box<Locale> box) {
    List<Widget> list = [];
    final List menuItems = HomeService.getMenuItems(box);
    menuItems.forEach((menuItem) {
      print("menu item${menuItem.title}");
      if (menuItem.accessCode == null || AuthUtil.hasAccess(int.parse(menuItem.accessCode.toString()))) {
        PsaMainMenuItem psaMenuItem = new PsaMainMenuItem(
          title: menuItem.title,
          subtitle: menuItem.subtitle,
          image: menuItem.image,
          onTap: () => itemSelectedCallback(menuItem.key),
          selected: selectedItem == menuItem.key,
          hasChild: menuItem.hasChild,
        );
        list.add(psaMenuItem);
      }
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   children: ListTile.divideTiles(
    //     context: context,
    //     tiles: _generateMenu(menuItems),
    //   ).toList(),
    // );

    return ValueListenableBuilder(
      valueListenable: Hive.box<Locale>('locales').listenable(),
      builder: (context, Box<Locale> box, widget) {
        return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: _generateMenu(box),
          ).toList(),
        );
      },
    );
  }
}
