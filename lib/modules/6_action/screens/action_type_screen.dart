import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/data/action_types.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_tab_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionTypeScreen extends StatelessWidget {
  const ActionTypeScreen({
    Key? key,
    this.action,
    this.listType,
    required this.popScreens,
  }) : super(key: key);

  final dynamic action;
  final int popScreens;
  final String? listType;

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString('Application', 'MainMenu.CreateAction.Header'),
      body: ListView(
        itemExtent: 50,
        children: ListTile.divideTiles(
          context: context,
          tiles: _generateListItems(context),
        ).toList(),
      ),
    );
  }

  _generateListItems(BuildContext context) {
    return actionTypes
        .map(
          (e) => InkWell(
            child: PsaListItem(
              title: LangUtil.getString('Entities', e['itemId']!),
              icon: e['icon'],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicTabScreen(
                      entity: {"CLASS":e["class"]},
                      title: "Add New Action",
                      readonly: true,
                      moduleId: "009",
                      entityType:listType??"",
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            },
          ),
        )
        .toList();
  }
}
