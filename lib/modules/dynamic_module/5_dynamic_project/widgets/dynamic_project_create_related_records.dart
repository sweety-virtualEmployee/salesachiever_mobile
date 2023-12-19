import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicProjectCreateRelatedRecords extends StatelessWidget {
  const DynamicProjectCreateRelatedRecords({
    Key? key,
    required project,
  })  : _project = project,
        super(key: key);

  final _project;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'ProjectEditWindow',
            'NewAccountLinkButtonTextBlock.Text',
          ),
          onTap: () {
            if (_project['PROJECT_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => AddRelatedEntityScreen(
                  project: {
                    'ID': _project['PROJECT_ID'],
                    'TEXT': _project['PROJECT_TITLE']
                  },
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
            'NewActionMenuTextBlock.Text',
          ),
          onTap: () {
            if (_project['PROJECT_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionTypeScreen(
                  action: {
                    'PROJECT_ID': _project['PROJECT_ID'],
                    'PROJECT_TITLE': _project['PROJECT_TITLE'],
                  },
                  popScreens: 2,
                ),
              ),
            );
          },
          icon: Icon(context.platformIcons.add),
        ),
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          PsaButtonRow(
            isVisible: false,
            title: LangUtil.getString(
              'ProjectEditWindow',
              'NewOpportunityButtonTextBlock.Text',
            ),
            onTap: () {
              if (_project['PROJECT_ID'] == null) return;
                Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionTypeScreen(
                  action: {
                    'PROJECT_ID': _project['PROJECT_ID'],
                    'PROJECT_TITLE': _project['PROJECT_TITLE'],
                  },
                  popScreens: 2,
                ),
              ),
            );

              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => OpportunityEditScreen(
                    deal: {},
                    project: _project,
                    readonly: false,
                  ),
                ),
              );
            },
            icon: Icon(context.platformIcons.add),
          )
      ],
    );
  }
}
