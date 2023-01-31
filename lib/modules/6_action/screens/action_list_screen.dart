import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_list_item.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionListScreen extends StatelessWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String listName;

  const ActionListScreen(
      {Key? key, this.sortBy, this.filterBy, required this.listName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString('Entities', 'Action.Description.Plural'),
      body: PsaEntityListView(
        service: ActionService(listName: listName),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return ActionListItemWidget(entity: entity, refresh: refresh);
        },
        type: 'ACTION',
        list: listName,
        sortBy: sortBy,
        filterBy: filterBy,
      ),
      action: PsaAddButton(
        onTap: () => Navigator.pushNamed(context, '/action/type'),
      ),
    );
  }
}
