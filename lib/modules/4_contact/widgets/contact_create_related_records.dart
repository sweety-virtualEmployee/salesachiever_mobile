import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ContactCreateRelatedRecords extends StatelessWidget {
  const ContactCreateRelatedRecords({
    Key? key,
    required contact,
  })  : _contact = contact,
        super(key: key);

  final _contact;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'Entities',
            'Project.Create.Text',
          ),
          onTap: () async {
            if (_contact['CONT_ID'] == null) return;

            var _company =
                await CompanyService().getEntity(_contact['ACCT_ID']);

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => AddRelatedEntityScreen(
                  account: {
                    'ID': _company.data['ACCT_ID'],
                    'TEXT': _company.data['ACCTNAME']
                  },
                  contact: {
                    'ID': _contact['CONT_ID'],
                    'TEXT': '${_contact['FIRSTNAME']} ${_contact['SURNAME']}'
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
            'Entities',
            'Action.Create.Text',
          ),
          onTap: () async {
            if (_contact['CONT_ID'] == null) return;

            // var _company =
            //     await CompanyService().getEntity(_contact['ACCT_ID']);

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionTypeScreen(
                  action: {
                    'ACCT_ID': _contact['ACCT_ID'],
                    'ACCTNAME': _contact['ACCTNAME'],
                    'CONT_ID': _contact['CONT_ID'],
                    'CONTACT_NAME':
                        '${_contact['FIRSTNAME']} ${_contact['SURNAME']}',
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
            onTap: () async {
              if (_contact['CONT_ID'] == null) return;

              var _company =
                  await CompanyService().getEntity(_contact['ACCT_ID']);

              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => AddRelatedEntityScreen(
                    account: {
                      'ID': _company.data['ACCT_ID'],
                      'TEXT': _company.data['ACCTNAME']
                    },
                    contact: {
                      'ID': _contact['CONT_ID'],
                      'TEXT': '${_contact['FIRSTNAME']} ${_contact['SURNAME']}'
                    },
                    type: 'opp',
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
