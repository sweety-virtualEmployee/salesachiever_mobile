 import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/widgets/opportunity_list_item.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/3_company/widgets/linked_company_list_item.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_list_item.dart';
import 'package:salesachiever_mobile/modules/3_company/widgets/company_list_item.dart';
import 'package:salesachiever_mobile/modules/4_contact/widgets/contact_list_item.dart';
import 'package:salesachiever_mobile/modules/5_project/widgets/project_list_item.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class RelatedEntityScreen extends StatefulWidget {
  const RelatedEntityScreen({
    Key? key,
    required this.entity,
    required this.type,
    required this.title,
    required this.list,
    required this.isSelectable,
    required this.isEditable,
  }) : super(key: key);

  final dynamic entity;
  final String type;
  final String title;
  final List<dynamic> list;
  final bool isSelectable;
  final bool isEditable;

  @override
  _RelatedEntityScreenState createState() => _RelatedEntityScreenState();
}

class _RelatedEntityScreenState extends State<RelatedEntityScreen> {
  List<dynamic> list = [];

  @override
  void initState() {
    list = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PsaScaffold(
        action: (widget.type == 'company' ||
                widget.type == 'companies' ||
                widget.type == 'companies?pageSize=1000&pageNumber=1')
            ? PsaAddButton(
                onTap: () async {
                  widget.entity['DEAL_ID'] != null
                      ? Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) =>
                                AddRelatedEntityScreen(
                              multiId: widget.entity['MULTI_ID'],
                              deal: {
                                'ID': widget.entity['DEAL_ID'],
                                'TEXT': widget.entity['DESCRIPTION'],
                              },
                              account: widget.entity['ACCT_ID'] != null
                                  ? {
                                      'ID': widget.entity['ACCT_ID'],
                                      'TEXT': widget.entity['ACCTNAME'],
                                    }
                                  : {},
                              contact: widget.entity['CONT_ID'] != null
                                  ? {
                                      'ID': widget.entity['CONT_ID'],
                                      'TEXT':
                                          '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}',
                                    }
                                  : {},
                              type: "opp",
                            ),
                          ),
                        )
                      : Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) =>
                                AddRelatedEntityScreen(
                              project: {
                                'ID': widget.entity['PROJECT_ID'],
                                'TEXT': widget.entity['PROJECT_TITLE'],
                              },
                            ),
                          ),
                        ).then((value) async {
                          context.loaderOverlay.show();

                          var result = await CompanyService().getRelatedEntity(
                              'project',
                              widget.entity['PROJECT_ID'],
                              'companies');

                          setState(() {
                            list = result;
                          });

                          context.loaderOverlay.hide();
                        });
                },
              )
            : (widget.type == 'projects' && widget.entity['CONT_ID'] == null)
                ? PsaAddButton(
                    onTap: () async {
                      Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) =>
                              AddRelatedEntityScreen(
                            account: {
                              'ID': widget.entity['ACCT_ID'],
                              'TEXT': widget.entity['ACCTNAME'],
                            },
                          ),
                        ),
                      );
                    },
                  )
                : (widget.type == 'actions' ||
                        widget.type == "actions?pageSize=1000&pageNumber=1")
                    ? PsaAddButton(
                        onTap: () => Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) => ActionTypeScreen(
                              action: {
                                'ACCT_ID': widget.entity['ACCT_ID'],
                                'ACCTNAME': widget.entity['ACCTNAME'],
                                'CONT_ID': widget.entity['CONT_ID'],
                                'CONTACT_NAME': widget.entity['CONT_ID'] != null
                                    ? '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}'
                                    : null,
                                'PROJECT_ID': widget.entity['PROJECT_ID'],
                                'PROJECT_TITLE': widget.entity['PROJECT_TITLE'],
                                'DEAL_ID': widget.entity['DEAL_ID'],
                                'DEAL_DESCRIPTION':
                                    widget.entity['DEAL_ID'] != null
                                        ? widget.entity['DESCRIPTION']
                                        : '',
                              },
                              popScreens: 3,
                            ),
                          ),
                        ),
                      )
                    : (widget.type ==
                            'OpportunityLinks?pageSize=1000&pageNumber=1')
                        ? PsaAddButton(
                            onTap: () async {
                              if (widget.entity['MULTI_ID'] == null &&
                                  widget.entity['PROJECT_ID'] != null) {
                                    Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AddRelatedEntityScreen(
                                      multiId: widget.entity['MULTI_ID'],
                                      deal: {
                                        'ID': widget.entity['DEAL_ID'],
                                        'TEXT': widget.entity['DEAL_NAME'],
                                      },
                                     // project: widget.entity,
                                      account: widget.entity['ACCT_ID'] != null
                                          ? {
                                              'ID': widget.entity['ACCT_ID'],
                                              'TEXT': widget.entity['ACCTNAME'],
                                            }
                                          : {},
                                      contact: widget.entity['CONT_ID'] != null
                                          ? {
                                              'ID': widget.entity['CONT_ID'],
                                              'TEXT':
                                                  '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}',
                                            }
                                          : {},
                                      type: "opp",
                                    ),
                                  ),
                                );
                                // Navigator.push(
                                //   context,
                                //   platformPageRoute(
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         OpportunityEditScreen(
                                //             deal: {},
                                //             project: widget.entity,
                                //             readonly: false),
                                //   ),
                                // );
                              } else {
                                Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AddRelatedEntityScreen(
                                      multiId: widget.entity['MULTI_ID'],
                                      deal: {
                                        'ID': widget.entity['DEAL_ID'],
                                        'TEXT': widget.entity['DEAL_NAME'],
                                      },
                                      account: widget.entity['ACCT_ID'] != null
                                          ? {
                                              'ID': widget.entity['ACCT_ID'],
                                              'TEXT': widget.entity['ACCTNAME'],
                                            }
                                          : {},
                                      contact: widget.entity['CONT_ID'] != null
                                          ? {
                                              'ID': widget.entity['CONT_ID'],
                                              'TEXT':
                                                  '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}',
                                            }
                                          : {},
                                      type: "opp",
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : null,
        body: ListView.separated(
          addAutomaticKeepAlives: false,
          padding: EdgeInsets.symmetric(vertical: 18.0),
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            if (widget.type == 'company' ||
                widget.type == 'companies' ||
                widget.type == 'companies?pageSize=1000&pageNumber=1') {
              if (widget.isEditable) {
                return LinkedCompanyListItemWidget(
                  entity: list[index],
                  refresh: () {},
                  isSelectable: widget.isSelectable,
                  isEditable: true,
                  onEdit: () => onLinkEdit(index),
                  onDelete: () => list[index]['MULTI_ID'] != null
                      ? onLinkDeleteOpp(index)
                      : onLinkDelete(index),
                );
              } else {
                return CompanyListItemWidget(
                  entity: list[index],
                  refresh: () {},
                  isSelectable: widget.isSelectable,
                );
              }
            }

            if (widget.type == 'contacts')
              return ContactListItemWidget(
                entity: list[index],
                refresh: () {},
                isSelectable: widget.isSelectable,
              );
            if (widget.type == 'projects')
              return ProjectListItemWidget(
                entity: list[index],
                refresh: () {},
                isSelectable: widget.isSelectable,
                isEditable: widget.isEditable,
                onEdit: () => onLinkEdit(index),
                onDelete: () => onLinkDelete(index),
              );
            if (widget.type == 'actions' ||
                widget.type == "actions?pageSize=1000&pageNumber=1")
              return ActionListItemWidget(entity: list[index], refresh: () {});
            if (widget.type == 'OpportunityLinks?pageSize=1000&pageNumber=1') {
              return new FutureBuilder(
                  future:
                      OpportunityService().getEntity(list[index]['DEAL_ID']),
                  builder: (context, snapshot) {
                    dynamic deal = snapshot.data;

                    var item = list[index];

                    if (deal != null && deal.data != null && item != null) {
                      deal.data['CONTACT'] = "";
                      deal.data['CONTACT'] =
                          '${item['FIRSTNAME'] ?? ''} ${item['SURNAME'] ?? ''}';
                    }
                    return snapshot.connectionState == ConnectionState.done
                        ? new OpportunityListItemWidget(
                            entity: deal.data,
                            refresh: () {},
                            isSelectable: widget.isSelectable,
                            isEditable: widget.isEditable,
                            onEdit: () => onLinkEdit(index),
                            onDelete: () => onLinkDeleteOpp(index),
                          )
                        : new Container();
                  });
            }
            return Container();
          },
        ),
        title: widget.title,
      ),
    );
  }

  onLinkEdit(int index) async {
    context.loaderOverlay.show();
    String type = widget.type;
    var linkedEntity = list[index]['LINK_ID'] != null
        ? await ProjectService().getProjectAccountLink(list[index]['LINK_ID'])
        : null;

    var linkedDeal = list[index]['MULTI_ID'] != null
        ? await OpportunityService().getCompanyOppLink(list[index]['MULTI_ID'])
        : null;

    if (linkedEntity == null) {
      if (linkedDeal['CONT_ID'] != null) {
        dynamic contact =
            await ContactService().getEntity(linkedDeal['CONT_ID']);
        linkedDeal['FIRSTNAME'] = contact.data['FIRSTNAME'];
        linkedDeal['SURNAME'] = contact.data['SURNAME'];
      }

      dynamic company = await CompanyService().getEntity(linkedDeal['ACCT_ID']);
      dynamic deal =
          await OpportunityService().getEntity(linkedDeal['DEAL_ID']);

      linkedDeal['ACCTNAME'] = company.data['ACCTNAME'];
      linkedDeal['DEAL_NAME'] = deal.data['DESCRIPTION'];
      type = 'OpportunityLinks?pageSize=1000&pageNumber=1';
    }
    context.loaderOverlay.hide();
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (BuildContext context) => AddRelatedEntityScreen(
          type: type == 'OpportunityLinks?pageSize=1000&pageNumber=1'
              ? "Opportunity"
              : null,
          linkId: list[index]['LINK_ID'],
          multiId: list[index]['MULTI_ID'],
          account: {
            'ID': linkedEntity != null
                ? linkedEntity['ACCT_ID']
                : linkedDeal != null
                    ? linkedDeal['ACCT_ID']
                    : '',
            'TEXT': linkedEntity != null
                ? linkedEntity['ACCTNAME']
                : linkedDeal != null
                    ? linkedDeal['ACCTNAME']
                    : '',
          },
          contact: {
            'ID': linkedEntity != null
                ? linkedEntity['CONT_ID']
                : linkedDeal != null
                    ? linkedDeal['CONT_ID']
                    : '',
            'TEXT': linkedEntity != null
                ? '${linkedEntity['FIRSTNAME'] ?? ''} ${linkedEntity['SURNAME'] ?? ''}'
                : linkedDeal != null
                    ? '${linkedDeal['FIRSTNAME'] ?? ''} ${linkedDeal['SURNAME'] ?? ''}'
                    : '',
          },
          project: {
            'ID': linkedEntity != null ? linkedEntity['PROJECT_ID'] : '',
            'TEXT': linkedEntity != null ? linkedEntity['PROJECT_TITLE'] : '',
          },
          role: {
            'ID': linkedEntity != null ? linkedEntity['ROLE_TYPE_ID'] : '',
            // 'TEXT': linkedEntity['PROJECT_TITLE:'],
          },
          deal: {
            'ID': linkedDeal != null ? linkedDeal['DEAL_ID'] : '',
            'TEXT': linkedDeal != null ? linkedDeal['DEAL_NAME'] : '',
          },
        ),
      ),
    );
  }

  onLinkDelete(int index) async {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Delete Record'),
        content: Text('Do you want to delete selected record?'),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          PlatformDialogAction(
            child: PlatformText('Delete'),
            onPressed: () async {
              await ProjectService()
                  .deleteProjectAccountLink(list[index]['LINK_ID']);

              setState(() {
                list.removeWhere(
                    (element) => element['LINK_ID'] == list[index]['LINK_ID']);
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  onLinkDeleteOpp(int index) async {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Delete Record'),
        content: Text('Do you want to delete selected record?'),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          PlatformDialogAction(
            child: PlatformText('Delete'),
            onPressed: () async {
              await OpportunityService()
                  .deleteCompanyOppLink(list[index]['MULTI_ID']);

              setState(() {
                list.removeWhere((element) =>
                    element['MULTI_ID'] == list[index]['MULTI_ID']);
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
