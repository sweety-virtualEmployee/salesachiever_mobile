import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';

import '../../../modules/10_opportunities/services/opportunity_service.dart';
import '../../../modules/3_company/screens/company_edit_screen.dart';
import '../../../modules/3_company/services/company_service.dart';
import '../../../modules/4_contact/screens/contact_edit_screen.dart';
import '../../../modules/4_contact/services/contact_service.dart';

class PsaRelatedValueRow extends StatefulWidget {
  final String title;
  String value;
  final String type;
  final dynamic entity;
  final Function onTap;
  final bool isRequired;
  final bool isVisible;
  final Function onChange;
  final bool readOnly;


  PsaRelatedValueRow({
    Key? key,
    required this.title,
    required this.onTap,
    required this.value,
    required this.type,
    required this.onChange,
    this.isRequired = false,
    this.readOnly = true,
    this.entity,
    required this.isVisible,
  }) : super(key: key);

  @override
  _PsaRelatedValueRowState createState() => _PsaRelatedValueRowState();
}

class _PsaRelatedValueRowState extends State<PsaRelatedValueRow> {
  String selectedCompany = "";
  String selectedContact = "";
  String selectedProject = "";
  String selectedOpportunity = "";
  String selectedRateAgreement = "";
  var companyData;
  var contactData;
  var projectData;
  var opportunityData;

  @override
  void initState() {
    callApi(widget.type);
    super.initState();
  }

