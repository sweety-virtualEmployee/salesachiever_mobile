import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class CompanyCreateRelatedRecords extends StatelessWidget {
  const CompanyCreateRelatedRecords({
    Key? key,
    required company,
  })  : _company = company,
        super(key: key);

  final _company;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'AccountEditWindow',
            'NewContactButtonTextBlock.Text',
          ),
          onTap: () {
            if (_company['ACCT_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ContactEditScreen(
                  contact: {'ACCT_ID': _company['ACCT_ID']},
                  readonly: false,
                ),
              ),
            );
          },
          icon: Icon(context.platformIcons.add),
        ),
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'AccountEditWindow',
            'NewProjectLinkButtonTextBlock.Text',
          ),
          onTap: () { 
            if (_company['ACCT_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => AddRelatedEntityScreen(
                  account: {
                    'ID': _company['ACCT_ID'],
                    'TEXT': _company['ACCTNAME']
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
            'AccountEditWindow',
            'NewPlannedActionMenuTextBlock.Text',
          ),
          onTap: () {
            if (_company['ACCT_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionTypeScreen(
                  action: {
                    'ACCT_ID': _company['ACCT_ID'],
                    'ACCTNAME': _company['ACCTNAME']
                  },
                  popScreens: 2,
                ),
              ),
            );
          },
          icon: Icon(context.platformIcons.add),
        ),
        /*if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          PsaButtonRow(
            isVisible: false,
            title: LangUtil.getString(
              'ProjectEditWindow',
              'NewOpportunityButtonTextBlock.Text',
            ),
            onTap: () {
              if (_company['ACCT_ID'] == null) return;

              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => AddRelatedEntityScreen(
                    deal: {
                      'ID': _company['DEAL_ID'],
                      'TEXT': _company['DEAL_NAME'],
                    },
                    account: {
                      'ID': _company['ACCT_ID'],
                      'TEXT': _company['ACCTNAME']
                    },
                    type: "opp",
                  ),
                ),
              );
            },
            icon: Icon(context.platformIcons.add),
          )*/
      ],
    );
  }
}
