import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_tabs.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicProjectListItemWidget extends EntityListItemWidget {
  const DynamicProjectListItemWidget({
    Key? key,
    required entity,
    required refresh,
    bool isSelectable = false,
    required bool isEditable,
    this.onEdit,
    this.onDelete,
  })  : assert(entity != null),
        super(
          key: key,
          entity: entity,
          refresh: refresh,
          isSelectable: isSelectable,
          isEditable: isEditable,
        );

  final Function()? onEdit;
  final Function()? onDelete;

  @override
  _ProjectListItemWidgetState createState() => _ProjectListItemWidgetState();
}

class _ProjectListItemWidgetState
    extends EntityListItemWidgetState<DynamicProjectListItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(


      // title: Padding(
      //   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      //   child: Text(
      //     widget.entity['PROJECT_TITLE'] ?? '',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          //   child: Text(
          //     widget.entity['SITE_TOWN'] ?? '',
          //     style: TextStyle(
          //       color: Colors.black87,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      '${LangUtil.getString('PROJECT', 'PROJECT_ID')} :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      '${LangUtil.getString('PROJECT', 'PROJECT_TITLE')} :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                          child: Text(
                            '${LangUtil.getString('PROJECT', 'SITE_TOWN')} :',
                            style: TextStyle(fontWeight: FontWeight.w700,color: Colors.red),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                          child: Text(
                            '${LangUtil.getString('PROJECT', 'SELLINGSTATUS_ID')} :',
                            style: TextStyle(fontWeight: FontWeight.w700,color: Colors.red),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                ],
              ),
              SizedBox(width: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Text(
                      widget.entity['PROJECT_ID'],
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Text(
                      widget.entity['PROJECT_TITLE'],
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Text(
                              widget.entity['SITE_TOWN'] != null
                                  ? widget.entity['SITE_TOWN']
                                  : '',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Text(
                              widget.entity['SELLINGSTATUS_ID'] != null
                                  ? widget.entity['SELLINGSTATUS_ID']
                                  : '',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                ],
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
              //       child: Text(
              //         '${LangUtil.getString('PROJECT', 'PROJECT_VALUE')} :',
              //         style: TextStyle(fontWeight: FontWeight.w700),
              //         overflow: TextOverflow.ellipsis,
              //         softWrap: false,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
              //       child: Text(
              //         '${LangUtil.getString('PROJECT', 'VALUE_TO_US')} :',
              //         style: TextStyle(fontWeight: FontWeight.w700),
              //         overflow: TextOverflow.ellipsis,
              //         softWrap: false,
              //       ),
              //     ),
              //   ],
              // ),
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              //         child: Text(
              //           widget.entity['PROJECT_VALUE'] != null
              //               ? NumberFormat('#,###')
              //               .format(widget.entity['PROJECT_VALUE'])
              //               : '',
              //           overflow: TextOverflow.ellipsis,
              //           softWrap: false,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              //         child: Text(
              //           widget.entity['VALUE_TO_US'] != null
              //               ? NumberFormat('#,###')
              //               .format(widget.entity['VALUE_TO_US'])
              //               : '',
              //           overflow: TextOverflow.ellipsis,
              //           softWrap: false,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          if (widget.isEditable)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onEdit,
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: widget.onDelete,
                  child: Text('Delete'),
                )
              ],
            )
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(context.platformIcons.rightChevron),
        ],
      ),
      onTap: () async {
        if (widget.isSelectable) {
          Navigator.pop(context, {
            'ID': widget.entity['PROJECT_ID'],
            'TEXT': widget.entity['PROJECT_TITLE'],
            'ACCT_ID': widget.entity['PROJECT_ID'],
            'ACCTNAME': widget.entity['PROJECT_TITLE'],
          });
          return;
        }

        context.loaderOverlay.show();

        dynamic project =
        await ProjectService().getEntity(widget.entity['PROJECT_ID']);
        log("${project.data.toString()}");

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProjectTabs(
                project: project.data,
                // projectData: dataList,
                title: widget.entity['PROJECT_TITLE'],
                readonly: true,
              );
              // return ProjectEditScreen(
              //   project: project.data,
              //   readonly: true,
              // );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
    //   ListTile(
    //   dense: true,
    //   title: Padding(
    //     padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
    //     child: Text(
    //       widget.entity['PROJECT_TITLE'] ?? '',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    //   subtitle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
    //         child: Text(
    //           widget.entity['SITE_TOWN'] ?? '',
    //           style: TextStyle(
    //             color: Colors.black87,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       ),
    //       Row(
    //         children: [
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
    //                 child: Text(
    //                   '${LangUtil.getString('PROJECT', 'START_DATE')} :',
    //                   style: TextStyle(fontWeight: FontWeight.w700),
    //                   overflow: TextOverflow.ellipsis,
    //                   softWrap: false,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
    //                 child: Text(
    //                   '${LangUtil.getString('PROJECT', 'END_DATE')} :',
    //                   style: TextStyle(fontWeight: FontWeight.w700),
    //                   overflow: TextOverflow.ellipsis,
    //                   softWrap: false,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Expanded(
    //             flex: 2,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
    //                   child: Text(
    //                     DateUtil.getFormattedDate(widget.entity['START_DATE']),
    //                     overflow: TextOverflow.ellipsis,
    //                     softWrap: false,
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
    //                   child: Text(
    //                     DateUtil.getFormattedDate(widget.entity['END_DATE']),
    //                     overflow: TextOverflow.ellipsis,
    //                     softWrap: false,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
    //                 child: Text(
    //                   '${LangUtil.getString('PROJECT', 'PROJECT_VALUE')} :',
    //                   style: TextStyle(fontWeight: FontWeight.w700),
    //                   overflow: TextOverflow.ellipsis,
    //                   softWrap: false,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
    //                 child: Text(
    //                   '${LangUtil.getString('PROJECT', 'VALUE_TO_US')} :',
    //                   style: TextStyle(fontWeight: FontWeight.w700),
    //                   overflow: TextOverflow.ellipsis,
    //                   softWrap: false,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Expanded(
    //             flex: 1,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
    //                   child: Text(
    //                     widget.entity['PROJECT_VALUE'] != null
    //                         ? NumberFormat('#,###')
    //                             .format(widget.entity['PROJECT_VALUE'])
    //                         : '',
    //                     overflow: TextOverflow.ellipsis,
    //                     softWrap: false,
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
    //                   child: Text(
    //                     widget.entity['VALUE_TO_US'] != null
    //                         ? NumberFormat('#,###')
    //                             .format(widget.entity['VALUE_TO_US'])
    //                         : '',
    //                     overflow: TextOverflow.ellipsis,
    //                     softWrap: false,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       if (widget.isEditable)
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             TextButton(
    //               onPressed: widget.onEdit,
    //               child: Text('Edit'),
    //             ),
    //             TextButton(
    //               onPressed: widget.onDelete,
    //               child: Text('Delete'),
    //             )
    //           ],
    //         )
    //     ],
    //   ),
    //   trailing: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(context.platformIcons.rightChevron),
    //     ],
    //   ),
    //   onTap: () async {
    //     if (widget.isSelectable) {
    //       Navigator.pop(context, {
    //         'ID': widget.entity['PROJECT_ID'],
    //         'TEXT': widget.entity['PROJECT_TITLE'],
    //         'ACCT_ID': widget.entity['PROJECT_ID'],
    //         'ACCTNAME': widget.entity['PROJECT_TITLE'],
    //       });
    //       return;
    //     }
    //
    //     context.loaderOverlay.show();
    //
    //     dynamic project =
    //         await ProjectService().getEntity(widget.entity['PROJECT_ID']);
    //         log("${project.data.toString()}");
    //
    //     context.loaderOverlay.hide();
    //
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) {
    //           return ProjectTabs(
    //             project: project.data,
    //            // projectData: dataList,
    //             title: widget.entity['PROJECT_TITLE'],
    //             readonly: true,
    //           );
    //           // return ProjectEditScreen(
    //           //   project: project.data,
    //           //   readonly: true,
    //           // );
    //         },
    //       ),
    //     ).then((value) => widget.refresh());
    //   },
    // );
  }
}
