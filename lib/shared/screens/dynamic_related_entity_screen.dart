import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_notes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

import '../../modules/10_opportunities/services/opportunity_service.dart';
import '../../modules/3_company/screens/company_edit_screen.dart';
import '../../modules/3_company/services/company_service.dart';
import '../../modules/4_contact/screens/contact_edit_screen.dart';
import '../../modules/4_contact/services/contact_service.dart';
import '../../modules/6_action/screens/action_edit_screen.dart';
import '../../modules/6_action/screens/action_type_screen.dart';
import '../../modules/6_action/services/action_service.dart';
import '../../modules/dynamic_module/5_dynamic_project/screens/dynamic_project_add.dart';
import '../../modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import '../widgets/buttons/psa_add_button.dart';
import 'add_related_entity_screen.dart';

class DynamicRelatedEntityScreen extends StatefulWidget {
  const DynamicRelatedEntityScreen({
    Key? key,
    required this.entity,
    required this.type,
    required this.title,
    required this.entityType,
    required this.list,
    required this.isSelectable,
    required this.isEditable,
    required this.project,
  }) : super(key: key);

  final dynamic entity;
  final String type;
  final String title;
  final String entityType;
  final List<dynamic> list;
  final bool isSelectable;
  final bool isEditable;
  final Map<String, dynamic> project;

  @override
  _DynamicRelatedEntityScreenState createState() =>
      _DynamicRelatedEntityScreenState();
}

