import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/associated_entity_widget.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicQuotationViewRelatedRecords extends StatelessWidget {
  DynamicQuotationViewRelatedRecords({
    Key? key,
    required quotation,
    required quotationId,
    required readonly,
    required onChange,
  })  : _quotation = quotation,
        _quotationId = quotationId,
        _onChange = onChange,
        super(key: key);

  final dynamic _quotation;
  final String _quotationId;
  final Function _onChange;

  @override
  Widget build(BuildContext context) {
    print("quotation check ${_quotation['ACCT_ID']}");
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        AssociatedEntityWidget(
          isRequired: true,
            title: LangUtil.getString(
              'Entities',
              'Account.Description',
            ),
            entity: {'ID': _quotation['ACCT_ID'], 'TEXT': _quotation['ACCTNAME']},
            onTap: () async {
              if (_quotation['ACCT_ID'] != null) {
                context.loaderOverlay.show();

                var company =
                await CompanyService().getEntity(_quotation['ACCT_ID']);

                await Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => CompanyEditScreen(
                        company: company.data, readonly: false),
                  ),
                );

                context.loaderOverlay.hide();
              } else if (_quotation['DEAL_ID'] != null) {
                context.loaderOverlay.show();

                var result = await CompanyService().getRelatedEntity(
                    'Opportunity',
                    _quotation['DEAL_ID'],
                    'companies?pageSize=1000&pageNumber=1');

                context.loaderOverlay.hide();

                var company = await Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => RelatedEntityScreen(
                      entity: _quotation,
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
              } else {
                if (_quotation['ACTION_ID'] != null) return;

                if (_quotation['PROJECT_ID'] == null) {
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
                      // {'KEY': 'DESCRIPTION', 'VALUE': company['TEXT']},
                    ]);
                } else {
                  context.loaderOverlay.show();

                  var result = await CompanyService().getRelatedEntity(
                      'project', _quotation['PROJECT_ID'], 'companies');

                  context.loaderOverlay.hide();

                  var company = await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => RelatedEntityScreen(
                        entity: _quotation,
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
              }
            }),
        AssociatedEntityWidget(
            title: LangUtil.getString(
              'Entities',
              'Contact.Description',
            ),
            entity: {
              'ID': _quotation['CONT_ID'],
              'TEXT': _quotation['CONTACT_NAME'],
            },
            onTap: () async {
              if (_quotation['CONT_ID'] != null) {
                context.loaderOverlay.show();

                var contact =
                await ContactService().getEntity(_quotation['CONT_ID']);

                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => ContactEditScreen(
                        contact: contact.data, readonly: false),
                  ),
                );

                context.loaderOverlay.hide();
              } else {
                if (_quotation['ACCT_ID'] == null) {
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

                  var result = await CompanyService().getRelatedEntity(
                      'company', _quotation['ACCT_ID'], 'contacts');

                  context.loaderOverlay.hide();

                  var contact = await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => RelatedEntityScreen(
                        entity: _quotation,
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
              }
            }),
        AssociatedEntityWidget(
          title: LangUtil.getString(
            'Entities',
            'Project.Description',
          ),
          entity: {
            'ID': _quotation['DEAL_ID'] != null && _quotation['ACCT_ID'] == null
                ? null
                : _quotation['PROJECT_ID'],
            'TEXT': _quotation['DEAL_ID'] != null && _quotation['ACCT_ID'] == null
                ? null
                : _quotation['PROJECT_TITLE']
          },
          onTap: () async {
            if (_quotation['PROJECT_ID'] != null) {
              context.loaderOverlay.show();

              var project =
              await ProjectService().getEntity(_quotation['PROJECT_ID']);

              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) =>
                      ProjectEditScreen(project: project.data, readonly: false),
                ),
              );

              context.loaderOverlay.hide();
            } else {
              if (_quotation['ACCT_ID'] == null) {
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

                var result = await CompanyService().getRelatedEntity(
                    'company', _quotation['ACCT_ID'], 'projects');

                context.loaderOverlay.hide();

                var project = await Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => RelatedEntityScreen(
                      entity: _quotation,
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
            }
          },
        ),
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          AssociatedEntityWidget(
            title: LangUtil.getString(
              'ACTION',
              'DEAL_ID',
            ),
            entity: {
              'ID': _quotation['DEAL_ID'],
              'TEXT': _quotation['DEAL_DESCRIPTION']
            },
            onTap: () async {
              if (_quotation['DEAL_ID'] != null) {
                context.loaderOverlay.show();

                var deal =
                await OpportunityService().getEntity(_quotation['DEAL_ID']);

                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) =>
                        OpportunityEditScreen(deal: deal.data, readonly: false),
                  ),
                );

                context.loaderOverlay.hide();
              } else {
                if (_quotation['ACCT_ID'] == null) {
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
                    ]);
                } else {
                  context.loaderOverlay.show();

                  var result = await CompanyService().getRelatedEntity(
                      'company',
                      _quotation['ACCT_ID'],
                      'OpportunityLinks?pageSize=1000&pageNumber=1');

                  context.loaderOverlay.hide();

                  var deal = await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => RelatedEntityScreen(
                        entity: _quotation,
                        type: 'OpportunityLinks?pageSize=1000&pageNumber=1',
                        title: '',
                        list: result,
                        isSelectable: true,
                        isEditable: false,
                      ),
                    ),
                  );

                  if (deal != null)
                    _onChange([
                      {'KEY': 'DEAL_ID', 'VALUE': deal['ID']},
                      {'KEY': 'DEAL_DESCRIPTION', 'VALUE': deal['TEXT']},
                    ]);
                }
              }
            },
          ),
        RelatedEntityWidget(
          entity: _quotation,
          entityType: 'quotation',
          title: LangUtil.getString(
            'QuotationEditWindow',
            'ActionTab.Header',
          ),
          id: _quotationId,
          relatedEntityType: 'actions',
          isEditable: false,
        ),
      ],
    );
  }
}
