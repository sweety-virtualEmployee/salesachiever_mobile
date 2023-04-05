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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                            '${LangUtil.getString('PROJECT', 'OWNER_ID')} :',
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
              Expanded(
                child: Column(
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
                        widget.entity['PROJECT_PROJECT_TITLE']!=null?widget.entity['PROJECT_PROJECT_TITLE']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Text(
                                widget.entity['PROJECT_OWNER_ID'] != null
                                    ? widget.entity['PROJECT_OWNER_ID']
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Text(
                                widget.entity['PROJECT_SELLINGSTATUS_ID'] != null
                                    ? widget.entity['PROJECT_SELLINGSTATUS_ID']
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                  ],
                ),
              ),
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
        print("project list");
        log("${project.data.toString()}");

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProjectTabs(
                project: project.data,
                title: widget.entity['PROJECT_TITLE']!=null?widget.entity['PROJECT_TITLE']:"",
                readonly: true,
                refresh: widget.refresh,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
  }
}
