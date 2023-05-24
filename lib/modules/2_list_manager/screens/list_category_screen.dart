import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/screens/list_manager_list_screen.dart';

import 'package:salesachiever_mobile/shared/widgets/psa_menu_item.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCategoryScreen extends StatelessWidget {
  const ListCategoryScreen({Key? key}) : super(key: key);

  List<Widget> _generateListItems(context) {
    List<dynamic> _listItems = [
      {'contextId': 'LIST_CATEGORY.CATEGORY_ID', 'itemId': 'AC'},
      {'contextId': 'LIST_CATEGORY.CATEGORY_ID', 'itemId': 'CN'},
      {'contextId': 'LIST_CATEGORY.CATEGORY_ID', 'itemId': 'DI'},
      {'contextId': 'LIST_CATEGORY.CATEGORY_ID', 'itemId': 'PJ'}
    ];

    if (AuthUtil.hasAccess(int.parse(ACCESS_CODES['OPPORTUNTIY'].toString()))) {
      _listItems
          .add({'contextId': 'LIST_CATEGORY.CATEGORY_ID', 'itemId': 'DE'});
    }

    return _listItems
        .map(
          (e) => PsaMenuItem(
            title: LangUtil.getString(e['contextId'], e['itemId']),
            onTap: () => Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ListManagerListScreen(
                  title: LangUtil.getString(e['contextId'], e['itemId']),
                  categoryCode: e['itemId'],
                ),
              ),
            ),
            hasChild: true,
          ),
        )
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    print("hy");
    return PsaScaffold(
      title: LangUtil.getString('Application', 'MainMenu.ListManager.Header'),
      body: ListView(
        itemExtent: 50,
        children: ListTile.divideTiles(
          context: context,
          tiles: _generateListItems(context),
        ).toList(),
      ),
    );
  }
}
