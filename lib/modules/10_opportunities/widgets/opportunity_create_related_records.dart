import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class OpportunityCreateRelatedRecords extends StatelessWidget {
  const OpportunityCreateRelatedRecords({
    Key? key,
    required deal,
    required Function onChange,
  })  : _deal = deal,
        _onChange = onChange,
        super(key: key);

  final _deal;
  final Function _onChange;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'NewAccountLinkButtonTextBlock.Text',
          ),
          onTap: () {
            if (_deal['DEAL_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => AddRelatedEntityScreen(
                  deal: {
                    'ID': _deal['DEAL_ID'],
                    'TEXT': _deal['DESCRIPTION'],
                  },
                  type: "opp",
                ),
              ),
            );
          },
          icon: Icon(context.platformIcons.add),
        ),
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'NewActionHistoryMenuTextBlock.Text',
          ),
          onTap: () {
            if (_deal['DEAL_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionTypeScreen(
                  action: {
                    'DEAL_ID': _deal['DEAL_ID'],
                    'DEAL_DESCRIPTION': _deal['DESCRIPTION']
                  },
                  popScreens: 2,
                ),
              ),
            );
          },
          icon: Icon(context.platformIcons.add),
        ),
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'ProjectEditWindow',
            'NewProject.Title',
          ),
          onTap: () async {
            if (_deal['DEAL_ID'] == null) return;

            if (_deal['ACCT_ID'] == null) {
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

              var result = await CompanyService()
                  .getRelatedEntity('company', _deal['ACCT_ID'], 'projects');

              var project = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => RelatedEntityScreen(
                    entity: _deal,
                    type: 'projects',
                    title: '',
                    list: result,
                    isSelectable: true,
                    isEditable: false,
                  ),
                ),
              );

              if (project != null) {
                _onChange('PROJECT_ID', project['ID'], false);
                _onChange('PROJECT_TITLE', project['TEXT'], false);
              }
            }
          },
          icon: Icon(context.platformIcons.add),
        ),
      ],
    );
  }
}
