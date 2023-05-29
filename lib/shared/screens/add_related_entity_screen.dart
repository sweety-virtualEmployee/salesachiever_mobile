import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_list_picker.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_related_entity_row.dart';  
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class AddRelatedEntityScreen extends StatefulWidget {
  final String? linkId;
  final String? multiId;
  final dynamic account;
  final dynamic contact;
  final dynamic project;
  final dynamic role;
  final dynamic deal;
  final String? type;

  AddRelatedEntityScreen(
      {Key? key,
      this.linkId,
      this.multiId,
      this.account,
      this.contact,
      this.project,
      this.role,
      this.deal,
      this.type})
      : super(key: key);

  @override
  _AddRelatedEntityScreenState createState() => _AddRelatedEntityScreenState();
}

class _AddRelatedEntityScreenState extends State<AddRelatedEntityScreen> {
  dynamic project;
  dynamic account;
  dynamic contact;
  dynamic role;
  dynamic deal;
  String? type;

  @override
  void initState() {
    project = widget.project;
    account = widget.account;
    contact = widget.contact;
    role = widget.role;
    deal = widget.deal;
    type = widget.type;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PsaScaffold(
        action: PsaEditButton(
          text: 'Save',
          onTap: ((type != null && (account == null || deal == null)) ||
                  (type == null &&
                      (account == null || role == null || project == null)))
              ? null
              : () async {
                  try {
                    context.loaderOverlay.show();

                    var projectLink = {
                      "ACLOOKUP_ID": account != null ? account['ID'] : null,
                      "PROJECT_ID": project != null ? project['ID'] : null,
                    };
                    

                    if (contact != null) projectLink['CONT_ID'] = contact['ID'];
                    if (role != null) projectLink['ROLE_TYPE_ID'] = role['ID'];
                    if (deal != null) projectLink['DEAL_ID'] = deal['ID'];
                   // if (contact != null) deal['CONT_ID'] = contact['ID'];
                   if (contact != null && deal != null ) deal['CONT_ID'] = contact['ID'];
                    if (contact != null) deal['CONTACT_NAME'] = contact['TEXT'];
                     if (deal != null) deal['DEAL_ID'] = deal['ID'];
                     if (account != null && deal != null ) deal['ACCT_ID'] = account['ID'];
                    // if (account != null) deal['ACCT_ID'] = account['ID'];
                    
                    // if (project != null) deal['PROJECT_ID'] = project['ID'];
                    // if (role != null) deal['ROLE_ID'] = role['ID'];

                    if (widget.multiId != null) {
                      await OpportunityService().updateCompanyOppLink(
                          widget.multiId.toString(), deal);
                    } else {
                      if (deal != null) {
                        await OpportunityService().addCompanyOppLink(deal);
                      }
                    }
if(projectLink['ROLE_TYPE_ID'] != null){


                    if (widget.linkId != null)
                      await ProjectService().updateProjectAccountLink(
                          widget.linkId!, projectLink);
                    else
                      await ProjectService()
                          .createProjectAccountLink(projectLink);}

                    Navigator.pop(context);

                    context.loaderOverlay.hide();
                  } catch (e) {
                    context.loaderOverlay.hide();
                    Navigator.pop(context);
                  }
                },
        ),
        title: type == null
            ? LangUtil.getString('ProjectAccountLinkEditWindow', 'Title')
            : LangUtil.getString('DealMultiEditWindow', 'Title'),
        body: Container(
          child: CupertinoFormSection(
            children: [
              if (type == null)
                PsaRelatedEntityRow(
                  isVisible: false,
                  title: LangUtil.getString('ProjectAccountLinkEditWindow',
                      'LinkProjectLabelTextBlock.Text'),
                  isRequired: project == null,
                  entity: project,
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) => ProjectListScreen(
                          listName: 'pjfilt_api',
                          isSelectable: true,
                        ),
                      ),
                    );

                    if (result != null && result != '') {
                      setState(() {
                        project = result;
                      });
                    }
                  },
                ),
              PsaRelatedEntityRow(
                isVisible: false,
                title: LangUtil.getString('ProjectAccountLinkEditWindow',
                    'LinkAccountLabelTextBlock.Text'),
                isRequired: account == null,
                entity: account,
                onTap: () async {
                  if (widget.linkId != null) return;
                  // if (project == null || project['ID'] == null) {
                  var result = await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => CompanyListScreen(
                        listName: 'acsrch_api',
                        isSelectable: true,
                      ),
                    ),
                  );

                  if (result != null && result != '') {
                    setState(() {
                      account = result;
                    });
                  }
                },
              ),
              PsaRelatedEntityRow(
                isVisible: false,
                title: LangUtil.getString('ProjectAccountLinkEditWindow',
                    'LinkedContactLabelTextBlock.Text'),
                entity: contact,
                onTap: () async {
                  if (account == null || account['ID'] == null) return;

                  context.loaderOverlay.show();

                  var contactList = await CompanyService()
                      .getRelatedEntity('company', account['ID'], 'contacts');

                  context.loaderOverlay.hide();

                  var result = await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => RelatedEntityScreen(
                        entity: {
                          '1': '',
                          '2': '',
                        },
                        type: 'contacts',
                        title: '',
                        list: contactList,
                        isSelectable: true,
                        isEditable: false,
                      ),
                    ),
                  );

                  if (result != null && result != '') {
                    setState(() {
                      contact = result;
                    });
                  }
                },
              ),
              if (type != null)
                PsaRelatedEntityRow(
                  isVisible: false,
                  title: LangUtil.getString(
                      'DealMultiEditWindow', 'LinkDealLabelTextBlock.Text'),
                  isRequired: deal == null,
                  entity: deal,
                  onTap: () async {
                    // if (project == null || project['ID'] == null) {
                    var result = await Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            OpportunityListScreen(
                          listName: 'ALLDE',
                          isSelectable: true,
                        ),
                      ),
                    );

                    if (result != null && result != '') {
                      setState(() {
                        deal = result; 
                      });
                    }
                  },
                ),
              if (type == null||type=="opp")
                PsaRelatedEntityRow(
                  isVisible: false,
                  title: LangUtil.getString('ProjectAccountLinkEditWindow',
                      'RoleLabelTextBlock.Text'),
                  isRequired: role == null,
                  entity: {
                    'ID': role != null ? role['ID'] : '',
                    'TEXT': role != null
                        ? LangUtil.getListValue(
                        'ROLE_TYPE.ROLE_TYPE_ID', role['ID'])
                        : '',
                  },
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) => PsaListPicker(
                          title: '',
                          contextId: 'ROLE_TYPE.ROLE_TYPE_ID',
                        ),
                      ),
                    );

                    if (result != null && result != '') {
                      setState(() {
                        role = result;
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
