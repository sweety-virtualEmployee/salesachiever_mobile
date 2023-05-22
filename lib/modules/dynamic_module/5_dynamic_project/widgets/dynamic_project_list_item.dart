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
    this.onDelete, required  this.type,
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
  final String type;

  @override
  _ProjectListItemWidgetState createState() => _ProjectListItemWidgetState();
}

class _ProjectListItemWidgetState
    extends EntityListItemWidgetState<DynamicProjectListItemWidget> {
  @override
  void initState() {
   print("listitem:type ${widget.type}");
    print("entity${widget.entity}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'COMPANY') {
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
                      'Account Name :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Address :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Town :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Account_Type :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.green),
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
                        widget.entity['ACCOUNT_ACCTNAME'],
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['ACCOUNT_ADDR1']!=null?widget.entity['ACCOUNT_ADDR1']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['ACCOUNT_TOWN'] != null
                            ? widget.entity['ACCOUNT_TOWN']
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['ACCOUNT_ACCT_TYPE_ID'] != null
                            ? widget.entity['ACCOUNT_ACCT_TYPE_ID']
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
            'ID': widget.entity['ACCT_ID'],
            'TEXT': widget.entity['ACCOUNT_ACCTNAME'],
            'ACCT_ID': widget.entity['PROJECT_ID'],
            'ACCTNAME': widget.entity['PROJECT_TITLE'],
          });
          return;
        }

        context.loaderOverlay.show();
        dynamic project = await DynamicProjectService().getEntityById(widget.type,widget.entity['ACCT_ID']);

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
                moduleId: "003",
                entityType: widget.type,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
    } else {
      if (widget.type == 'OPPORTUNITY') {
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
                      'Deal Id :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffA4C400)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Deal Creator :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffA4C400)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Deal Description :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffA4C400)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Created On :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffA4C400)),
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
                        widget.entity['DEAL_ID'],
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['DEAL_CREATOR_ID']!=null?widget.entity['DEAL_CREATOR_ID']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['DEAL_DESCRIPTION'] != null
                            ? widget.entity['DEAL_DESCRIPTION']
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['DEAL_CREATED_ON'] != null
                            ? widget.entity['DEAL_CREATED_ON']
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
            'ID': widget.entity['ACCT_ID'],
            'TEXT': widget.entity['ACCOUNT_ACCTNAME'],
            'ACCT_ID': widget.entity['PROJECT_ID'],
            'ACCTNAME': widget.entity['PROJECT_TITLE'],
          });
          return;
        }

        context.loaderOverlay.show();
        dynamic project = await DynamicProjectService().getEntityById(widget.type,widget.entity['DEAL_ID']);

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
                moduleId: "006",
                entityType: widget.type,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
      } else {
        return widget.type=='CONTACT'? ListTile(
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
                      'First Name :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xff4C99E0)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Last Name:',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Account Id :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xff4C99E0)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Telephone :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xff4C99E0)),
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
                        widget.entity['FIRSTNAME']!=null?widget.entity['FIRSTNAME']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['SURNAME']!=null?widget.entity['SURNAME']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['ACCT_ID'] != null
                            ? widget.entity['ACCT_ID']
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['TEL_DIRECT'] != null
                            ? widget.entity['TEL_DIRECT']
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
            'ID': widget.entity['ACCT_ID'],
            'TEXT': widget.entity['FIRSTNAME'],
            'ACCT_ID': widget.entity['ACCT_ID'],
            'ACCTNAME': widget.entity['SURNAME'],
          });
          return;
        }

        context.loaderOverlay.show();
        dynamic project = await DynamicProjectService().getEntityById(widget.type,widget.entity['CONT_ID']);

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
                moduleId: "004",
                entityType: widget.type,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    ): widget.type == 'PROJECT'? ListTile(
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
                moduleId: "005",
                entityType: widget.type,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    ):widget.type=='ACTION'?ListTile(
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
                      'Cont Id :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffae1a3e)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Action Type :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffae1a3e)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Description :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffae1a3e)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Text(
                      'Account Date :',
                      style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffae1a3e)),
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
                        widget.entity['CONT_ID']!=null?widget.entity['CONT_ID']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['ACTION_TYPE_ID']!=null?widget.entity['ACTION_TYPE_ID']:"",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['DESCRIPTION'] != null
                            ? widget.entity['DESCRIPTION']
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['ACTION_DATE'] != null
                            ? widget.entity['ACTION_DATE']
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
            'ID': widget.entity['ACCT_ID'],
            'TEXT': widget.entity['ACCOUNT_ACCTNAME'],
            'ACCT_ID': widget.entity['PROJECT_ID'],
            'ACCTNAME': widget.entity['PROJECT_TITLE'],
          });
          return;
        }

        context.loaderOverlay.show();
        dynamic project = await DynamicProjectService().getEntityById(widget.type,widget.entity['ACTION_ID']);

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
                moduleId: "009",
                entityType: widget.type,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    ):SizedBox();
      }
    }
  }
}