  callApi(String type) async {
    print(widget.entity?["Data_Value"]);
    print(widget.entity?["ACCT_ID"]);
    context.loaderOverlay.show();
    if (type == "ACCT_ID") {
      if (widget.entity?["ACCT_ID"] != null) {
        var company =
            await CompanyService().getEntity(widget.entity?["ACCT_ID"]);
        print("comapny${company.data}");
        setState(() {
          companyData = company.data;
          selectedCompany = companyData["ACCTNAME"];
          widget.onChange([
            {'KEY': 'ACCT_ID', 'VALUE': companyData['ACCT_ID']},
            {'KEY': 'ACCTNAME', 'VALUE': companyData['ACCTNAME']},
          ]);
          print(companyData["ACCTNAME"]);
        });
      } else if (widget.entity?["Data_Value"] != null) {
        var company =
            await CompanyService().getEntity(widget.entity?["Data_Value"]);
        print("comapny${company.data}");
        setState(() {
          companyData = company.data;
          selectedCompany = companyData["ACCTNAME"];
          widget.onChange([
            {'KEY': 'ACCT_ID', 'VALUE': companyData['ACCT_ID']},
            {'KEY': 'ACCTNAME', 'VALUE': companyData['ACCTNAME']},
          ]);
          print(companyData["ACCTNAME"]);
        });
      }
    }
    if (type == "CONT_ID") {
      if (widget.entity?["CONT_ID"] != null) {
        var contact =
            await ContactService().getEntity(widget.entity?["CONT_ID"]);
        print("Contfdjkvbg$contact");
        setState(() {
          contactData = contact.data;
          selectedContact = contactData["FIRSTNAME"];
          widget.onChange([
            {'KEY': 'CONT_ID', 'VALUE': contactData['CONT_ID']},
            {'KEY': 'FIRSTNAME', 'VALUE': contactData['FIRSTNAME']},
          ]);
        });
      } else if (widget.entity?["Data_Value"] != null) {
        var contact =
            await ContactService().getEntity(widget.entity?["Data_Value"]);
        print("Contfdjkvbg$contact");
        setState(() {
          contactData = contact.data;
          selectedContact = contactData["FIRSTNAME"];
          widget.onChange([
            {'KEY': 'CONT_ID', 'VALUE': contactData['CONT_ID']},
            {'KEY': 'FIRSTNAME', 'VALUE': contactData['FIRSTNAME']},
          ]);
        });
      }
    }
    if (type == "PROJECT_ID") {
      if (widget.entity?["PROJECT_ID"] != null) {
        var project =
            await ProjectService().getEntity(widget.entity?["PROJECT_ID"]);
        setState(() {
          projectData = project.data;
          selectedProject = projectData["PROJECT_TITLE"];
          widget.onChange([
            {'KEY': 'PROJECT_ID', 'VALUE': projectData['PROJECT_ID']},
            {'KEY': 'PROJECT_TITLE', 'VALUE': projectData['PROJECT_TITLE']},
          ]);
        });
      } else if (widget.entity?["Data_Value"] != null) {
        var project =
            await ProjectService().getEntity(widget.entity?["Data_Value"]);
        setState(() {
          projectData = project.data;
          selectedProject = projectData["PROJECT_TITLE"];
          widget.onChange([
            {'KEY': 'PROJECT_ID', 'VALUE': projectData['PROJECT_ID']},
            {'KEY': 'PROJECT_TITLE', 'VALUE': projectData['PROJECT_TITLE']},
          ]);
        });
      }
    }
    if (type == "DEAL_ID") {
      if (widget.entity?["DEAL_ID"] != null) {
        var deal =
            await OpportunityService().getEntity(widget.entity?["DEAL_ID"]);
        setState(() {
          opportunityData = deal.data;
          selectedOpportunity = opportunityData["DESCRIPTION"];
          widget.onChange([
            {'KEY': 'DEAL_ID', 'VALUE': opportunityData['DEAL_ID']},
            {'KEY': 'DESCRIPTION', 'VALUE': opportunityData['DESCRIPTION']},
          ]);
        });
      } else if (widget.entity?["Data_Value"] != null) {
        var deal =
            await OpportunityService().getEntity(widget.entity?["Data_Value"]);
        setState(() {
          opportunityData = deal.data;
          selectedOpportunity = opportunityData["DESCRIPTION"];
          widget.onChange([
            {'KEY': 'DEAL_ID', 'VALUE': opportunityData['DEAL_ID']},
            {'KEY': 'DESCRIPTION', 'VALUE': opportunityData['DESCRIPTION']},
          ]);
        });
      }
    }
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == "ACCT_ID"
        ? InkWell(
            onTap: () async {
              if (widget.type == "ACCT_ID") {
                if (companyData != null) {
                  await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => CompanyEditScreen(
                          company: companyData, readonly: false),
                    ),
                  );
                } else if (widget.entity['DEAL_ID'] != null) {
                  context.loaderOverlay.show();

                  var result = await CompanyService().getRelatedEntity(
                      'Opportunity',
                      widget.entity['DEAL_ID'],
                      'companies?pageSize=1000&pageNumber=1');

                  context.loaderOverlay.hide();

                  var company = await Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) => RelatedEntityScreen(
                        entity: widget.entity,
                        type: 'companies',
                        title: '',
                        list: result,
                        isSelectable: true,
                        isEditable: false,
                      ),
                    ),
                  );
                  print("company value check$company");
                  print("company value check$contactData");
                  if (company != null) {
                    widget.onChange([
                      {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                      {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                    ]);
                    setState(() {
                      selectedCompany = company['TEXT'];
                    });
                  }
                } else {
                  if (widget.entity['ACTION_ID'] != null) return;

                  if (widget.entity['PROJECT_ID'] == null) {
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

                    if (company != null) {
                      widget.onChange([
                        {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                        {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                        {'KEY': 'PROJECT_ID', 'VALUE': null},
                        {'KEY': 'PROJECT_TITLE', 'VALUE': null},
                      ]);
                      setState(() {
                        selectedCompany = company['TEXT'];
                      });
                    }
                  } else {
                    context.loaderOverlay.show();

                    var result = await CompanyService().getRelatedEntity(
                        'project', widget.entity['PROJECT_ID'], 'companies');

                    context.loaderOverlay.hide();

                    var company = await Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) => RelatedEntityScreen(
                          entity: widget.entity,
                          type: 'companies',
                          title: '',
                          list: result,
                          isSelectable: true,
                          isEditable: false,
                        ),
                      ),
                    );

                    if (company != null) {
                      widget.onChange([
                        {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                        {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                      ]);
                      setState(() {
                        selectedCompany = company['TEXT'];
                      });
                    }
                  }
                }
              }
            },
            child: Container(
              color: Colors.white,
              child: CupertinoFormRow(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color:
                                widget.isRequired ? Colors.red : Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: CupertinoTextField(
                          onTap: () async {
                            if (widget.type == "ACCT_ID") {
                              if (companyData != null) {
                                await Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CompanyEditScreen(
                                            company: companyData,
                                            readonly: false),
                                  ),
                                );
                              } else if (widget.entity['DEAL_ID'] != null) {
                                context.loaderOverlay.show();

                                var result = await CompanyService()
                                    .getRelatedEntity(
                                        'Opportunity',
                                        widget.entity['DEAL_ID'],
                                        'companies?pageSize=1000&pageNumber=1');

                                context.loaderOverlay.hide();

                                var company = await Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        RelatedEntityScreen(
                                      entity: widget.entity,
                                      type: 'companies',
                                      title: '',
                                      list: result,
                                      isSelectable: true,
                                      isEditable: false,
                                    ),
                                  ),
                                );

                                if (company != null) {
                                  widget.onChange([
                                    {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                                    {
                                      'KEY': 'ACCTNAME',
                                      'VALUE': company['TEXT']
                                    },
                                  ]);
                                  setState(() {
                                    selectedCompany = company['TEXT'];
                                  });
                                }
                              } else {
                                if (widget.entity['ACTION_ID'] != null) return;

                                if (widget.entity['PROJECT_ID'] == null) {
                                  var company = await Navigator.push(
                                    context,
                                    platformPageRoute(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CompanyListScreen(
                                        listName: 'acsrch_api',
                                        isSelectable: true,
                                      ),
                                    ),
                                  );
                                  print("conatct data$contactData");
                                  if (company != null) {
                                    widget.onChange([
                                      {
                                        'KEY': 'ACCT_ID',
                                        'VALUE': company['ID']
                                      },
                                      {
                                        'KEY': 'ACCTNAME',
                                        'VALUE': company['TEXT']
                                      },
                                      {'KEY': 'PROJECT_ID', 'VALUE': null},
                                      {'KEY': 'PROJECT_TITLE', 'VALUE': null},
                                      // {'KEY': 'DESCRIPTION', 'VALUE': company['TEXT']},
                                    ]);
                                    setState(() {
                                      selectedCompany = company['TEXT'];
                                    });
                                  }
                                } else {
                                  context.loaderOverlay.show();

                                  var result = await CompanyService()
                                      .getRelatedEntity(
                                          'project',
                                          widget.entity['PROJECT_ID'],
                                          'companies');

                                  context.loaderOverlay.hide();

                                  var company = await Navigator.push(
                                    context,
                                    platformPageRoute(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          RelatedEntityScreen(
                                        entity: widget.entity,
                                        type: 'companies',
                                        title: '',
                                        list: result,
                                        isSelectable: true,
                                        isEditable: false,
                                      ),
                                    ),
                                  );

                                  if (company != null) {
                                    widget.onChange([
                                      {
                                        'KEY': 'ACCT_ID',
                                        'VALUE': company['ID']
                                      },
                                      {
                                        'KEY': 'ACCTNAME',
                                        'VALUE': company['TEXT']
                                      },
                                    ]);
                                    setState(() {
                                      selectedCompany = company['TEXT'];
                                    });
                                  }
                                }
                              }
                            }
                          },
                          controller: TextEditingController()
                            ..text = selectedCompany,
                          readOnly: true,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                          ),
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 15),
                          suffix: Icon(
                            context.platformIcons.rightChevron,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : widget.type == "CONT_ID"
            ? InkWell(
                onTap: () async {
                  if (widget.type == "CONT_ID") {
                    if (contactData != null) {
                      await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => ContactEditScreen(
                              contact: contactData, readonly: false),
                        ),
                      );
                    } else {
                      if (widget.entity['ACCT_ID'] == null) {
                        var contact = await Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) =>
                                ContactListScreen(
                              listName: 'cont_api',
                              isSelectable: true,
                            ),
                          ),
                        );

                        if (contact != null) {
                          widget.onChange([
                            {
                              'KEY': 'ACCT_ID',
                              'VALUE': contact['DATA']['ACCT_ID']
                            },
                            {
                              'KEY': 'ACCTNAME',
                              'VALUE': contact['DATA']['ACCTNAME']
                            },
                            {'KEY': 'CONT_ID', 'VALUE': contact['ID']},
                            {'KEY': 'CONTACT_NAME', 'VALUE': contact['TEXT']},
                          ]);
                          setState(() {
                            selectedContact = contact['TEXT'];
                          });
                        }
                      } else {
                        context.loaderOverlay.show();

                        var result = await CompanyService().getRelatedEntity(
                            'company', widget.entity['ACCT_ID'], 'contacts');

                        context.loaderOverlay.hide();

                        var contact = await Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) =>
                                RelatedEntityScreen(
                              entity: widget.entity,
                              type: 'contacts',
                              title: '',
                              list: result,
                              isSelectable: true,
                              isEditable: false,
                            ),
                          ),
                        );

                        if (contact != null) {
                          widget.onChange([
                            {
                              'KEY': 'ACCT_ID',
                              'VALUE': contact['DATA']['ACCT_ID']
                            },
                            {
                              'KEY': 'ACCTNAME',
                              'VALUE': contact['DATA']['ACCTNAME']
                            },
                            {'KEY': 'CONT_ID', 'VALUE': contact['ID']},
                            {'KEY': 'CONTACT_NAME', 'VALUE': contact['TEXT']},
                          ]);
                          setState(() {
                            selectedContact = contact['TEXT'];
                          });
                        }
                      }
                    }
                  }
                },
                child: Container(
                  color: Colors.white,
                  child: CupertinoFormRow(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: widget.isRequired
                                    ? Colors.red
                                    : Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: CupertinoTextField(
                              onTap: () async {
                                if (widget.type == "CONT_ID") {
                                  if (contactData != null) {
                                    await Navigator.push(
                                      context,
                                      platformPageRoute(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ContactEditScreen(
                                                contact: contactData,
                                                readonly: false),
                                      ),
                                    );
                                  } else {
                                    if (widget.entity['ACCT_ID'] == null) {
                                      var contact = await Navigator.push(
                                        context,
                                        platformPageRoute(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ContactListScreen(
                                            listName: 'cont_api',
                                            isSelectable: true,
                                          ),
                                        ),
                                      );

                                      if (contact != null) {
                                        widget.onChange([
                                          {
                                            'KEY': 'ACCT_ID',
                                            'VALUE': contact['DATA']['ACCT_ID']
                                          },
                                          {
                                            'KEY': 'ACCTNAME',
                                            'VALUE': contact['DATA']['ACCTNAME']
                                          },
                                          {
                                            'KEY': 'CONT_ID',
                                            'VALUE': contact['ID']
                                          },
                                          {
                                            'KEY': 'CONTACT_NAME',
                                            'VALUE': contact['TEXT']
                                          },
                                        ]);
                                        setState(() {
                                          selectedContact = contact['TEXT'];
                                        });
                                      }
                                    } else {
                                      context.loaderOverlay.show();

                                      var result = await CompanyService()
                                          .getRelatedEntity(
                                              'company',
                                              widget.entity['ACCT_ID'],
                                              'contacts');

                                      context.loaderOverlay.hide();

                                      var contact = await Navigator.push(
                                        context,
                                        platformPageRoute(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              RelatedEntityScreen(
                                            entity: widget.entity,
                                            type: 'contacts',
                                            title: '',
                                            list: result,
                                            isSelectable: true,
                                            isEditable: false,
                                          ),
                                        ),
                                      );

                                      if (contact != null) {
                                        widget.onChange([
                                          {
                                            'KEY': 'ACCT_ID',
                                            'VALUE': contact['DATA']['ACCT_ID']
                                          },
                                          {
                                            'KEY': 'ACCTNAME',
                                            'VALUE': contact['DATA']['ACCTNAME']
                                          },
                                          {
                                            'KEY': 'CONT_ID',
                                            'VALUE': contact['ID']
                                          },
                                          {
                                            'KEY': 'CONTACT_NAME',
                                            'VALUE': contact['TEXT']
                                          },
                                        ]);
                                        setState(() {
                                          selectedContact = contact['TEXT'];
                                        });
                                      }
                                    }
                                  }
                                }
                              },
                              controller: TextEditingController()
                                ..text = selectedContact,
                              readOnly: true,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 15),
                              suffix: Icon(
                                context.platformIcons.rightChevron,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : widget.type == "PROJECT_ID"
                ? InkWell(
                    onTap: () async {
                      if (widget.type == "PROJECT_ID") {
                        if (projectData != null) {
                          await Navigator.push(
                            context,
                            platformPageRoute(
                              context: context,
                              builder: (BuildContext context) =>
                                  ProjectEditScreen(
                                project: projectData,
                                readonly: false,
                              ),
                            ),
                          );
                        } else {
                          if (widget.entity['ACCT_ID'] == null) {
                            var project = await Navigator.push(
                              context,
                              platformPageRoute(
                                context: context,
                                builder: (BuildContext context) =>
                                    ProjectListScreen(
                                  listName: 'pjfilt_api',
                                  isSelectable: true,
                                ),
                              ),
                            );

                            if (project != null) {
                              widget.onChange([
                                {'KEY': 'PROJECT_ID', 'VALUE': project['ID']},
                                {
                                  'KEY': 'PROJECT_TITLE',
                                  'VALUE': project['TEXT']
                                },
                              ]);
                              setState(() {
                                selectedProject = project['TEXT'];
                              });
                            }
                          } else {
                            context.loaderOverlay.show();

                            var result = await CompanyService()
                                .getRelatedEntity('company',
                                    widget.entity['ACCT_ID'], 'projects');

                            context.loaderOverlay.hide();

                            var project = await Navigator.push(
                              context,
                              platformPageRoute(
                                context: context,
                                builder: (BuildContext context) =>
                                    RelatedEntityScreen(
                                  entity: widget.entity,
                                  type: 'projects',
                                  title: '',
                                  list: result,
                                  isSelectable: true,
                                  isEditable: false,
                                ),
                              ),
                            );

                            if (project != null) {
                              widget.onChange([
                                {'KEY': 'PROJECT_ID', 'VALUE': project['ID']},
                                {
                                  'KEY': 'PROJECT_TITLE',
                                  'VALUE': project['TEXT']
                                },
                              ]);
                              setState(() {
                                selectedProject = project['TEXT'];
                              });
                            }
                          }
                        }
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      child: CupertinoFormRow(
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Text(
                                widget.title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: widget.isRequired
                                        ? Colors.red
                                        : Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: CupertinoTextField(
                                  onTap: () async {
                                    if (widget.type == "PROJECT_ID") {
                                      if (projectData != null) {
                                        await Navigator.push(
                                          context,
                                          platformPageRoute(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ProjectEditScreen(
                                              project: projectData,
                                              readonly: false,
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (widget.entity['ACCT_ID'] == null) {
                                          var project = await Navigator.push(
                                            context,
                                            platformPageRoute(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  ProjectListScreen(
                                                listName: 'pjfilt_api',
                                                isSelectable: true,
                                              ),
                                            ),
                                          );

                                          if (project != null) {
                                            widget.onChange([
                                              {
                                                'KEY': 'PROJECT_ID',
                                                'VALUE': project['ID']
                                              },
                                              {
                                                'KEY': 'PROJECT_TITLE',
                                                'VALUE': project['TEXT']
                                              },
                                            ]);
                                            setState(() {
                                              selectedProject = project['TEXT'];
                                            });
                                          }
                                        } else {
                                          context.loaderOverlay.show();

                                          var result = await CompanyService()
                                              .getRelatedEntity(
                                                  'company',
                                                  widget.entity['ACCT_ID'],
                                                  'projects');

                                          context.loaderOverlay.hide();

                                          var project = await Navigator.push(
                                            context,
                                            platformPageRoute(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  RelatedEntityScreen(
                                                entity: widget.entity,
                                                type: 'projects',
                                                title: '',
                                                list: result,
                                                isSelectable: true,
                                                isEditable: false,
                                              ),
                                            ),
                                          );

                                          if (project != null) {
                                            widget.onChange([
                                              {
                                                'KEY': 'PROJECT_ID',
                                                'VALUE': project['ID']
                                              },
                                              {
                                                'KEY': 'PROJECT_TITLE',
                                                'VALUE': project['TEXT']
                                              },
                                            ]);
                                            setState(() {
                                              selectedProject = project['TEXT'];
                                            });
                                          }
                                        }
                                      }
                                    }
                                  },
                                  controller: TextEditingController()
                                    ..text = selectedProject,
                                  readOnly: true,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 15),
                                  suffix: Icon(
                                    context.platformIcons.rightChevron,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : widget.type == "DEAL_ID"
                    ? InkWell(
                        onTap: () async {
                          if (widget.type == "DEAL_ID") {
                            if (opportunityData != null) {
                              await Navigator.push(
                                context,
                                platformPageRoute(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      OpportunityEditScreen(
                                          deal: opportunityData,
                                          readonly: false),
                                ),
                              );
                            } else {
                              if (widget.entity['ACCT_ID'] == null) {
                                var deal = await Navigator.push(
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

                                if (deal != null) {
                                  print("deal is not null");
                                  print(deal);
                                  print(deal['TEXT']);
                                  widget.onChange([
                                    {'KEY': 'DEAL_ID', 'VALUE': deal['ID']},
                                    {
                                      'KEY': 'DEAL_DESCRIPTION',
                                      'VALUE': deal['TEXT']
                                    },
                                  ]);
                                  setState(() {
                                    selectedOpportunity = deal['TEXT'];
                                  });
                                }
                              } else {
                                context.loaderOverlay.show();

                                var result = await CompanyService()
                                    .getRelatedEntity(
                                        'company',
                                        widget.entity['ACCT_ID'],
                                        'OpportunityLinks?pageSize=1000&pageNumber=1');

                                context.loaderOverlay.hide();

                                var deal = await Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        RelatedEntityScreen(
                                      entity: widget.entity,
                                      type:
                                          'OpportunityLinks?pageSize=1000&pageNumber=1',
                                      title: '',
                                      list: result,
                                      isSelectable: true,
                                      isEditable: false,
                                    ),
                                  ),
                                );

                                if (deal != null) {
                                  widget.onChange([
                                    {'KEY': 'DEAL_ID', 'VALUE': deal['ID']},
                                    {
                                      'KEY': 'DEAL_DESCRIPTION',
                                      'VALUE': deal['TEXT']
                                    },
                                  ]);
                                  setState(() {
                                    selectedOpportunity = deal['TEXT'];
                                  });
                                }
                              }
                            }
                          }
                        },
                        child: Container(
                          color: Colors.white,
                          child: CupertinoFormRow(
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Text(
                                    widget.title,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: widget.isRequired
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    child: CupertinoTextField(
                                      onTap: () async {
                                        if (widget.type == "DEAL_ID") {
                                          if (opportunityData != null) {
                                            await Navigator.push(
                                              context,
                                              platformPageRoute(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        OpportunityEditScreen(
                                                            deal:
                                                                opportunityData,
                                                            readonly: false),
                                              ),
                                            );
                                          } else {
                                            if (widget.entity['ACCT_ID'] ==
                                                null) {
                                              var deal = await Navigator.push(
                                                context,
                                                platformPageRoute(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          OpportunityListScreen(
                                                    listName: 'ALLDE',
                                                    isSelectable: true,
                                                  ),
                                                ),
                                              );

                                              if (deal != null) {
                                                print("deal is not null");
                                                print(deal);
                                                print(deal['TEXT']);
                                                widget.onChange([
                                                  {
                                                    'KEY': 'DEAL_ID',
                                                    'VALUE': deal['ID']
                                                  },
                                                  {
                                                    'KEY': 'DEAL_DESCRIPTION',
                                                    'VALUE': deal['TEXT']
                                                  },
                                                ]);
                                                setState(() {
                                                  selectedOpportunity =
                                                      deal['TEXT'];
                                                });
                                              }
                                            } else {
                                              context.loaderOverlay.show();

                                              var result = await CompanyService()
                                                  .getRelatedEntity(
                                                      'company',
                                                      widget.entity['ACCT_ID'],
                                                      'OpportunityLinks?pageSize=1000&pageNumber=1');

                                              context.loaderOverlay.hide();

                                              var deal = await Navigator.push(
                                                context,
                                                platformPageRoute(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          RelatedEntityScreen(
                                                    entity: widget.entity,
                                                    type:
                                                        'OpportunityLinks?pageSize=1000&pageNumber=1',
                                                    title: '',
                                                    list: result,
                                                    isSelectable: true,
                                                    isEditable: false,
                                                  ),
                                                ),
                                              );

                                              if (deal != null) {
                                                widget.onChange([
                                                  {
                                                    'KEY': 'DEAL_ID',
                                                    'VALUE': deal['ID']
                                                  },
                                                  {
                                                    'KEY': 'DEAL_DESCRIPTION',
                                                    'VALUE': deal['TEXT']
                                                  },
                                                ]);
                                                setState(() {
                                                  selectedOpportunity =
                                                      deal['TEXT'];
                                                });
                                              }
                                            }
                                          }
                                        }
                                      },
                                      controller: TextEditingController()
                                        ..text = selectedOpportunity,
                                      readOnly: true,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 15),
                                      suffix: Icon(
                                        context.platformIcons.rightChevron,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                        : SizedBox();
  }
}
