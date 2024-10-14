import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/associated_entity_widget.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class OpportunityViewRelatedRecords extends StatelessWidget {
  const OpportunityViewRelatedRecords({
    Key? key,
    required entity,
    required dealId,
    required Function onChange,
  })  : _entity = entity,
        _dealId = dealId,
        _onChange = onChange,
        super(key: key);

  final dynamic _entity;
  final String _dealId;
  final Function _onChange;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'Opportunity',
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'AccountsTab.Header',
          ),
          id: _dealId,
          relatedEntityType: 'companies?pageSize=1000&pageNumber=1',
          isEditable: true,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'Opportunity',
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'ActionTab.Header',
          ),
          id: _dealId,
          relatedEntityType: 'actions?pageSize=1000&pageNumber=1',
          isEditable: false,
        ),
        AssociatedEntityWidget(
          title: LangUtil.getString(
            'AccountEditWindow',
            'ProjectsTab.Header',
          ),
          entity: {
            'ID': _entity['PROJECT_ID'],
            'TEXT': _entity['PROJECT_TITLE']
          },
          onTap: () async {
            if (_entity['PROJECT_ID'] == null) {
              var project = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => ProjectListScreen(
                    listName: 'pjfilt_api',
                    isSelectable: true,
                  ),
                ),
              );

              if (project != null) {
                _onChange('PROJECT_ID', project['ID'], false);
                _onChange('PROJECT_TITLE', project['TEXT'], false);
              }
            } else {
              var project =
                  await ProjectService().getEntity(_entity['PROJECT_ID']);

              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => ProjectEditScreen(
                    project: project.data,
                    readonly: false,
                  ),
                ),
              );

              if (project != null) {
                _onChange('PROJECT_ID', project['ID'], false);
                _onChange('PROJECT_TITLE', project['TEXT'], false);
              }
            }
          },
        ),
      ],
    );
  }
}
