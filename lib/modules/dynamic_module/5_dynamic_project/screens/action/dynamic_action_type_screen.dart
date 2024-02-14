import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/data/action_types.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_tab.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicActionTypeScreen extends StatelessWidget {
  const DynamicActionTypeScreen({
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
              print("Action$listType");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicActionTabScreen(
                      entity: {"CLASS":e["class"]},
                      title: "Add New Action",
                      readonly: false,
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
