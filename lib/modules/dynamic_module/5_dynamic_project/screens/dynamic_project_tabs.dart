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
  const ProjectTabs({
    Key? key,
    required this.readonly,
    required this.title,
    required this.refresh,
    this.tabId,
    this.projectName,
    this.tabType,
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
    if(widget.tabType == "P"){
      service.getEntitySubTabForm(widget.moduleId.toString(), widget.tabId.toString());
    }
    else{
      service.getProjectTabs();
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
    print("project data ${_project['OWNER_ID']}");
    return PsaScaffold(
      title: LangUtil.getString('Entities', 'Project.Description') + " -  ${widget.projectName==null?"Tabs":widget.projectName}",
      body: FutureBuilder(
          future:widget.tabType == "P"?service.getEntitySubTabForm(widget.moduleId.toString(), widget.tabId.toString()): service.getProjectTabs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                DynamicPsaHeader(
                  isVisible: true,
                  icon: 'assets/images/projects_icon.png',
                  title: _project?['PROJECT_TITLE'] ??
                      LangUtil.getString('Entities', 'Project.Create.Text'),
                  projectID: _project?['PROJECT_ID'],
                  status: _project?['SELLINGSTATUS_ID'],
                  siteTown: _project?['OWNER_ID'],
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
                                        String path=jsonDecode(
                                            jsonEncode(snapshot
                                                .data))[index]
                                        ['TAB_LIST'].replaceAll("@RECORDID", _project?['PROJECT_ID']);
                                        print(path.replaceAll("&amp;", "&"));

                                        var result = await service.getTabListEntityApi(path.replaceAll("&amp;", "&"));

                                        /* var result = await CompanyService().getRelatedEntity(
                                            'project',
                                            _project?['PROJECT_ID'],
                                            jsonDecode(
                                                jsonEncode(snapshot
                                                    .data))[index]
                                            ['TAB_DESC']
                                                .toString());*/

                                        Navigator.push(
                                          context,
                                          platformPageRoute(
                                            context: context,
                                            builder: (BuildContext context) => DynamicRelatedEntityScreen(
                                              entity: _project,
                                              project: _project,
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
