import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ProjectTabs extends StatefulWidget {
  // final List <ProjectForm>projectData;
  final Map<String, dynamic> project;
  final String title;
  final bool readonly;
  const ProjectTabs({
    Key? key,
    // required this.projectData,
    required this.readonly,
    required this.title,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectTabs> createState() => _ProjectTabsState();
}

class _ProjectTabsState extends State<ProjectTabs> {
  DynamicProjectService service = DynamicProjectService();
  bool _readonly = true;
  dynamic _project;
  bool _isValid = false;
  @override
  void initState() {
    _project = this.widget.project;
    service.getProjectTabs();
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
      title: LangUtil.getString('Entities', 'Project.Description') + " - Tabs",
      body: FutureBuilder(
          future: service.getProjectTabs(),
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
                // DynamicPsaHeader(
                //     isVisible: true,
                //     icon: 'assets/images/projects_icon.png',
                //     title: _project['PROJECT_TITLE'], projectID: _project['PROJECT_ID'], status: "Pending", createdBY: "hugugu",
                //
                //
                // ),
                //Container(height: 20,color: Colors.black,),
                Container(
                  color: Colors.white,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      CupertinoFormSection(
                        backgroundColor:
                            CupertinoColors.systemGroupedBackground,
                        //const Color(0xFFFAFAFA),
                        children: [
                          Column(
                            children: [
                              // Container(
                              //   height: 20,
                              //   color: Colors.black,
                              // ),
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
                                                // projectData: widget.projectData,
                                                readonly: true,
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
                                                    // backgroundColor: titleText ==
                                                    //         "Companies"
                                                    //     ? Colors.green
                                                    //     : titleText == "Contact"
                                                    //         ? Colors.blue
                                                    //         : titleText ==
                                                    //                 "Project"
                                                    //             ? Colors.red
                                                    //             : titleText ==
                                                    //                     "Actions"
                                                    //                 ? Colors
                                                    //                     .yellow
                                                    //                 : titleText ==
                                                    //                         "Opportunities"
                                                    //                     ? Colors
                                                    //                         .lightGreen
                                                    //                     : Colors
                                                    //                         .grey,
                                                    // child: Text(
                                                    //   jsonDecode(jsonEncode(
                                                    //               snapshot
                                                    //                   .data))[
                                                    //           index]['ITEM_COUNT']
                                                    //       .toString(),
                                                    //   style: TextStyle(
                                                    //       color: Colors.black,
                                                    //       fontSize: 12),
                                                    // ),
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
                                  //  ListTile(
                                  //   dense: true,
                                  //   contentPadding: EdgeInsets.symmetric(
                                  //       horizontal: 0.0, vertical: 0.0),
                                  //   visualDensity:
                                  //       VisualDensity(horizontal: 0, vertical: -4),
                                  //   title: Padding(
                                  //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  //     child: PlatformText(
                                  //         jsonDecode(jsonEncode(snapshot.data))[index]
                                  //                 ['TAB_DESC']
                                  //             .toString(),
                                  //              textAlign: TextAlign.right,
                                  //         style: TextStyle()),
                                  //   ),
                                  //   trailing: Icon(
                                  //     context.platformIcons.rightChevron,
                                  //     size: 20,
                                  //   ),
                                  //   // contentPadding: const EdgeInsets.only(right: 0),
                                  //   onTap: () {
                                  //     if (jsonDecode(jsonEncode(snapshot.data))[index]
                                  //             ['TAB_TYPE'] ==
                                  //         "C") {
                                  //       Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) {
                                  //             return ProjectEditScreen(
                                  //               project: widget.project,
                                  //               readonly: true,
                                  //             );
                                  //           },
                                  //         ),
                                  //       );
                                  //       //                     Navigator.push(
                                  //       //   context,
                                  //       //   platformPageRoute(
                                  //       //     context: context,
                                  //       //     builder: (BuildContext context) => DynamicProjectEditScreen(
                                  //       //       project: {},
                                  //       //       readonly: false,
                                  //       //  )));
                                  //       // Navigator.push(
                                  //       //   context,
                                  //       //   MaterialPageRoute(
                                  //       //     builder: (context) {
                                  //       //       return DynamicProjectInfoScreen(
                                  //       //         // onSave: widget._onSave,
                                  //       //         //    onBack: widget._onBack
                                  //       //            );
                                  //       //       // return ProjectEditScreen(
                                  //       //       //   project: project.data,
                                  //       //       //   readonly: true,
                                  //       //       // );
                                  //       //     },
                                  //       //   ),
                                  //       // );
                                  //     }
                                  //   },
                                  // );
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
      // action: PsaEditButton(
      //   text: _readonly ? 'Edit' : 'Save',
      //   onTap: (_isValid || _readonly) ? onTap : null,
      // ),
    );
  }
}
