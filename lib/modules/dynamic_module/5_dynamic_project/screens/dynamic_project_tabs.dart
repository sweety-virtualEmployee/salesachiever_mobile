import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_view_related_records.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

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
    print("project data $_project");
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
                  siteTown: _project?['SITE_TOWN'],
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
                                    onTap: () {
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
                                      else{
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DynamicProjectViewRelatedRecords(
                                                entity: widget.project,
                                                projectId: _project['PROJECT_ID'] ?? '',
                                              );
                                            },
                                          ),
                                        );
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
                                          SizedBox(
                                            width: 110,
                                            child: PlatformText(
                                                jsonDecode(jsonEncode(snapshot
                                                            .data))[index]
                                                        ['TAB_DESC']
                                                    .toString(),
                                                textAlign: TextAlign.right,
                                                maxLines: 2,
                                                softWrap: true,
                                                style: TextStyle()),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: jsonDecode(jsonEncode(snapshot
                                                                        .data))[
                                                                    index][
                                                                'TAB_HEX']
                                                            .toString() !=
                                                        null &&
                                                    jsonDecode(jsonEncode(
                                                                    snapshot
                                                                        .data))[
                                                                index]
                                                            ['TAB_TYPE'] ==
                                                        'L'
                                                ? CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor: Color(
                                                        int.parse(jsonDecode(
                                                                    jsonEncode(
                                                                        snapshot
                                                                            .data))[
                                                                index]['TAB_HEX']
                                                            .toString())),
                                                  )
                                                : SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: Icon(
                                              context
                                                  .platformIcons.rightChevron,
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
