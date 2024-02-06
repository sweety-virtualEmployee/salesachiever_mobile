import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/screens/dynamic_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicTabScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final String title;
  final bool readonly;
  final String? tabId;
  final String? moduleId;
  final String? tabType;
  final String? entityName;
  final String entityType;

  const DynamicTabScreen({
    Key? key,
    required this.readonly,
    required this.title,
    this.tabId,
    this.entityName,
    this.tabType,
    required this.entityType,
    this.moduleId,
    required this.entity,
  }) : super(key: key);

  @override
  State<DynamicTabScreen> createState() => _DynamicTabScreenState();
}

class _DynamicTabScreenState extends State<DynamicTabScreen> {

  DynamicProjectService service = DynamicProjectService();
  DynamicProjectApi service1 = DynamicProjectApi();
  bool _readonly = true;
  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = DynamicTabProvide();
    _dynamicTabProvider.setEntity(widget.entity);
    if (widget.tabType == "P") {
      service.getEntitySubTabForm(
          widget.moduleId.toString(), widget.tabId.toString());
    } else {
      service.getProjectTabs(widget.moduleId.toString());
    }
    super.initState();
  }

  onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.entityType${widget.entityType}");
    return PsaScaffold(
      title: "${capitalizeFirstLetter(widget.entityType)} Tabs",
      body: FutureBuilder(
          future: widget.tabType == "P"
              ? service.getEntitySubTabForm(
              widget.moduleId.toString(), widget.tabId.toString())
              : service.getProjectTabs(widget.moduleId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ChangeNotifierProvider<DynamicTabProvide>(
                  create: (context) => _dynamicTabProvider,
                  child: Consumer<DynamicTabProvide>(
                      builder: (context, provider, child) {
                      return Column(children: [
                        Container(
                            height: 70,
                            child: CommonHeader(
                                entityType: widget.entityType.toUpperCase(), entity: provider.getEntity)),
                        Container(
                          color: Colors.white,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              CupertinoFormSection(
                                backgroundColor:
                                CupertinoColors.systemGroupedBackground,
                                children: [
                                  Column(
                                    children: [
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              height: 0,
                                              endIndent: 1.0,
                                              color: Colors.black12,
                                            ),
                                        itemCount: jsonDecode(jsonEncode(snapshot.data))
                                            .length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (jsonDecode(jsonEncode(snapshot.data))[
                                              index]['TAB_TYPE'] ==
                                                  "C") {
                                                print("yes");
                                                print("project data${provider.getEntity}");

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return DynamicEditScreen(
                                                        entityName: jsonDecode(
                                                            jsonEncode(snapshot
                                                                .data))[index]
                                                        ['TAB_DESC']
                                                            .toString(),
                                                        entity: provider.getEntity,
                                                        tabId: jsonDecode(jsonEncode(
                                                            snapshot.data))[index]
                                                        ['TAB_ID'],
                                                        readonly: true,
                                                        entityType: widget.entityType,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }else if (jsonDecode(
                                                  jsonEncode(snapshot.data))[
                                              index]['TAB_TYPE'] ==
                                                  "P") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return DynamicTabScreen(
                                                        entity: provider.getEntity,
                                                        entityType: widget.entityType,
                                                        entityName: jsonDecode(
                                                            jsonEncode(snapshot
                                                                .data))[index]
                                                        ['TAB_DESC']
                                                            .toString(),
                                                        tabId: jsonDecode(jsonEncode(
                                                            snapshot.data))[index]
                                                        ['TAB_ID'],
                                                        moduleId: jsonDecode(jsonEncode(
                                                            snapshot.data))[index]
                                                        ['MODULE_ID'],
                                                        tabType: jsonDecode(jsonEncode(
                                                            snapshot.data))[index]
                                                        ['TAB_TYPE'],
                                                        title: provider.getEntity?[
                                                        'PROJECT_TITLE'] ??
                                                            LangUtil.getString(
                                                                'Entities',
                                                                'Project.Create.Text'),
                                                        readonly: true,

                                                      );
                                                    },
                                                  ),
                                                );
                                              }else if (jsonDecode(
                                                  jsonEncode(snapshot.data))[
                                              index]['TAB_TYPE'] ==
                                                  "L") {
                                                if(provider.getEntity.isEmpty){
                                                  ErrorUtil.showErrorMessage(context, "Please create the record first");
                                                }
                                                else {
                                                  String path = "";
                                                  String tableName = "";
                                                  String id = "";
                                                  if (widget.entityType == "COMPANY") {
                                                    path = jsonDecode(jsonEncode(
                                                        snapshot.data))[index]
                                                    ['TAB_LIST']
                                                        .replaceAll("@RECORDID",
                                                        provider.getEntity['ACCT_ID']);
                                                  } else if (widget.entityType ==
                                                      "CONTACT") {
                                                    if (jsonDecode(jsonEncode(
                                                        snapshot.data))[index]
                                                    ['TAB_LIST']
                                                        .contains("@RECORDID")) {
                                                      path = jsonDecode(jsonEncode(
                                                          snapshot.data))[index]
                                                      ['TAB_LIST']
                                                          .replaceAll("@RECORDID",
                                                          provider.getEntity['CONT_ID']);
                                                    } else {
                                                      path = jsonDecode(
                                                          jsonEncode(snapshot.data))[
                                                      index]['TAB_LIST'];
                                                      id = provider.getEntity['CONT_ID'];
                                                      tableName = "CONTACT";
                                                    }
                                                  } else if (widget.entityType ==
                                                      "ACTION") {
                                                    path = jsonDecode(jsonEncode(
                                                        snapshot.data))[index]
                                                    ['TAB_LIST']
                                                        .replaceAll("@RECORDID",
                                                        provider.getEntity['ACTION_ID']);
                                                  } else if (widget.entityType ==
                                                      "OPPORTUNITY") {
                                                    if (jsonDecode(jsonEncode(
                                                        snapshot.data))[index]
                                                    ['TAB_LIST']
                                                        .contains("@RECORDID")) {
                                                      path = jsonDecode(jsonEncode(
                                                          snapshot.data))[index]
                                                      ['TAB_LIST']
                                                          .replaceAll("@RECORDID",
                                                          provider.getEntity['DEAL_ID']);
                                                    } else {
                                                      path = jsonDecode(
                                                          jsonEncode(snapshot.data))[
                                                      index]['TAB_LIST'];
                                                      id = provider.getEntity['DEAL_ID'];
                                                      tableName = "DEAL";
                                                    }
                                                  } else if (widget.entityType ==
                                                      "PROJECT") {
                                                    path = jsonDecode(jsonEncode(
                                                        snapshot.data))[index]
                                                    ['TAB_LIST']
                                                        .replaceAll("@RECORDID",
                                                        provider.getEntity['PROJECT_ID']);
                                                  }
                                                  var result =
                                                  await service.getTabListEntityApi(
                                                      path.replaceAll("&amp;", "&"),
                                                      tableName,
                                                      id,
                                                      1);
                                                  Navigator.push(
                                                    context,
                                                    platformPageRoute(
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                          DynamicRelatedEntityScreen(
                                                            entity: provider.getEntity,
                                                            project: provider.getEntity,
                                                            entityType: widget
                                                                .entityType,
                                                            path: path,
                                                            tableName: tableName,
                                                            id: id,
                                                            type: jsonDecode(jsonEncode(
                                                                snapshot.data))[index]
                                                            ['TAB_LIST_MODULE']
                                                                .toString()
                                                                .toLowerCase(),
                                                            title: jsonDecode(
                                                                jsonEncode(
                                                                    snapshot
                                                                        .data))[index]
                                                            ['TAB_DESC']
                                                                .toString(),
                                                            list: result,
                                                            isSelectable: false,
                                                            isEditable: true,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              padding:
                                              EdgeInsets.only(top: 10, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 8.0),
                                                      child: PlatformText(
                                                          jsonDecode(jsonEncode(snapshot
                                                              .data))[index]
                                                          ['TAB_DESC']
                                                              .toString(),
                                                          textAlign: TextAlign.right,
                                                          softWrap: true,
                                                          style: TextStyle()),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  if (jsonDecode(jsonEncode(
                                                      snapshot.data))[index]
                                                  ['TAB_TYPE'] ==
                                                      'L') ...[
                                                    Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 15.0),
                                                        child: CircleAvatar(
                                                          radius: 8,
                                                          backgroundColor: Color(
                                                              int.parse(jsonDecode(
                                                                  jsonEncode(
                                                                      snapshot
                                                                          .data))[
                                                              index]['TAB_HEX']
                                                                  .toString())),
                                                        )),
                                                  ] else
                                                    ...[
                                                      SizedBox(
                                                        width: 30,
                                                      )
                                                    ],
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 15.0),
                                                    child: Icon(
                                                      context
                                                          .platformIcons.rightChevron,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }
                  ));
                }
            return Center(
              child: PsaProgressIndicator(),
            );
          }),
      action: SizedBox(
        width: 20,
      ),
    );
  }
}
