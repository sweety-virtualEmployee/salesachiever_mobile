import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_view_related_records.dart';
import 'package:salesachiever_mobile/shared/screens/dynamic_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
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
  dynamic _project;

  @override
  void initState() {
    _project = this.widget.project;
    print("check tge id");
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
    print("project data ${_project["ACCT_TYPE_ID"]}");
    return PsaScaffold(
      title: "${capitalizeFirstLetter(widget.entityType)} Tabs" ,
      body: FutureBuilder(
          future:widget.tabType == "P"?service.getEntitySubTabForm(widget.moduleId.toString(), widget.tabId.toString()): service.getProjectTabs(widget.moduleId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                widget.entityType=="COMPANY"?DynamicPsaHeader(
                  isVisible: true,
                  icon: 'assets/images/company_icon.png',
                  title: _project?['ACCTNAME'],
                  projectID: _project?['ACCT_ID'],
                  status: _project?['ACCT_TYPE_ID'],
                  siteTown: _project?['ADDR1'],
                  backgroundColor: Color(0xff3cab4f),
                ):DynamicPsaHeader(
                  isVisible: true,
                  icon: 'assets/images/projects_icon.png',
                  title: _project?['PROJECT_TITLE'] ??
                      LangUtil.getString('Entities', 'Project.Create.Text'),
                  projectID: _project?['PROJECT_ID'],
                  status: _project?['SELLINGSTATUS_ID'],
                  siteTown: _project?['OWNER_ID'],
                  backgroundColor: Color(0xffE67E6B),
                ),
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
                                      context.loaderOverlay.show();
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
                                                index]['TAB_TYPE'],                                                  title: _project?['PROJECT_TITLE'] ??
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
                                        print("true");
                                        String path;
                                        if(widget.entityType=="COMPANY"){
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].replaceAll("@RECORDID",
                                              _project?['ACCT_ID']);
                                        }else {
                                          path = jsonDecode(
                                              jsonEncode(snapshot
                                                  .data))[index]
                                          ['TAB_LIST'].replaceAll("@RECORDID",
                                              _project?['PROJECT_ID']);
                                        }
                                        print(path.replaceAll("&amp;", "&"));
                                        print("check the tab type${jsonDecode(jsonEncode(snapshot
                                                .data))[index]
                                        ['TAB_LIST_MODULE']
                                            .toString().toLowerCase()}");

                                        var result = await service.getTabListEntityApi(path.replaceAll("&amp;", "&"));

                                        Navigator.push(
                                          context,
                                          platformPageRoute(
                                            context: context,
                                            builder: (BuildContext context) => DynamicRelatedEntityScreen(
                                              entity: _project,
                                              project: _project,
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
                                             /*   child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text(service.getTabsListCount( _project?['PROJECT_ID'], "type").then((value){
                                                    value["Count"];
                                                  }).toString()),
                                                ),*/
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
                )
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
