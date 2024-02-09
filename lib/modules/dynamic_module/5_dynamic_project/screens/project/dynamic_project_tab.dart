import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_info_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_related_entity.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicProjectTabScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final String title;
  final bool readonly;
  final String? tabId;
  final String? moduleId;
  final String? tabType;
  final String? entityName;
  final String entityType;
  final bool isRelatedEntity;

  const DynamicProjectTabScreen({
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
  State<DynamicProjectTabScreen> createState() => _DynamicProjectTabScreenState();
}

class _DynamicProjectTabScreenState extends State<DynamicProjectTabScreen> {
  DynamicProjectService service = DynamicProjectService();
  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = Provider.of<DynamicTabProvide>(context, listen: false);
    _dynamicTabProvider.setProjectEntity(widget.entity);
    fetchData();
    super.initState();
  }


  Future<void> fetchData() async {
    try {
      var data = await (widget.tabType == "P"
          ? service.getEntitySubTabForm(
          widget.moduleId.toString(), widget.tabId.toString())
          : service.getProjectTabs(widget.moduleId.toString()));
      _dynamicTabProvider.setProjectData(data);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicTabProvide>(builder: (context, provider, child) {
      return PsaScaffold(
        onBackPressed: () async {
          await provider.setProjectData(provider.getTemporaryTabData);
          Navigator.pop(context);
        },
        title: "${capitalizeFirstLetter(widget.entityType)} Tabs",
        body: Column(
          children: [
            Container(height: 70,child: CommonHeader(entityType: widget.entityType.toUpperCase(), entity: provider.getProjectEntity)),
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
                            itemCount: provider.getProjectTabData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (provider.getProjectTabData[index]['TAB_TYPE'] == "C") {
                                    _onCTap(provider, index);
                                  } else if (provider.getProjectTabData[index]['TAB_TYPE'] == "P") {
                                    _onPTap(provider, index);
                                  } else if (provider.getProjectTabData[index]['TAB_TYPE'] == "L") {
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
                                            provider.getProjectTabData[index]['TAB_DESC'].toString(),
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
  Future<void> _onCTap(DynamicTabProvide provider, int index) async {
    if(provider.getProjectTabData[index]['TAB_DESC']=="Information"){
      Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) =>
              DynamicProjectInfoScreen(
                project:provider.getProjectEntity,
                readonly: true,
                onBack: (){},
                onSave: (){}
              )));
    }
    else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DynamicProjectEditScreen(
                entityName: provider.getProjectTabData[index]['TAB_DESC']
                    .toString(),
                entity: provider.getProjectEntity,
                tabId: provider.getProjectTabData[index]['TAB_ID'],
                readonly: true,
                entityType: widget.entityType,
              ),
        ),
      );
    }
  }

  Future<void> _onPTap(DynamicTabProvide provider, int index) async {
    await provider.setTemporaryData(provider.getProjectTabData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicProjectTabScreen(
          entity: provider.getProjectEntity,
          entityType: widget.entityType,
          entityName: provider.getProjectTabData[index]['TAB_DESC'].toString(),
          tabId: provider.getProjectTabData[index]['TAB_ID'],
          moduleId: provider.getProjectTabData[index]['MODULE_ID'],
          tabType: provider.getProjectTabData[index]['TAB_TYPE'],
          title: provider.getProjectEntity['PROJECT_TITLE'] ?? LangUtil.getString('Entities', 'Project.Create.Text'),
          readonly: true,
          isRelatedEntity: false,
        ),
      ),
    );
  }
  void _onLTap(DynamicTabProvide provider, int index) async {
    print("on tap L ${widget.entityType}");
    if (provider.getProjectEntity.isEmpty) {
      ErrorUtil.showErrorMessage(context, "Please create the record first");
    } else {
      String path = provider.getProjectTabData[index]['TAB_LIST'];
      String tableName = "";
      String id = "";
      if (widget.entityType.toUpperCase() == "PROJECT") {
        path = path.replaceAll("@RECORDID", provider.getProjectEntity['PROJECT_ID']);
        var result = await service.getTabListEntityApi(path.replaceAll("&amp;", "&"), tableName, id, 1);
        Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => DynamicProjectRelatedEntityScreen(
              entity: provider.getProjectEntity,
              project: provider.getProjectEntity,
              entityType: widget.entityType,
              path: path,
              tableName: tableName,
              id: id,
              type: provider.getProjectTabData[index]['TAB_LIST_MODULE'].toString().toLowerCase(),
              title: provider.getProjectTabData[index]['TAB_DESC'].toString(),
              list: result ?? [],
              isSelectable: false,
              isEditable: true,
            ),
          ),
        );
      }
    }
  }

  Widget _buildTabTypeIcon(DynamicTabProvide provider, int index) {
    if (provider.getProjectTabData[index]['TAB_TYPE'] == 'L') {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: CircleAvatar(
          radius: 8,
          backgroundColor: Color(int.parse(provider.getProjectTabData[index]['TAB_HEX'].toString())),
        ),
      );
    } else {
      return SizedBox(width: 30);
    }
  }
}



