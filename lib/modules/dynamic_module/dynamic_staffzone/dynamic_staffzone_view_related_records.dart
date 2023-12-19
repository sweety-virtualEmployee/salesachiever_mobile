import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/associated_entity_widget.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicStaffZoneDataViewRelatedRecords extends StatelessWidget {
  DynamicStaffZoneDataViewRelatedRecords({
    Key? key,
    required staffZone,
    required staffZoneId,
    required readonly,
    required onChange,
  })  : _staffZone = staffZone,
        _staffZoneId = staffZoneId,
        onChange = onChange,
        super(key: key);

  final dynamic _staffZone;
  final String _staffZoneId;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        AssociatedEntityWidget(
            isRequired: false,
            title: LangUtil.getString(
              'Entities',
              'Account.Description',
            ),
            entity: {'ID': _staffZone['ACCT_ID'], 'TEXT': _staffZone['ACCTNAME']},
            onTap: () async {
              var company = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => CompanyListScreen(
                    listName: 'acsrch_api',
                    isSelectable: true,
                  ),
                ),
              );

              print("comapaefbjesdghn$company");

              if (company != null)
                onChange(
                  'ACCT_ID',
                  company['ID'],
                  true, // Replace with the actual value for isRequired
                );
              onChange(
                'ACCTNAME',
                company['TEXT'],
                true,
              );
            }),
        AssociatedEntityWidget(
            title: LangUtil.getString(
              'Entities',
              'Contact.Description',
            ),
            entity: {
              'ID': _staffZone['CONT_ID'],
              'TEXT': _staffZone['FIRSTNAME'],
            },
            onTap: () async {
              var contact = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => ContactListScreen(
                    listName: 'cont_api',
                    isSelectable: true,
                  ),
                ),
              );

              if (contact != null)
                onChange(
                  'CONT_ID',
                  contact['ID'],
                  true,
                );
              onChange(
                'FIRSTNAME',
                contact['TEXT'],
                true,
              );
            }),
        AssociatedEntityWidget(
          title: LangUtil.getString(
            'Entities',
            'Project.Description',
          ),
          entity: {
            'ID':  _staffZone['PROJECT_ID'],
            'TEXT':  _staffZone['PROJECT_TITLE']
          },
          onTap: () async {
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

                if (project != null)
                  onChange(
                    'PROJECT_ID',
                    project['ID'],
                    true, // Replace with the actual value for isRequired
                  );
                onChange(
                  'PROJECT_TITLE',
                  project['TEXT'],
                  true, // Replace with the actual value for isRequired
                );
          },
        ),
      ],
    );
  }
}