class _DynamicRelatedEntityScreenState
    extends State<DynamicRelatedEntityScreen> {
  List<dynamic> list = [];
  dynamic _project;

  @override
  void initState() {
    _project = this.widget.project;
    list = widget.list;
    print("dynamic listValue${widget.entity}");
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
                : (widget.type == 'contacts')
                    ? PsaAddButton(
                            onTap: () async {
                              Navigator.push(
                                context,
                                platformPageRoute(
                                  context: context,
                                  builder: (BuildContext context) => ContactEditScreen(
                                    contact: {
                                      'ACCT_ID': widget.entity['ACCT_ID'],
                                      'ACCTNAME': widget.entity['ACCTNAME'],
                                      'CONT_ID': widget.entity['CONT_ID'],
                                      'CONTACT_NAME': widget.entity['CONT_ID'] !=
                                          null
                                          ? '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}'
                                          : null,
                                    },
                                    readonly: false,
                                    accountId: widget.entity['ACCT_ID'],
                                    accountName: widget.entity['ACCTNAME'],
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
                                builder: (BuildContext context) =>
                                    ActionTypeScreen(
                                  action: {
                                    'ACCT_ID': widget.entity['ACCT_ID'],
                                    'ACCTNAME': widget.entity['ACCTNAME'],
                                    'CONT_ID': widget.entity['CONT_ID'],
                                    'CONTACT_NAME': widget.entity['CONT_ID'] !=
                                            null
                                        ? '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}'
                                        : null,
                                    'PROJECT_ID': widget.entity['PROJECT_ID'],
                                    'PROJECT_TITLE':
                                        widget.entity['PROJECT_TITLE'],
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
                                          account: widget.entity['ACCT_ID'] !=
                                                  null
                                              ? {
                                                  'ID':
                                                      widget.entity['ACCT_ID'],
                                                  'TEXT':
                                                      widget.entity['ACCTNAME'],
                                                }
                                              : {},
                                          contact: widget.entity['CONT_ID'] !=
                                                  null
                                              ? {
                                                  'ID':
                                                      widget.entity['CONT_ID'],
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
                                          account: widget.entity['ACCT_ID'] !=
                                                  null
                                              ? {
                                                  'ID':
                                                      widget.entity['ACCT_ID'],
                                                  'TEXT':
                                                      widget.entity['ACCTNAME'],
                                                }
                                              : {},
                                          contact: widget.entity['CONT_ID'] !=
                                                  null
                                              ? {
                                                  'ID':
                                                      widget.entity['CONT_ID'],
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
                            : (widget.type.contains("notes"))
                                ? PsaAddButton(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return DynamicProjectNotes(
                                            project: _project,
                                            notesData: {},
                                            typeNote: widget.type,
                                            isNewNote: true,
                                            entityType: widget.entityType,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : null,
        body: Column(
          children: [
            Container(
                height: 61,
                child: CommonHeader(
                    entityType: widget.entityType, entity: _project)),
            Container(
              color: Colors.black,
              height: 20,
            ),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Text(
                    "No ${widget.type} is linked to ${capitalizeFirstLetter(widget.entityType)}"),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = list[index];
                    return InkWell(
                      onTap: () async {
                        context.loaderOverlay.show();
                        if (widget.type == "companies") {
                          dynamic company =
                              await CompanyService().getEntity(item["ACCT_ID"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CompanyEditScreen(
                                  company: company.data,
                                  readonly: true,
                                );
                              },
                            ),
                          );
                        } else if (widget.type == "contacts") {
                          dynamic contact =
                              await ContactService().getEntity(item['CONT_ID']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ContactEditScreen(
                                  contact: contact.data,
                                  readonly: true,
                                );
                              },
                            ),
                          );
                        } else if (widget.type == "actions") {
                          dynamic action = await ActionService()
                              .getEntity(item['ACTION_ID']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ActionEditScreen(
                                  action: action.data,
                                  readonly: true,
                                  popScreens: 1,
                                );
                              },
                            ),
                          );
                        } else if (widget.type == "opportunities") {
                          dynamic deal = await OpportunityService()
                              .getEntity(widget.entity['DEAL_ID'].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return OpportunityEditScreen(
                                  deal: deal.data,
                                  readonly: true,
                                );
                              },
                            ),
                          );
                        } else if (widget.type.contains("notes")) {
                          dynamic response = await DynamicProjectService()
                              .getProjectNote(widget.type, item['NOTE_ID']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DynamicProjectNotes(
                                  project: _project,
                                  typeNote: widget.type,
                                  notesData: response,
                                  isNewNote: false,
                                  entityType: widget.entityType,
                                );
                              },
                            ),
                          );
                        } else {
                          dynamic project = await ProjectService()
                              .getEntity(item['PROJECT_ID']);
                          print("projectbalue$project");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DynamicProjectAddScreen(
                                  project: project.data,
                                  readonly: true,
                                );
                              },
                            ),
                          );
                        }
                        context.loaderOverlay.hide();
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final entry in item.entries)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20, top: 10),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 130,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 4, 0, 4),
                                                  child: Text(
                                                    '${entry.key} :',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: widget.type ==
                                                                "companies"
                                                            ? Color(0xff3cab4f)
                                                            : widget.type ==
                                                                    "contacts"
                                                                ? Color(
                                                                    0xff4C99E0)
                                                                : widget.type ==
                                                                        "opportunities"
                                                                    ? Color(
                                                                        0xffA4C400)
                                                                    : widget.type ==
                                                                            "actions"
                                                                        ? Color(
                                                                            0xffae1a3e)
                                                                        : Color(
                                                                            0xffE67E6B)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 4, 0, 4),
                                                child: Text(
                                                  '${entry.value.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (widget.type == "companies") {
                                          dynamic company =
                                              await CompanyService()
                                                  .getEntity(item["ACCT_ID"]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CompanyEditScreen(
                                                  company: company.data,
                                                  readonly: true,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (widget.type == "contacts") {
                                          dynamic contact =
                                              await ContactService()
                                                  .getEntity(item['CONT_ID']);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ContactEditScreen(
                                                  contact: contact.data,
                                                  readonly: true,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (widget.type == "actions") {
                                          dynamic action = await ActionService()
                                              .getEntity(item['ACTION_ID']);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ActionEditScreen(
                                                  action: action.data,
                                                  readonly: true,
                                                  popScreens: 1,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (widget.type
                                            .contains("notes")) {
                                          dynamic response =
                                              await DynamicProjectService()
                                                  .getProjectNote(widget.type,
                                                      item['NOTE_ID']);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicProjectNotes(
                                                    project: _project,
                                                    notesData: response,
                                                    entityType:
                                                        widget.entityType,
                                                    typeNote: widget.type,
                                                    isNewNote: false);
                                              },
                                            ),
                                          );
                                        } else {
                                          dynamic project =
                                              await ProjectService().getEntity(
                                                  item['PROJECT_ID']);
                                          print("projectbalue$project");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicProjectAddScreen(
                                                  project: project.data,
                                                  readonly: true,
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                          context.platformIcons.rightChevron)),
                                ],
                              ),
                            ],
                          ),
                          if ((widget.type == 'company' ||
                              widget.type == 'companies' ||
                              widget.type ==
                                  'companies?pageSize=1000&pageNumber=1'))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    onLinkEdit(index);
                                  },
                                  child: Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onLinkDelete(index);
                                  },
                                  child: Text('Delete'),
                                )
                              ],
                            ),
                          Divider(
                            color: Colors.black26,
                            thickness: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        title: widget.title,
      ),
    );
  }

  onLinkEdit(int index) async {
    context.loaderOverlay.show();
    String type = widget.type;
    var linkedEntity = list[index]['LINK_ID'] != null
        ? await DynamicProjectService()
            .getProjectAccountLink(list[index]['LINK_ID'])
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
              await DynamicProjectService()
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
}
