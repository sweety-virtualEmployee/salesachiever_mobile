import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_notes.dart';
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
  final bool isRelatedEntity;

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
    required this.isRelatedEntity,
  }) : super(key: key);

  @override
  State<DynamicTabScreen> createState() => _DynamicTabScreenState();
}

class _DynamicTabScreenState extends State<DynamicTabScreen> {
  DynamicProjectService service = DynamicProjectService();
  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = Provider.of<DynamicTabProvide>(context, listen: false);
    _dynamicTabProvider.setEntity(widget.entity);
    fetchData();
    super.initState();
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
    return Consumer<DynamicTabProvide>(builder: (context, provider, child) {
      return PsaScaffold(
        onBackPressed: (){
          print("isRelated${widget.isRelatedEntity}");
          provider.setEntity(provider.getTemporaryEntity);
          Navigator.pop(context);
        },
        title: "${capitalizeFirstLetter(widget.entityType)} Tabs",
        body: Column(
          children: [
            Container(height: 70,child: CommonHeader(entityType: widget.entityType.toUpperCase(), entity: provider.getEntity)),
            Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CupertinoFormSection(
                    backgroundColor: CupertinoColors.systemGroupedBackground,
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
                              return GestureDetector(
                                onTap: () async {
                                  if (provider.getTabData[index]['TAB_TYPE'] == "C") {
                                    _onCTap(provider, index);
                                  } else if (provider.getTabData[index]['TAB_TYPE'] == "P") {
                                    _onPTap(provider, index);
                                  } else if (provider.getTabData[index]['TAB_TYPE'] == "L") {
                                    _onLTap(provider, index);
                                  }
                                },
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: PlatformText(
                                            provider.getTabData[index]['TAB_DESC'].toString(),
                                            textAlign: TextAlign.right,
                                            softWrap: true,
                                            style: TextStyle(),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      _buildTabTypeIcon(provider, index),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Icon(
                                          context.platformIcons.rightChevron,
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
          ],
        ),
      );
    });
  }
  void _onCTap(DynamicTabProvide provider, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicEditScreen(
          entityName: provider.getTabData[index]['TAB_DESC'].toString(),
          entity: provider.getEntity,
          tabId: provider.getTabData[index]['TAB_ID'],
          readonly: true,
          entityType: widget.entityType,
        ),
      ),
    );
  }

  void _onPTap(DynamicTabProvide provider, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicTabScreen(
          entity: provider.getEntity,
          entityType: widget.entityType,
          entityName: provider.getTabData[index]['TAB_DESC'].toString(),
          tabId: provider.getTabData[index]['TAB_ID'],
          moduleId: provider.getTabData[index]['MODULE_ID'],
          tabType: provider.getTabData[index]['TAB_TYPE'],
          title: provider.getEntity['PROJECT_TITLE'] ?? LangUtil.getString('Entities', 'Project.Create.Text'),
          readonly: true,
          isRelatedEntity: false,
        ),
      ),
    );
  }
  void _onLTap(DynamicTabProvide provider, int index) async {
    await provider.setTemporaryEntity(provider.getEntity);
    if (provider.getEntity.isEmpty) {
      ErrorUtil.showErrorMessage(context, "Please create the record first");
    } else {
      String path = provider.getTabData[index]['TAB_LIST'];
      String tableName = "";
      String id = "";

      if (widget.entityType.toUpperCase() == "COMPANY") {
        path = path.replaceAll("@RECORDID", provider.getEntity['ACCT_ID']);
      } else if (widget.entityType.toUpperCase() == "CONTACT") {
        path = path.replaceAll("@RECORDID", provider.getEntity['CONT_ID']);
      } else if (widget.entityType.toUpperCase() == "OPPORTUNITY") {
        path = path.replaceAll("@RECORDID", provider.getEntity['DEAL_ID']);
      } else if (widget.entityType.toUpperCase() == "PROJECT") {
        path = path.replaceAll("@RECORDID", provider.getEntity['PROJECT_ID']);
      }

      if (widget.entityType != "ACTION") {
        var result = await service.getTabListEntityApi(path.replaceAll("&amp;", "&"), tableName, id, 1);
        Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => DynamicRelatedEntityScreen(
              entity: provider.getEntity,
              project: provider.getEntity,
              entityType: widget.entityType,
              path: path,
              tableName: tableName,
              id: id,
              type: provider.getTabData[index]['TAB_LIST_MODULE'].toString().toLowerCase(),
              title: provider.getTabData[index]['TAB_DESC'].toString(),
              list: result ?? [],
              isSelectable: false,
              isEditable: true,
            ),
          ),
        );
      } else {
        if(provider.getTabData[index]['TAB_DESC'] == "Notes"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DynamicProjectNotes(
                  project: provider.getEntity,
                  notesData: {},
                  typeNote: provider.getTabData[index]['TAB_LIST_MODULE'].toString().toLowerCase(),
                  isNewNote: true,
                  entityType: widget.entityType,
                );
              },
            ),
          );
        }
        else if (provider.getTabData[index]['TAB_DESC'] == "Companies") {
          if (provider.getEntity["ACCT_ID"] == null) {
            ErrorUtil.showErrorMessage(context, "No Company linked to this Action");
          } else {
            var entity = await DynamicProjectService().getEntityById("COMPANY", provider.getEntity['ACCT_ID']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DynamicTabScreen(
                  entity: entity.data,
                  title: provider.getEntity['ACCTNAME'] != null ? provider.getEntity['ACCTNAME'] : "",
                  readonly: true,
                  moduleId: "003",
                  entityType: "COMPANY",
                  isRelatedEntity: true,
                ),
              ),
            );
          }
        }if (provider.getTabData[index]['TAB_DESC'] == "Projects") {
          if (provider.getEntity["PROJECT_ID"] == null) {
            ErrorUtil.showErrorMessage(context, "No Project linked to this Action");
          } else {
            var entity = await DynamicProjectService().getEntityById("PROJECT", provider.getEntity['PROJECT_ID']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DynamicTabScreen(
                  entity: entity.data,
                  title: provider.getEntity['PROJECT_TITLE'] != null ? provider.getEntity['PROJECT_TITLE'] : "",
                  readonly: true,
                  moduleId: "005",
                  entityType: "PROJECT",
                  isRelatedEntity: true,
                ),
              ),
            );
          }
        }
        if (provider.getTabData[index]['TAB_DESC'] == "Contacts") {
          if (provider.getEntity["CONT_ID"] == null) {
            ErrorUtil.showErrorMessage(context, "No Contact linked to this Action");
          } else {
            var entity = await DynamicProjectService().getEntityById("COMPANY", provider.getEntity['CONT_ID']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: entity.data,
                    title: provider.getEntity['FIRSTNAME'] != null
                        ? provider.getEntity['FIRSTNAME']
                        : "",
                    readonly: true,
                    moduleId: "004",
                    entityType: "CONTACT",
                    isRelatedEntity: true,
                  );
                },
              ),
            );
          }
        }

      }
    }
  }

  Widget _buildTabTypeIcon(DynamicTabProvide provider, int index) {
    if (provider.getTabData[index]['TAB_TYPE'] == 'L') {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: CircleAvatar(
          radius: 8,
          backgroundColor: Color(int.parse(provider.getTabData[index]['TAB_HEX'].toString())),
        ),
      );
    } else {
      return SizedBox(width: 30);
    }
  }       
}



