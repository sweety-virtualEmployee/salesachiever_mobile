import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionCreateRelatedRecords extends StatelessWidget {
  const ActionCreateRelatedRecords({
    Key? key,
    required action,
    required readonly,
    required onChange,
  })  : _action = action,
        _onChange = onChange,
        _readonly = readonly,
        super(key: key);

  final dynamic _action;
  final bool _readonly;
  final Function _onChange;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
          isVisible: false,
          title: 'Add new Company',
          onTap: () async {
            if (_readonly) return;

            if (_action['ACTION_ID'] != null) return;

            if (_action['PROJECT_ID'] == null) {
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

              if (company != null)
                _onChange([
                  {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                  {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                  {'KEY': 'CONT_ID', 'VALUE': null},
                  {'KEY': 'CONTACT_NAME', 'VALUE': null},
                  {'KEY': 'PROJECT_ID', 'VALUE': null},
                  {'KEY': 'PROJECT_TITLE', 'VALUE': null},
                  {'KEY': 'DESCRIPTION', 'VALUE': company['TEXT']},
                ]);
            } else {
              context.loaderOverlay.show();

              var result = await CompanyService().getRelatedEntity(
                  'project', _action['PROJECT_ID'], 'companies');

              context.loaderOverlay.hide();

              var company = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => RelatedEntityScreen(
                    entity: _action,
                    type: 'companies',
                    title: '',
                    list: result,
                    isSelectable: true,
                    isEditable: false,
                  ),
                ),
              );

              if (company != null)
                _onChange([
                  {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                  {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                ]);
            }
          },
          icon: Icon(context.platformIcons.add),
        ),
        PsaButtonRow(
          isVisible: false,
          title: 'Add New Contact',
          onTap: () async {
            if (_readonly) return;

            if (_action['ACCT_ID'] == null) {
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
                _onChange([
                  {'KEY': 'ACCT_ID', 'VALUE': contact['DATA']['ACCT_ID']},
                  {'KEY': 'ACCTNAME', 'VALUE': contact['DATA']['ACCTNAME']},
                  {'KEY': 'CONT_ID', 'VALUE': contact['ID']},
                  {'KEY': 'CONTACT_NAME', 'VALUE': contact['TEXT']},
                ]);
            } else {
              context.loaderOverlay.show();

              var result = await CompanyService()
                  .getRelatedEntity('company', _action['ACCT_ID'], 'contacts');

              context.loaderOverlay.hide();

              var contact = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => RelatedEntityScreen(
                    entity: _action,
                    type: 'contacts',
                    title: '',
                    list: result,
                    isSelectable: true,
                    isEditable: false,
                  ),
                ),
              );

              if (contact != null)
                _onChange([
                  {'KEY': 'ACCT_ID', 'VALUE': contact['DATA']['ACCT_ID']},
                  {'KEY': 'ACCTNAME', 'VALUE': contact['DATA']['ACCTNAME']},
                  {'KEY': 'CONT_ID', 'VALUE': contact['ID']},
                  {'KEY': 'CONTACT_NAME', 'VALUE': contact['TEXT']},
                ]);
            }
          },
          icon: Icon(context.platformIcons.add),
        ),
        PsaButtonRow(
          isVisible: false,
          title: 'Add new Project',
          onTap: () async {
            if (_readonly) return;

            if (_action['ACCT_ID'] == null) {
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
                _onChange([
                  {'KEY': 'PROJECT_ID', 'VALUE': project['ID']},
                  {'KEY': 'PROJECT_TITLE', 'VALUE': project['TEXT']},
                ]);
            } else {
              context.loaderOverlay.show();

              var result = await CompanyService()
                  .getRelatedEntity('company', _action['ACCT_ID'], 'projects');

              context.loaderOverlay.hide();

              var project = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => RelatedEntityScreen(
                    entity: _action,
                    type: 'projects',
                    title: '',
                    list: result,
                    isSelectable: true,
                    isEditable: false,
                  ),
                ),
              );

              if (project != null)
                _onChange([
                  {'KEY': 'PROJECT_ID', 'VALUE': project['ID']},
                  {'KEY': 'PROJECT_TITLE', 'VALUE': project['TEXT']},
                ]);
            }
          },
          icon: Icon(context.platformIcons.add),
        ),
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          PsaButtonRow(
            isVisible: false,
            title: LangUtil.getString(
                'OpportunityEditWindow', 'NewOpportunity.Title'),
            onTap: () async {
              if (_readonly) return;

              if (_action['ACCT_ID'] == null) {
                var deal = await Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => OpportunityListScreen(
                      listName: 'ALLDE',
                      isSelectable: true,
                    ),
                  ),
                );

                if (deal != null)
                  _onChange([
                    {'KEY': 'DEAL_ID', 'VALUE': deal['ID']},
                    {'KEY': 'DEAL_DESCRIPTION', 'VALUE': deal['TEXT']},
                    {'KEY': 'CONT_ID', 'VALUE': null},
                    {'KEY': 'CONTACT_NAME', 'VALUE': null},
                    {'KEY': 'PROJECT_ID', 'VALUE': null},
                    {'KEY': 'PROJECT_TITLE', 'VALUE': null},
                  ]);
              } else {
                context.loaderOverlay.show();

                var result = await CompanyService().getRelatedEntity(
                    'company',
                    _action['ACCT_ID'],
                    'OpportunityLinks?pageSize=1000&pageNumber=1');

                context.loaderOverlay.hide();

                var company = await Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => RelatedEntityScreen(
                      entity: _action,
                      type: 'OpportunityLinks?pageSize=1000&pageNumber=1',
                      title: '',
                      list: result,
                      isSelectable: true,
                      isEditable: false,
                    ),
                  ),
                );

                if (company != null)
                  _onChange([
                    {'KEY': 'DEAL_ID', 'VALUE': company['ID']},
                    {'KEY': 'DEAL_DESCRIPTION', 'VALUE': company['TEXT']},
                  ]);
              }
            },
            icon: Icon(context.platformIcons.add),
          ),
      ],
    );
  }
}
