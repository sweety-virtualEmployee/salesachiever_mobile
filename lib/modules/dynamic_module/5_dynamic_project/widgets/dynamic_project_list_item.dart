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
  Map<String,dynamic> map= Map<String,dynamic>();
  @override
  void initState() {
    map = widget.entity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("entity data${map}");
    if (widget.type == 'COMPANY') {
      return ListTile(
      subtitle: ListView.builder(
        itemCount: map.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final key = map.keys.elementAt(index);
          final value = map[key];
          String contextId = key.substring(0,key.indexOf('_'));
          String itemId = key.contains("_")?key.substring(key.indexOf("_")+1):key;
          List<String> parts = key.split('_');
          print("parts$key${parts.length}");
          print("conetxtsdbid${contextId}");
          print("erfafxsgasjf${itemId}");
          if(key.contains("_ID")&&parts.length<3){
            return SizedBox();
          }
          else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LangUtil.getString(contextId,itemId) } :',
                          style: TextStyle(fontWeight: FontWeight.w700,
                              color: Color(0xff3cab4f)),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          value!=null?value.toString():"",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
      subtitle:ListView.builder(
        itemCount: map.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final key = map.keys.elementAt(index);
          final value = map[key];
          String contextId = key.substring(0,key.indexOf('_'));
          String itemId = key.contains("_")?key.substring(key.indexOf("_")+1):key;
          List<String> parts = key.split('_');
          print("parts$key${parts.length}");
          print("conetxtsdbid${contextId}");
          print("erfafxsgasjf${itemId}");
          if(key.contains("_ID")&&parts.length<4){
            return SizedBox();
          }
          else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LangUtil.getString(contextId,itemId) } :',
                          style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffA4C400)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          value!=null?value.toString():"",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
      subtitle:ListView.builder(
        itemCount: map.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final key = map.keys.elementAt(index);
          final value = map[key];
          List<String> parts = key.split('_');
          String contextId = key.contains("_")?key.substring(0,key.indexOf('_')):"CONTACT";
          String itemId = key.contains("_")?key.substring(key.indexOf("_")+1):key;
          if(key.contains("_ID")&&parts.length<3){
            return SizedBox();
          }
          else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LangUtil.getString(contextId,itemId) } :',
                          style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xff4C99E0)),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          value!=null?value.toString():"",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
      subtitle:ListView.builder(
        itemCount: map.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final key = map.keys.elementAt(index);
          final value = map[key];
          String contextId = key.substring(0,key.indexOf('_'));
          String itemId = key.contains("_")?key.substring(key.indexOf("_")+1):key;
          List<String> parts = key.split('_');
          print("parts$key${parts.length}");
          print("conetxtsdbid${contextId}");
          print("erfafxsgasjf${itemId}");
          if(key.contains("_ID")&&parts.length<3){
            return SizedBox();
          }
          else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LangUtil.getString(contextId,itemId) } :',
                          style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffE67E6B)),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          value!=null?value.toString():"",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
      subtitle: ListView.builder(
        itemCount: map.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final key = map.keys.elementAt(index);
          final value = map[key];
          List<String> parts = key.split('_');
          print("sadrtfYDJHSCF${key}${parts.length-1}");
          String contextId = key.contains("__")?"ACTION":key.contains("_")?key.substring(0,key.indexOf('_')):"ACTION";
          String itemId = key.contains("_")?key.substring(key.indexOf("_")+1):key;
          print("conetxtchvs$contextId");
          print("itemID$itemId");
          if((key.contains("_ID")&&parts.length<3)||key.contains("__")||key.contains("ACTION_SAUSER")){
            return SizedBox();
          }
          else {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LangUtil.getString(contextId,itemId) } :',
                          style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffae1a3e)),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          value!=null?value.toString():"",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
