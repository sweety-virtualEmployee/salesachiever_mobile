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



  @override
  Widget build(BuildContext context) {

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
  }
}
