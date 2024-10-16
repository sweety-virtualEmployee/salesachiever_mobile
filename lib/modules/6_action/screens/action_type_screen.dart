import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/action_types.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_edit_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionTypeScreen extends StatelessWidget {
  const ActionTypeScreen({
    Key? key,
    this.action,
    required this.popScreens,
  }) : super(key: key);

  final dynamic action;
  final int popScreens;

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
            platformPageRoute(
              context: context,
              builder: (BuildContext context) {
                if (action != null) action['CLASS'] = e['class'];

                return ActionEditScreen(
                  action: action != null && e['class'] != 'G'
                      ? action
                      : {
                    'CLASS': e['class'],
                  },
                  readonly: false,
                  popScreens: popScreens,
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
