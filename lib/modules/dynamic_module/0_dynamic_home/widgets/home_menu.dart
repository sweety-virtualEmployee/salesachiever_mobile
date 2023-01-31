import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/0_dynamic_home/widgets/home_menu_item.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';

import '../services/dynamic_home_services.dart';

class DynamicHomeMenu extends StatefulWidget {
  DynamicHomeMenu({
    required this.itemSelectedCallback,
    required this.selectedItem,
  });

  final ValueChanged<String> itemSelectedCallback;
  final String selectedItem;

  @override
  State<DynamicHomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<DynamicHomeMenu> {
  DynamicHomeService service = DynamicHomeService();

  @override
  void initState() {
    service.getHomeModule();
    super.initState();
  }

  // List<Widget> _generateMenu(Box<Locale> box) {
  //   List<Widget> list = [];
  //   final List<HomeMenuItem> menuItems = HomeService.getMenuItems(box);

  //   menuItems.forEach((menuItem) {
  //     if (menuItem.accessCode == null || AuthUtil.hasAccess(int.parse(menuItem.accessCode.toString()))) {
  //       DynamicPsaMenu psaMenuItem = new DynamicPsaMenu(
  //         title: menuItem.title,
  //         subtitle: menuItem.subtitle,
  //         image: menuItem.image,
  //         onTap: () => widget.itemSelectedCallback(menuItem.key),
  //         selected: widget.selectedItem == menuItem.key,
  //         hasChild: menuItem.hasChild,
  //       );

  //       list.add(psaMenuItem);
  //     }
  //   });

  //   return list;
  // }
  // List<Widget> _generateMenu(Box<Locale> box) {
  //   List<Widget> list = [];
  //   DynamicHomeService service = DynamicHomeService();
  //   final List<DynamicPsaMenu> menuItems = DynamicHomeService.getMenuItems();
  //   menuItems.forEach((menuItem) {
  //     if (menuItem.accessCode == null || AuthUtil.hasAccess(int.parse(menuItem.accessCode.toString()))) {
  //       DynamicPsaMenu psaMenuItem = new DynamicPsaMenu(
  //         title: menuItem.title,
  //         subtitle: menuItem.subtitle,
  //         image: menuItem.image,
  //         onTap: () => widget.itemSelectedCallback(menuItem.key),
  //         selected: widget.selectedItem == menuItem.key,
  //         hasChild: menuItem.hasChild,
  //       );
  //       list.add(psaMenuItem);
  //     }
  //   });
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   children: ListTile.divideTiles(
    //     context: context,
    //     tiles: _generateMenu(menuItems),
    //   ).toList(),
    // );
    return FutureBuilder(
        future: service.getHomeModule(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: Colors.black,
              ),
              itemCount: jsonDecode(jsonEncode(snapshot.data)).length,
              itemBuilder: (context, index) {
                return DynamicPsaMenu(
                  hasChild: true,
                  title: jsonDecode(jsonEncode(snapshot.data))[index]
                          ['MODULE_DESC']
                      .toString(),
                  // subtitle: menuItem.subtitle,
                  image: jsonDecode(jsonEncode(snapshot.data))[index]['IMAGE']
                      .toString(),
                  onTap: () => widget.itemSelectedCallback(
                    jsonDecode(jsonEncode(snapshot.data))[index]['KEY']
                        .toString(),
                  ),
                  selected: widget.selectedItem ==
                      jsonDecode(jsonEncode(snapshot.data))[index]['KEY']
                          .toString(),
                );
              },
            );
          }
          return Center(
            child: PsaProgressIndicator(),
          );
        });

    // return ValueListenableBuilder(
    //   valueListenable: Hive.box<Locale>('locales').listenable(),
    //   builder: (context, Box<Locale> box, widget) {
    //     return ListView(
    //       children: ListTile.divideTiles(
    //         context: context,
    //         tiles: _generateMenu(box),
    //       ).toList(),
    //     );
    //   },
    // );
  }
}
