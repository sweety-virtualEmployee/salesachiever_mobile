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
  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = Provider.of<DynamicTabProvide>(context,listen: false);
    _dynamicTabProvider.setEntity(widget.entity);
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _dynamicTabProvider.dispose(); // Dispose of the provider when the widget is disposed
    super.dispose();
  }
  Future<void> fetchData() async {
    try {
      var data = await (widget.tabType == "P"
          ? service.getEntitySubTabForm(
              widget.moduleId.toString(), widget.tabId.toString())
          : service.getProjectTabs(widget.moduleId.toString()));
      _dynamicTabProvider.setData(data);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<DynamicTabProvide>(
                builder: (context, provider, child) {
              print("provider.getentity${provider.getEntity}");
              return PsaScaffold(
                title: "${capitalizeFirstLetter(widget.entityType)} Tabs",
                body: Column(children: [
                  Container(
                      height: 70,
                      child: CommonHeader(
                          entityType: widget.entityType.toUpperCase(),
                          entity: provider.getEntity)),
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
                                  separatorBuilder: (context, index) => Divider(
                                    height: 0,
                                    endIndent: 1.0,
                                    color: Colors.black12,
                                  ),
                                  itemCount: provider.getTabData.length,
                                  itemBuilder: (context, index) {
                                    print("provider.getValue${provider.getEntity}");
                                    return GestureDetector(
                                      onTap: () async {
                                        if (provider.getTabData[index]
                                                ['TAB_TYPE'] ==
                                            "C") {
                                          print("yes");
                                          print(
                                              "project data${provider.getEntity}");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicEditScreen(
                                                  entityName: provider
                                                      .getTabData[index]
                                                          ['TAB_DESC']
                                                      .toString(),
                                                  entity: provider.getEntity,
                                                  tabId:
                                                      provider.getTabData[index]
                                                          ['TAB_ID'],
                                                  readonly: true,
                                                  entityType: widget.entityType,
                                                );
                                              },
                                            ),
                                          );
                                        } else if (provider.getTabData[index]
                                                ['TAB_TYPE'] ==
                                            "P") {
                                          print(
                                              "provider.entity${provider.getEntity}");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DynamicTabScreen(
                                                  entity: provider.getEntity,
                                                  entityType: widget.entityType,
                                                  entityName: provider
                                                      .getTabData[index]
                                                          ['TAB_DESC']
                                                      .toString(),
                                                  tabId:
                                                      provider.getTabData[index]
                                                          ['TAB_ID'],
                                                  moduleId:
                                                      provider.getTabData[index]
                                                          ['MODULE_ID'],
                                                  tabType:
                                                      provider.getTabData[index]
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
                                        } else if (provider.getTabData[index]
                                                ['TAB_TYPE'] ==
                                            "L") {
                                          print(
                                              "widget.entity${widget.entityType}");
                                          if (provider.getEntity.isEmpty) {
                                            ErrorUtil.showErrorMessage(context,
                                                "Please create the record first");
                                          } else {
                                            String path = "";
                                            String tableName = "";
                                            String id = "";
                                            if (widget.entityType
                                                .toUpperCase() ==
                                                "COMPANY") {
                                              path = provider.getTabData[index]
                                              ['TAB_LIST']
                                                  .replaceAll(
                                                  "@RECORDID",
                                                  provider
                                                      .getEntity['ACCT_ID']);
                                            } else if (widget.entityType
                                                .toUpperCase() ==
                                                "CONTACT") {
                                              if (provider.getTabData[index]
                                              ['TAB_LIST']
                                                  .contains("@RECORDID")) {
                                                path =
                                                    provider.getTabData[index]
                                                    ['TAB_LIST']
                                                        .replaceAll(
                                                        "@RECORDID",
                                                        provider.getEntity[
                                                        'CONT_ID']);
                                              } else {
                                                path =
                                                provider.getTabData[index]
                                                ['TAB_LIST'];
                                                id =
                                                provider.getEntity['CONT_ID'];
                                                tableName = "CONTACT";
                                              }
                                            } else if (widget.entityType
                                                .toUpperCase() ==
                                                "ACTION") {
                                              print("yes in action");
                                              print(provider.getTabData[index]
                                              ['TAB_DESC']);
                                              path = provider.getTabData[index]
                                              ['TAB_LIST']
                                                  .replaceAll(
                                                  "@RECORDID",
                                                  provider.getEntity[
                                                  'ACTION_ID']);
                                            } else if (widget.entityType
                                                .toUpperCase() ==
                                                "OPPORTUNITY") {
                                              if (provider.getTabData[index]
                                              ['TAB_LIST']
                                                  .contains("@RECORDID")) {
                                                path =
                                                    provider.getTabData[index]
                                                    ['TAB_LIST']
                                                        .replaceAll(
                                                        "@RECORDID",
                                                        provider.getEntity[
                                                        'DEAL_ID']);
                                              } else {
                                                path =
                                                provider.getTabData[index]
                                                ['TAB_LIST'];
                                                id =
                                                provider.getEntity['DEAL_ID'];
                                                tableName = "DEAL";
                                              }
                                            } else if (widget.entityType
                                                .toUpperCase() ==
                                                "PROJECT") {
                                              path = provider.getTabData[index]
                                              ['TAB_LIST']
                                                  .replaceAll(
                                                  "@RECORDID",
                                                  provider.getEntity[
                                                  'PROJECT_ID']);
                                            }
                                            if (widget.entityType != "ACTION") {
                                              var result =
                                              await service.getTabListEntityApi(
                                                  path.replaceAll("&amp;", "&"),
                                                  tableName,
                                                  id,
                                                  1);
                                              print("result$result");
                                              Navigator.push(
                                                context,
                                                platformPageRoute(
                                                  context: context,
                                                  builder: (
                                                      BuildContext context) =>
                                                      DynamicRelatedEntityScreen(
                                                        entity: provider
                                                            .getEntity,
                                                        project: provider
                                                            .getEntity,
                                                        entityType: widget
                                                            .entityType,
                                                        path: path,
                                                        tableName: tableName,
                                                        id: id,
                                                        type: provider
                                                            .getTabData[index]
                                                        ['TAB_LIST_MODULE']
                                                            .toString()
                                                            .toLowerCase(),
                                                        title: provider
                                                            .getTabData[index]
                                                        ['TAB_DESC']
                                                            .toString(),
                                                        list: result ?? [],
                                                        isSelectable: false,
                                                        isEditable: true,
                                                      ),
                                                ),
                                              );
                                            }
                                            else{
                                              if(provider
                                                  .getTabData[index]
                                              ['TAB_DESC']=="Companies") {
                                                if ( provider
                                                    .getEntity["ACCT_ID"] ==
                                                    null) {
                                                  ErrorUtil.showErrorMessage(
                                                      context,
                                                      "No Company linked to this Action");
                                                }
                                                else {
                                                  var entity =
                                                  await DynamicProjectService()
                                                      .getEntityById("COMPANY",
                                                      provider
                                                          .getEntity['ACCT_ID']);
                                                  Map<String,
                                                      dynamic>dynamicList = {
                                                    "Items": [entity]
                                                  };
                                                  print(
                                                      "entity check $dynamicList");
                                                  Navigator.push(
                                                    context,
                                                    platformPageRoute(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) =>
                                                          DynamicRelatedEntityScreen(
                                                            entity:  provider
                                                                .getEntity,
                                                            project:  provider
                                                                .getEntity,
                                                            entityType: widget
                                                                .entityType,
                                                            path: path,
                                                            tableName: tableName,
                                                            id: id,
                                                            type:provider
                                                                .getTabData[index]
                                                            ['TAB_LIST_MODULE']
                                                                .toString()
                                                                .toLowerCase(),
                                                            title: provider
                                                                .getTabData[index]
                                                            ['TAB_DESC']
                                                                .toString(),
                                                            list: dynamicList,
                                                            isSelectable: false,
                                                            isEditable: true,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              }
                                              if(provider
                                                  .getTabData[index]
                                              ['TAB_DESC']=="Projects") {
                                                if ( provider
                                                    .getEntity["PROJECT_ID"] ==
                                                    null) {
                                                  ErrorUtil.showErrorMessage(
                                                      context,
                                                      "No Project linked to this Action");
                                                }
                                                else {
                                                  var entity = await DynamicProjectService()
                                                      .getEntityById("PROJECT",
                                                      provider
                                                          .getEntity['PROJECT_ID'] ?? "");
                                                  Map<String,
                                                      dynamic>dynamicList = {
                                                    "Items": [entity] ?? []
                                                  };
                                                  print(
                                                      "entity check $dynamicList");
                                                  Navigator.push(
                                                    context,
                                                    platformPageRoute(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) =>
                                                          DynamicRelatedEntityScreen(
                                                            entity:  provider
                                                                .getEntity,
                                                            project:  provider
                                                                .getEntity,
                                                            entityType: widget
                                                                .entityType,
                                                            path: path,
                                                            tableName: tableName,
                                                            id: id,
                                                            type: provider
                                                                .getTabData[index]
                                                            ['TAB_LIST_MODULE']
                                                                .toString()
                                                                .toLowerCase(),
                                                            title: provider
                                                                .getTabData[index]
                                                            ['TAB_DESC']
                                                                .toString(),
                                                            list: dynamicList,
                                                            isSelectable: false,
                                                            isEditable: true,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              }
                                              if(provider
                                                  .getTabData[index]
                                              ['TAB_DESC']=="Contacts") {
                                                if ( provider
                                                    .getEntity["CONT_ID"]==null) {
                                                  ErrorUtil.showErrorMessage(context, "No Contact linked to this Action");
                                                }
                                                else {
                                                  var entity = await DynamicProjectService()
                                                      .getEntityById("CONTACT",
                                                      provider
                                                          .getEntity['CONT_ID'] ?? "");
                                                  print("entity$entity");
                                                  Map<String,
                                                      dynamic>dynamicList = {
                                                    "Items": [entity] ?? []
                                                  };
                                                  print(
                                                      "entity check $dynamicList");
                                                  Navigator.push(
                                                    context,
                                                    platformPageRoute(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) =>
                                                          DynamicRelatedEntityScreen(
                                                            entity:  provider
                                                                .getEntity,
                                                            project:  provider
                                                                .getEntity,
                                                            entityType: widget
                                                                .entityType,
                                                            path: path,
                                                            tableName: tableName,
                                                            id: id,
                                                            type:provider
                                                                .getTabData[index]
                                                            ['TAB_LIST_MODULE']
                                                                .toString()
                                                                .toLowerCase(),
                                                            title: provider
                                                                .getTabData[index]
                                                            ['TAB_DESC']
                                                                .toString(),
                                                            list: dynamicList,
                                                            isSelectable: false,
                                                            isEditable: true,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }
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
                                                    provider.getTabData[index]
                                                            ['TAB_DESC']
                                                        .toString(),
                                                    textAlign: TextAlign.right,
                                                    softWrap: true,
                                                    style: TextStyle()),
                                              ),
                                            ),
                                            Spacer(),
                                            if (provider.getTabData[index]
                                                    ['TAB_TYPE'] ==
                                                'L') ...[
                                              Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 15.0),
                                                  child: CircleAvatar(
                                                    radius: 8,
                                                    backgroundColor: Color(
                                                        int.parse(provider
                                                            .getTabData[index]
                                                                ['TAB_HEX']
                                                            .toString())),
                                                  )),
                                            ] else ...[
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
                ]),
              );
            });
  }
}
