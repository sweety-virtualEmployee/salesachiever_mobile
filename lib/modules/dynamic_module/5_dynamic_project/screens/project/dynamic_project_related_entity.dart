import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_type_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/company/dynamic_company_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/contact/dynamic_contact_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/opportunity/dynamic_opportunity_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_notes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/quotation/dynamic_quotation_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/screens/dynamic_sub_tab_listing.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicProjectRelatedEntityScreen extends StatefulWidget {
  const DynamicProjectRelatedEntityScreen({
    Key? key,
    required this.entity,
    required this.type,
    required this.title,
    required this.entityType,
    required this.list,
    required this.tableName,
    required this.id,
    required this.path,
    required this.isSelectable,
    required this.isEditable,
    required this.project,
  }) : super(key: key);

  final dynamic entity;
  final String type;
  final String title;
  final String entityType;
  final String path;
  final String tableName;
  final String id;
  final dynamic list;
  final bool isSelectable;
  final bool isEditable;
  final Map<String, dynamic> project;

  @override
  _DynamicProjectRelatedEntityScreenState createState() =>
      _DynamicProjectRelatedEntityScreenState();
}

class _DynamicProjectRelatedEntityScreenState
    extends State<DynamicProjectRelatedEntityScreen> {
  List<dynamic> list = [];
  final ScrollController _scrollController = ScrollController();
  bool isLastPage = false;
  int pageNumber = 1;
  DynamicProjectService service = DynamicProjectService();

  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider =
        Provider.of<DynamicTabProvide>(context, listen: false);
    _dynamicTabProvider.setProjectEntity(widget.entity);
    callApi();
    list = widget.list["Items"];
    isLastPage = widget.list["IsLastPage"] ?? true;
    pageNumber = widget.list["PageNumber"] ?? 1;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
    super.initState();
  }

  callApi() async {
    context.loaderOverlay.show();
    if (widget.entity?["PROJECT_ID"] != null) {
      var entity =
          await ProjectService().getEntity(widget.entity?["PROJECT_ID"]);
      _dynamicTabProvider.getProjectEntity["PROJECT_TITLE"] =
          entity.data["PROJECT_TITLE"];
    }
    _dynamicTabProvider.setProjectEntity(_dynamicTabProvider.getProjectEntity);
    context.loaderOverlay.hide();
  }

  void _loadNextPage() async {
    if (isLastPage == false) {
      pageNumber = pageNumber + 1;
      var listData = await service.getTabListEntityApi(
          widget.path.replaceAll("&amp;", "&"),
          widget.tableName,
          widget.id,
          pageNumber);
      setState(() {
        isLastPage = listData["IsLastPage"];
        pageNumber = listData["PageNumber"];
        list.addAll(listData["Items"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicTabProvide>(builder: (context, provider, child) {
      return PsaScaffold(
        action: (widget.type == 'company' ||
                    widget.type == 'companies' ||
                    widget.type == 'companies?pageSize=1000&pageNumber=1') &&
                (widget.entityType != "ACTION")
            ? PsaAddButton(
                onTap: () async {
                  if (provider.getProjectEntity['DEAL_ID'] != null) {
                    await Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            AddRelatedEntityScreen(
                          multiId: provider.getProjectEntity['MULTI_ID'],
                          deal: {
                            'ID': provider.getProjectEntity['DEAL_ID'],
                            'TEXT': provider.getProjectEntity['DESCRIPTION'],
                          },
                          account: provider.getProjectEntity['ACCT_ID'] != null
                              ? {
                                  'ID': provider.getProjectEntity['ACCT_ID'],
                                  'TEXT': provider.getProjectEntity['ACCTNAME'],
                                }
                              : {},
                          contact: provider.getProjectEntity['CONT_ID'] != null
                              ? {
                                  'ID': provider.getProjectEntity['CONT_ID'],
                                  'TEXT':
                                      '${provider.getProjectEntity['FIRSTNAME'] ?? ''} ${provider.getProjectEntity['SURNAME'] ?? ''}',
                                }
                              : {},
                          type: "",
                        ),
                      ),
                    );
                  } else {
                    print("we are in this value");
                    await Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            AddRelatedEntityScreen(
                          project: {
                            'ID': provider.getProjectEntity['PROJECT_ID'],
                            'TEXT': provider.getProjectEntity['PROJECT_TITLE'],
                          },
                          account: {
                            'ID': provider.getProjectEntity['ACCT_ID'],
                            'TEXT': provider.getProjectEntity['ACCTNAME'],
                          },
                          contact: {
                            'ID': provider.getProjectEntity['CONT_ID'],
                            'TEXT': provider.getProjectEntity['CONT_ID'] != null
                                ? '${provider.getProjectEntity['FIRSTNAME'] ?? ''} ${provider.getProjectEntity['SURNAME'] ?? ''}'
                                : null,
                          },
                        ),
                      ),
                    ).then((value) async {
                      context.loaderOverlay.show();
                      print("value check$value");

                      var result = await CompanyService().getRelatedEntity(
                        'project',
                        provider.getProjectEntity["PROJECT_ID"],
                        'companies',
                      );

                      setState(() {
                        list = result;
                      });

                      context.loaderOverlay.hide();
                    });
                  }
                },
              )
            : ((widget.type == 'projects' &&
                        provider.getProjectEntity['CONT_ID'] == null) &&
                    (widget.entityType != "ACTION"))
                ? PsaAddButton(
                    onTap: () async {
                      if (provider.getProjectEntity['ACCT_ID'] != null) {
                        print("yes here");
                        Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) =>
                                AddRelatedEntityScreen(
                              account: {
                                'ID': provider.getProjectEntity['ACCT_ID'],
                                'TEXT': provider.getProjectEntity['ACCTNAME'],
                              },
                            ),
                          ),
                        );
                      } else {
                        if (provider.getProjectEntity['DEAL_ID'] != null) {
                          var project = await DynamicProjectService()
                              .getEntityById("OPPORTUNITY",
                                  provider.getProjectEntity['DEAL_ID']);
                          print(
                              "project data value get${project.data.toString()}");
                          print(project.data["DEAL_NAME"]);
                          setState(() {
                            provider.getProjectEntity["DEAL_NAME"] =
                                project.data["DEAL_NAME"];
                          });
                        }
                        Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) =>
                                AddRelatedEntityScreen(
                              account: {
                                'ID': provider.getProjectEntity['ACCT_ID'],
                                'TEXT': provider.getProjectEntity['ACCTNAME'],
                              },
                              multiId: provider.getProjectEntity['MULTI_ID'],
                              deal: {
                                'ID': provider.getProjectEntity['DEAL_ID'],
                                'TEXT': provider.getProjectEntity['DEAL_NAME'],
                              },
                              type: "opp",
                            ),
                          ),
                        );
                      }
                    },
                  )
                : ((widget.type == 'contacts' &&
                            widget.entityType != "PROJECT") &&
                        (widget.entityType != "ACTION"))
                    ? PsaAddButton(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return DynamicContactTabScreen(
                                entity: provider.getProjectEntity,
                                title: "Add New Contact",
                                readonly: true,
                                moduleId: "004",
                                entityType: widget.type,
                                isRelatedEntity: false,
                              );
                            },
                          ));
                        },
                      )
                    : (widget.type == 'actions' ||
                            widget.type == "actions?pageSize=1000&pageNumber=1")
                        ? PsaAddButton(onTap: () {
                          print("widget.entity?[""]${widget.entity?["PROJECT_ID"]}");
                            Navigator.push(
                              context,
                              platformPageRoute(
                                context: context,
                                builder: (BuildContext context) =>
                                    DynamicActionTypeScreen(
                                  action: {"PROJECT_ID":widget.entity?["PROJECT_ID"]},
                                  popScreens: 2,
                                  listType: widget.type,
                                ),
                              ),
                            );
                          })
                        : (widget.type == 'opportunities' ||
                                widget.type ==
                                    'OpportunityLinks?pageSize=1000&pageNumber=1')
                            ? PsaAddButton(
                                onTap: () async {
                                  if (provider.getProjectEntity['MULTI_ID'] ==
                                          null &&
                                      provider.getProjectEntity['PROJECT_ID'] !=
                                          null) {
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
                                    print("result${result}");
                                    dynamic value = {
                                      "PROJECT_ID": provider
                                          .getProjectEntity['PROJECT_ID']
                                    };
                                    print(value);
                                    await OpportunityService()
                                        .updateEntity(result!['ID'], value);
                                  } else {
                                    print("we are here");
                                    if (provider.getProjectEntity['ACCT_ID'] !=
                                        null) {
                                      var project =
                                          await DynamicProjectService()
                                              .getEntityById(
                                                  "COMPANY",
                                                  provider.getProjectEntity[
                                                      'ACCT_ID']);
                                      setState(() {
                                        provider.getProjectEntity["ACCTNAME"] =
                                            project.data["ACCTNAME"];
                                      });
                                    }
                                    Navigator.push(
                                      context,
                                      platformPageRoute(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AddRelatedEntityScreen(
                                          multiId: provider
                                              .getProjectEntity['MULTI_ID'],
                                          deal: {
                                            'ID': provider
                                                .getProjectEntity['DEAL_ID'],
                                            'TEXT': provider
                                                .getProjectEntity['DEAL_NAME'],
                                          },
                                          project: {
                                            'ID': provider
                                                .getProjectEntity['PROJECT_ID'],
                                            'TEXT': provider.getProjectEntity[
                                                'PROJECT_TITLE'],
                                          },
                                          account: provider.getProjectEntity[
                                                      'ACCT_ID'] !=
                                                  null
                                              ? {
                                                  'ID':
                                                      provider.getProjectEntity[
                                                          'ACCT_ID'],
                                                  'TEXT':
                                                      provider.getProjectEntity[
                                                          'ACCTNAME'],
                                                }
                                              : {},
                                          contact: provider.getProjectEntity[
                                                      'CONT_ID'] !=
                                                  null
                                              ? {
                                                  'ID':
                                                      provider.getProjectEntity[
                                                          'CONT_ID'],
                                                  'TEXT':
                                                      '${provider.getProjectEntity['FIRSTNAME'] ?? ''} ${provider.getProjectEntity['SURNAME'] ?? ''}',
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
                                            project: provider.getProjectEntity,
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
                height: 70,
                child: CommonHeader(
                    entityType: widget.entityType,
                    entity: provider.getProjectEntity)),
            Container(
              color: Colors.white,
              height: 20,
            ),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Text("No Data found"),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    final item = list[index];
                    return InkWell(
                      onTap: () async {
                        print("widget.type check${widget.type}");
                        if (widget.type == "companies") {
                          dynamic company =
                              await CompanyService().getEntity(item["ACCT_ID"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DynamicCompanyTabScreen(
                                  entity: company.data,
                                  title: widget.entity['PROJECT_TITLE'] != null
                                      ? widget.entity['PROJECT_TITLE']
                                      : "",
                                  readonly: true,
                                  moduleId: "003",
                                  entityType: widget.type,
                                  isRelatedEntity: true,
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
                                return DynamicContactTabScreen(
                                  entity: contact.data,
                                  title: widget.entity['PROJECT_TITLE'] != null
                                      ? widget.entity['PROJECT_TITLE']
                                      : "",
                                  readonly: true,
                                  moduleId: "004",
                                  entityType: widget.type,
                                  isRelatedEntity: true,
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
                                return DynamicActionTabScreen(
                                  entity: action.data,
                                  title: widget.entity['PROJECT_TITLE'] != null
                                      ? widget.entity['PROJECT_TITLE']
                                      : "",
                                  readonly: true,
                                  moduleId: "009",
                                  entityType: widget.type,
                                  isRelatedEntity: true,
                                );
                              },
                            ),
                          );
                        } else if (widget.type == "opportunities") {
                          print(
                              "deal id valeudifgc${provider.getProjectEntity['DEAL_DEAL_ID']}");
                          dynamic deal = await OpportunityService()
                              .getEntity(item['DEAL_ID'].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DynamicOpportunityTabScreen(
                                  entity: deal.data,
                                  title: widget.entity['PROJECT_TITLE'] != null
                                      ? widget.entity['PROJECT_TITLE']
                                      : "",
                                  readonly: true,
                                  moduleId: "006",
                                  entityType: widget.type,
                                  isRelatedEntity: true,
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
                                  project: provider.getProjectEntity,
                                  typeNote: widget.type,
                                  notesData: response,
                                  isNewNote: false,
                                  entityType: widget.entityType,
                                );
                              },
                            ),
                          );
                        } else if (widget.type == "opp history") {
                        } else if (widget.type == "quotes") {
                          dynamic quotation = await DynamicProjectService()
                              .getEntityById("QUOTATION", item['QUOTE_ID']);
                          quotation.data['ACCT_ID'] = item['ACCT_ID'];
                          quotation.data['ACCTNAME'] = item['ACCTNAME'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DynamicQuotationTabScreen(
                                  entity: quotation.data,
                                  title: widget.entity['DESCRIPTION'] != null
                                      ? widget.entity['DESCRIPTION']
                                      : "",
                                  readonly: true,
                                  moduleId: "007",
                                  entityType: widget.type,
                                  isRelatedEntity: true,
                                );
                              },
                            ),
                          );
                        } else if (widget.type == "projects") {
                          print("widget.type${widget.type}");
                          dynamic project = await ProjectService()
                              .getEntity(item['PROJECT_ID']);
                          print("projectbalue$project");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DynamicProjectTabScreen(
                                  entity: project.data,
                                  title: widget.entity['PROJECT_TITLE'] != null
                                      ? widget.entity['PROJECT_TITLE']
                                      : "",
                                  readonly: true,
                                  moduleId: "005",
                                  entityType: widget.type,
                                  isRelatedEntity: true,
                                );
                              },
                            ),
                          );
                        } else {
                          print("do nothing");
                          print("item$item");
                          if (widget.title == "P2P Quotes") {
                            dynamic response =
                                await service.getSubTabListEntityValues(
                                    "QTIT_API", "QUOTE_ID", item["QUOTE_ID"]);
                            print(response);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DynamicSubTabListingScreen(
                                    list: response,
                                    title: widget.title,
                                    entityType: widget.entityType,
                                    project: provider.getProjectEntity,
                                  );
                                },
                              ),
                            );
                          } else if (widget.title == "Invoice Information") {
                            dynamic response =
                                await service.getSubTabListEntityValues(
                                    "INITEM_API",
                                    "INVOICE_ID",
                                    item["INVOICE_ID"]);
                            print(response);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DynamicSubTabListingScreen(
                                    list: response,
                                    title: widget.title,
                                    entityType: widget.entityType,
                                    project: provider.getProjectEntity,
                                  );
                                },
                              ),
                            );
                          } else if (widget.title == "Order Information") {
                            dynamic response =
                                await service.getSubTabListEntityValues(
                                    "ORITEM_API",
                                    "ORDERINFO_ID",
                                    item["ORDERINFO_ID"]);
                            print(response);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DynamicSubTabListingScreen(
                                    list: response,
                                    title: widget.title,
                                    entityType: widget.entityType,
                                    project: provider.getProjectEntity,
                                  );
                                },
                              ),
                            );
                          }
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
                                      entry.key == "SAUSER_ID"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20,
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 4, 0, 4),
                                                        child: Text(
                                                          '${LangUtil.getString('${entry.key.contains("_") ? entry.key.substring(0, entry.key.indexOf('_')) : ""}', '${entry.key.split('_').length < 3 ? entry.key : entry.key.contains("_") ? entry.key.substring(entry.key.indexOf("_") + 1) : entry.key}')} :',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: widget
                                                                          .type ==
                                                                      "companies"
                                                                  ? Color(
                                                                      0xff3cab4f)
                                                                  : widget.type ==
                                                                          "contacts"
                                                                      ? Color(
                                                                          0xff4C99E0)
                                                                      : widget.type == "opportunities" ||
                                                                              widget.type ==
                                                                                  "opp history"
                                                                          ? Color(
                                                                              0xffA4C400)
                                                                          : widget.type == "actions"
                                                                              ? Color(0xffae1a3e)
                                                                              : Color(0xffE67E6B)),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                          maxLines: 2,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 4, 0, 4),
                                                      child: Text(
                                                        entry.value != null
                                                            ? entry.key
                                                                    .contains(
                                                                        "DATE")
                                                                ? DateUtil
                                                                    .getFormattedDate(
                                                                        entry
                                                                            .value)
                                                                : entry.key.contains(
                                                                        "TIME")
                                                                    ? DateUtil
                                                                        .getFormattedTime(
                                                                            entry.value)
                                                                    : '${entry.value.toString()}'
                                                            : "",
                                                        style: TextStyle(
                                                            color: widget
                                                                        .type ==
                                                                    "opp history"
                                                                ? Colors.grey
                                                                : Colors.black),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: false,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : entry.key.contains("_ID") ||
                                                  entry.key.contains("__") ||
                                                  entry.key
                                                      .contains("_DORMANT") ||
                                                  entry.key.contains("DORMANT")
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20,
                                                          top: 10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 4, 0, 4),
                                                            child: Text(
                                                              '${LangUtil.getString('${entry.key.contains("_") ? entry.key.substring(0, entry.key.indexOf('_')) : ""}', '${entry.key.split('_').length < 3 ? entry.key : entry.key.contains("_") ? entry.key.substring(entry.key.indexOf("_") + 1) : entry.key}')} :',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: widget
                                                                              .type ==
                                                                          "companies"
                                                                      ? Color(
                                                                          0xff3cab4f)
                                                                      : widget.type ==
                                                                              "contacts"
                                                                          ? Color(
                                                                              0xff4C99E0)
                                                                          : widget.type == "opportunities" || widget.type == "opp history"
                                                                              ? Color(0xffA4C400)
                                                                              : widget.type == "actions"
                                                                                  ? Color(0xffae1a3e)
                                                                                  : Color(0xffE67E6B)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: false,
                                                              maxLines: 2,
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 4, 0, 4),
                                                          child: Text(
                                                            entry.value != null
                                                                ? entry.key.contains(
                                                                        "DATE")
                                                                    ? DateUtil
                                                                        .getFormattedDate(entry
                                                                            .value)
                                                                    : entry.key.contains(
                                                                            "TIME")
                                                                        ? DateUtil.getFormattedTime(
                                                                            entry.value)
                                                                        : '${entry.value.toString()}'
                                                                : "",
                                                            style: TextStyle(
                                                                color: widget.type ==
                                                                        "opp history"
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
                                                            maxLines: 2,
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
                                  widget.type == "opp history"
                                      ? SizedBox()
                                      : IconButton(
                                      onPressed: () async {
                                        print("widget.type check${widget.type}");
                                        if (widget.type == "companies") {
                                          dynamic company =
                                          await CompanyService().getEntity(item["ACCT_ID"]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicCompanyTabScreen(
                                                  entity: company.data,
                                                  title: widget.entity['PROJECT_TITLE'] != null
                                                      ? widget.entity['PROJECT_TITLE']
                                                      : "",
                                                  readonly: true,
                                                  moduleId: "003",
                                                  entityType: widget.type,
                                                  isRelatedEntity: true,
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
                                                return DynamicContactTabScreen(
                                                  entity: contact.data,
                                                  title: widget.entity['PROJECT_TITLE'] != null
                                                      ? widget.entity['PROJECT_TITLE']
                                                      : "",
                                                  readonly: true,
                                                  moduleId: "004",
                                                  entityType: widget.type,
                                                  isRelatedEntity: true,
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
                                                return DynamicActionTabScreen(
                                                  entity: action.data,
                                                  title: widget.entity['PROJECT_TITLE'] != null
                                                      ? widget.entity['PROJECT_TITLE']
                                                      : "",
                                                  readonly: true,
                                                  moduleId: "009",
                                                  entityType: widget.type,
                                                  isRelatedEntity: true,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (widget.type == "opportunities") {
                                          print(
                                              "deal id valeudifgc${provider.getProjectEntity['DEAL_DEAL_ID']}");
                                          dynamic deal = await OpportunityService()
                                              .getEntity(item['DEAL_ID'].toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicOpportunityTabScreen(
                                                  entity: deal.data,
                                                  title: widget.entity['PROJECT_TITLE'] != null
                                                      ? widget.entity['PROJECT_TITLE']
                                                      : "",
                                                  readonly: true,
                                                  moduleId: "006",
                                                  entityType: widget.type,
                                                  isRelatedEntity: true,
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
                                                  project: provider.getProjectEntity,
                                                  typeNote: widget.type,
                                                  notesData: response,
                                                  isNewNote: false,
                                                  entityType: widget.entityType,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (widget.type == "opp history") {
                                        } else if (widget.type == "quotes") {
                                          dynamic quotation = await DynamicProjectService()
                                              .getEntityById("QUOTATION", item['QUOTE_ID']);
                                          quotation.data['ACCT_ID'] = item['ACCT_ID'];
                                          quotation.data['ACCTNAME'] = item['ACCTNAME'];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicQuotationTabScreen(
                                                  entity: quotation.data,
                                                  title: widget.entity['DESCRIPTION'] != null
                                                      ? widget.entity['DESCRIPTION']
                                                      : "",
                                                  readonly: true,
                                                  moduleId: "007",
                                                  entityType: widget.type,
                                                  isRelatedEntity: true,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (widget.type == "projects") {
                                          print("widget.type${widget.type}");
                                          dynamic project = await ProjectService()
                                              .getEntity(item['PROJECT_ID']);
                                          print("projectbalue$project");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicProjectTabScreen(
                                                  entity: project.data,
                                                  title: widget.entity['PROJECT_TITLE'] != null
                                                      ? widget.entity['PROJECT_TITLE']
                                                      : "",
                                                  readonly: true,
                                                  moduleId: "005",
                                                  entityType: widget.type,
                                                  isRelatedEntity: true,
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          print("do nothing");
                                          print("item$item");
                                          if (widget.title == "P2P Quotes") {
                                            dynamic response =
                                            await service.getSubTabListEntityValues(
                                                "QTIT_API", "QUOTE_ID", item["QUOTE_ID"]);
                                            print(response);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DynamicSubTabListingScreen(
                                                    list: response,
                                                    title: widget.title,
                                                    entityType: widget.entityType,
                                                    project: provider.getProjectEntity,
                                                  );
                                                },
                                              ),
                                            );
                                          } else if (widget.title == "Invoice Information") {
                                            dynamic response =
                                            await service.getSubTabListEntityValues(
                                                "INITEM_API",
                                                "INVOICE_ID",
                                                item["INVOICE_ID"]);
                                            print(response);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DynamicSubTabListingScreen(
                                                    list: response,
                                                    title: widget.title,
                                                    entityType: widget.entityType,
                                                    project: provider.getProjectEntity,
                                                  );
                                                },
                                              ),
                                            );
                                          } else if (widget.title == "Order Information") {
                                            dynamic response =
                                            await service.getSubTabListEntityValues(
                                                "ORITEM_API",
                                                "ORDERINFO_ID",
                                                item["ORDERINFO_ID"]);
                                            print(response);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DynamicSubTabListingScreen(
                                                    list: response,
                                                    title: widget.title,
                                                    entityType: widget.entityType,
                                                    project: provider.getProjectEntity,
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        }

                                        context.loaderOverlay.hide();
                                      },
                                          icon: Icon(context
                                              .platformIcons.rightChevron)),
                                ],
                              ),
                            ],
                          ),
                          if ((widget.type == 'company' ||
                                  widget.type == 'companies' ||
                                  widget.type ==
                                      'companies?pageSize=1000&pageNumber=1') &&
                              (item['LINK_ID'] != null ||
                                  item['MULTI_ID'] != null))
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
      );
    });
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
    if (list[index]['LINK_ID'] != null) {
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
                print('linkgdehrf id${list[index]['LINK_ID']}');
                await DynamicProjectService()
                    .deleteProjectAccountLink(list[index]['LINK_ID']);

                setState(() {
                  list.removeWhere((element) =>
                      element['LINK_ID'] == list[index]['LINK_ID']);
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
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
}
