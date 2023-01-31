import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class PotentialCreateRelatedRecords extends StatelessWidget {
  const PotentialCreateRelatedRecords({
    Key? key,
    required deal,
  })  : _deal = deal,
        super(key: key);

  final _deal;

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
            if (_deal['DEAL_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => OpportunityEditScreen(
                  deal: {'DEAL_ID': _deal['DEAL_ID']},
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
            if (_deal['DEAL_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => AddRelatedEntityScreen(
                  account: {
                    'ID': _deal['DEAL_ID'],
                    'TEXT': _deal['DESCRIPTION']
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
            if (_deal['DEAL_ID'] == null) return;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionTypeScreen(
                  action: {
                    'DEAL_ID': _deal['DEAL_ID'],
                    'DESCRIPTION': _deal['DESCRIPTION'],
                    'ACCT_ID': _deal['DEAL_ID'],
                    'ACCTNAME': _deal['ACCTNAME']
                  },
                  popScreens: 2,
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
