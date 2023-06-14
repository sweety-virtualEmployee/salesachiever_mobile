import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_report_pdf_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_view_related_records.dart';
import 'package:salesachiever_mobile/shared/screens/dynamic_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/decode_base64_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

import '../../../3_company/services/company_service.dart';

class ProjectTabs extends StatefulWidget {
  // final List <ProjectForm>projectData;
  final Map<String, dynamic> project;
  final String title;
  final bool readonly;
  final String? tabId;
  final String? moduleId;
  final String? tabType;
  final String? projectName;
  final Function refresh;
  final String entityType;
  const ProjectTabs({
    Key? key,
    required this.readonly,
    required this.title,
    required this.refresh,
    this.tabId,
    this.projectName,
    this.tabType,
    required this.entityType,
    this.moduleId,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectTabs> createState() => _ProjectTabsState();
}

class _ProjectTabsState extends State<ProjectTabs> {
  DynamicProjectService service = DynamicProjectService();
  DynamicProjectApi service1 = DynamicProjectApi();
  bool _readonly = true;
  dynamic _entity;

  @override
  void initState() {
    _entity = this.widget.project;
    print("account name sche");
    print(_entity["ACCTNAME"]);
    print(widget.moduleId);
    print(widget.tabId);
    if(widget.tabType == "P"){
      print(widget.moduleId);
      print(widget.moduleId);
      service.getEntitySubTabForm(widget.moduleId.toString(), widget.tabId.toString());
    }
    else{
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
    print("project data ${_entity}");
    print("project data ${widget.entityType}");
    return PsaScaffold(
      title: "${capitalizeFirstLetter(widget.entityType)} Tabs" ,
      body: FutureBuilder(
          future:widget.tabType == "P"?service.getEntitySubTabForm(widget.moduleId.toString(), widget.tabId.toString()): service.getProjectTabs(widget.moduleId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Container(
                  height: 61,
                    child: CommonHeader(entityType: widget.entityType, entity: _entity)),
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
                                  color: Colors.black,
                                ),
                                itemCount: jsonDecode(jsonEncode(snapshot.data))
                                    .length,
                                itemBuilder: (context, index) {
                                  var titleText = jsonDecode(
                                              jsonEncode(snapshot.data))[index]
                                          ['TAB_HEX']
                                      .toString();
                                  return GestureDetector(
                                    onTap: () async {
                                      //context.loaderOverlay.show();
                                      if (jsonDecode(jsonEncode(snapshot.data))[
                                              index]['TAB_TYPE'] ==
                                          "C") {
                                        print("yes");
                                        print(jsonDecode(
                                            jsonEncode(snapshot
                                                .data))[index]);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DynamicProjectEditScreen(
                                                projectName: jsonDecode(
                                                            jsonEncode(snapshot
                                                                .data))[index]
                                                        ['TAB_DESC']
                                                    .toString(),
                                                project: widget.project,
                                             tabId: jsonDecode(jsonEncode(
                                                        snapshot.data))[index]
                                                    ['TAB_ID'],
                                                readonly: true,
                                                entityType: widget.entityType,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      else if (jsonDecode(jsonEncode(snapshot.data))[
                                      index]['TAB_TYPE'] ==
                                          "P") {
                                        print("parent module");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ProjectTabs(
                                                project: widget.project,
                                                entityType: widget.entityType,
                                                projectName: jsonDecode(
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
                                                tabType:jsonDecode(jsonEncode(snapshot.data))[
                                                index]['TAB_TYPE'],                                                  title: _entity?['PROJECT_TITLE'] ??
                                                    LangUtil.getString('Entities', 'Project.Create.Text'),
                                                readonly: true, refresh: widget.refresh,
                                              );
                                            },
                                          ),
                                        ).then((value) => widget.refresh());
                                      }
                                      else if (jsonDecode(jsonEncode(snapshot.data))[
                                      index]['TAB_TYPE'] ==
                                          "L"){
                                        String path="";
                                        String tableName="";
                                        String id="";
                                        if(widget.entityType=="COMPANY"){
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].replaceAll("@RECORDID",
                                              _entity?['ACCT_ID']);
                                        } else if(widget.entityType=="CONTACT"){
                                          print("i am in contact");
                                          if(jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].contains("@RECORDID")) {
                                            path = jsonDecode(
                                                jsonEncode(snapshot
                                                    .data))[index]
                                            ['TAB_LIST'].replaceAll("@RECORDID",
                                                _entity?['CONT_ID']);
                                          }
                                          else{
                                            print("ConteID${ _entity?['CONT_ID']}");
                                            path = jsonDecode(
                                                jsonEncode(snapshot
                                                    .data))[index]
                                            ['TAB_LIST'];
                                            id=_entity?['CONT_ID'];
                                            tableName = "CONTACT";
                                          }
                                        } else if(widget.entityType=="ACTION"){
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].replaceAll("@RECORDID",
                                              _entity?['ACTION_ID']);
                                        }else if(widget.entityType=="OPPORTUNITY") {
                                          print(
                                              "opportunity module ${_entity?['DEAL_ID']}");
                                          if (jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].contains("@RECORDID")) {
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].replaceAll("@RECORDID",
                                              _entity?['DEAL_ID']);
                                        }
                                        else{
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'];
                                          id = _entity?['DEAL_ID'];
                                          tableName = "DEAL";
                                          print("check here id$id");
                                        }
                                        }else if(widget.entityType=="PROJECT"){
                                            path = jsonDecode(
                                                jsonEncode(snapshot
                                                    .data))[index]
                                            ['TAB_LIST'].replaceAll("@RECORDID",
                                                _entity?['PROJECT_ID']);
                                        } else{
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'];
                                          id=   _entity?['CONT_ID'];
                                          tableName = "CONTACT";
                                        }
                                        var result = await service.getTabListEntityApi(path.replaceAll("&amp;", "&"),tableName,id);
                                        Navigator.push(
                                          context,
                                          platformPageRoute(
                                            context: context,
                                            builder: (BuildContext context) => DynamicRelatedEntityScreen(
                                              entity: _entity,
                                              project: _entity,
                                              entityType: widget.entityType,
                                              type:jsonDecode(
                                                  jsonEncode(snapshot
                                                      .data))[index]
                                              ['TAB_LIST_MODULE']
                                                  .toString().toLowerCase(),
                                              title: jsonDecode(
                                                  jsonEncode(snapshot
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
                                      context.loaderOverlay.hide();
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
                                              padding: const EdgeInsets.only(left: 8.0),
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
                                          if(jsonDecode(jsonEncode(
                                              snapshot
                                                  .data))[
                                          index]
                                          ['TAB_TYPE'] ==
                                              'L')...[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child:  CircleAvatar(
                                                radius: 8,
                                                backgroundColor: Color(
                                                    int.parse(jsonDecode(
                                                        jsonEncode(
                                                            snapshot
                                                                .data))[
                                                    index]['TAB_HEX']
                                                        .toString())),
                                              )
                                            ),
                                          ]
                                          else...[
                                            SizedBox(width: 30,)
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                widget.entityType=="COMPANY"?GestureDetector(
                  onTap: () async {
                    var data = await service.getSubScribedReports();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) {
                      return DynamicReportScreen(
                         reports: data,
                        id:_entity?['ACCT_ID']
                      );
                    },
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: PlatformText("Profile Reports"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.file_copy_rounded,color: Colors.grey,),
                        )
                      ],
                    ),
                  ),
                ):SizedBox()
              ]);
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
