import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_add.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicProjectListScreen extends StatelessWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String listName;
  final bool isSelectable;

  const DynamicProjectListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.listName,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("listName${listName}");
    return PsaScaffold(
      title: LangUtil.getString('Entities', 'Project.Description')+" - List",
      body: PsaEntityListView(
        service: DynamicProjectService(listName: listName),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return DynamicProjectListItemWidget(
            entity: entity,
            refresh: refresh,
            isSelectable: isSelectable,
            isEditable: false,
          );
        },
        type: 'PROJECT',
        list: listName,
        sortBy: sortBy,
        filterBy: filterBy,
      ),
      action: PsaAddButton(
        onTap: () => Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) =>
                DynamicProjectAddScreen(
              project: {},
             // projectData: [],
              readonly: false,
            ),
          ),
        ),
      ),
    );
  }
}
