import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/company/dynamic_company_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/contact/dynamic_contact_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_notes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/opportunity/dynamic_opportunity_edit_scrren.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/opportunity/dynamic_opportunity_info_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/opportunity/dynamic_opportunity_related_entity.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicOpportunityTabScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final String title;
  final bool readonly;
  final String? tabId;
  final String? moduleId;
  final String? tabType;
  final String? entityName;
  final String entityType;
  final bool isRelatedEntity;

  const DynamicOpportunityTabScreen({
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
  State<DynamicOpportunityTabScreen> createState() => _DynamicOpportunityTabScreenState();
}

class _DynamicOpportunityTabScreenState extends State<DynamicOpportunityTabScreen> {
  DynamicProjectService service = DynamicProjectService();
  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = Provider.of<DynamicTabProvide>(context, listen: false);
    print("widget.entityType${widget.entityType}");
    _dynamicTabProvider.setOpportunityEntity(widget.entity);
    fetchData();
    super.initState();
  }

  List<dynamic> tabOpportunityData = [];


  Future<void> fetchData() async {
    context.loaderOverlay.show();
    try {
      var data = await (widget.tabType == "P"
          ? service.getEntitySubTabForm(
          widget.moduleId.toString(), widget.tabId.toString())
          : service.getProjectTabs(widget.moduleId.toString()));
      setState(() {
        tabOpportunityData = data;
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
    context.loaderOverlay.hide();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicTabProvide>(builder: (context, provider, child) {
      return PsaScaffold(
        title: "${capitalizeFirstLetter(widget.entityType)} Tabs",
        body: Column(
          children: [
            Container(height: 80,
                child: CommonHeader(entityType: widget.entityType.toUpperCase(), entity: provider.getOpportunityEntity)),
            ListView(
              shrinkWrap: true,
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
                      itemCount: tabOpportunityData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (tabOpportunityData[index]['TAB_TYPE'] == "C") {
                              _onCTap(provider, index);
                            }  else if (tabOpportunityData[index]['TAB_TYPE'] == "I") {
                              _onITap(provider, index);
                            } else if (tabOpportunityData[index]['TAB_TYPE'] == "P") {
                              _onPTap(provider, index);
                            } else if (tabOpportunityData[index]['TAB_TYPE'] == "L") {
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
                                      tabOpportunityData[index]['TAB_DESC'].toString(),
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
      );
    });
  }
  void _onITap(DynamicTabProvide provider, int index)  {
     Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DynamicOpportunityInfoScreen(
                    deal: provider.getOpportunityEntity,
                    readonly: widget.readonly,
                    onBack: () {},
                    onSave: () {}
                )));
  }
  void _onCTap(DynamicTabProvide provider, int index) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DynamicOpportunityEditScreen(
                entityName: tabOpportunityData[index]['TAB_DESC']
                    .toString(),
                entity: provider.getOpportunityEntity,
                tabId: tabOpportunityData[index]['TAB_ID'],
                readonly: widget.readonly,
                entityType: widget.entityType,
              ),
        ),
      );
  }

  Future<void> _onPTap(DynamicTabProvide provider, int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicOpportunityTabScreen(
          entity: provider.getOpportunityEntity,
          entityType: widget.entityType,
          entityName: tabOpportunityData[index]['TAB_DESC'].toString(),
          tabId: tabOpportunityData[index]['TAB_ID'],
          moduleId: tabOpportunityData[index]['MODULE_ID'],
          tabType: tabOpportunityData[index]['TAB_TYPE'],
          title: provider.getOpportunityEntity['PROJECT_TITLE'] ?? LangUtil.getString('Entities', 'Project.Create.Text'),
          readonly: widget.readonly,
          isRelatedEntity: false,
        ),
      ),
    );
  }
  void _onLTap(DynamicTabProvide provider, int index) async {
    if (provider.getOpportunityEntity.isEmpty) {
      ErrorUtil.showErrorMessage(context, "Please create the record first");
    } else {
      String path = tabOpportunityData[index]['TAB_LIST'];
      String tableName = "";
      String id = "";
      path = path.replaceAll("@RECORDID", provider.getOpportunityEntity['DEAL_ID']);
      var result = await service.getTabListEntityApi(path.replaceAll("&amp;", "&"), tableName, id, 1);
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (BuildContext context) => DynamicOpportunityRelatedEntityScreen(
            entity: provider.getOpportunityEntity,
            project: provider.getOpportunityEntity,
            entityType: widget.entityType,
            path: path,
            tableName: tableName,
            id: id,
            type: tabOpportunityData[index]['TAB_LIST_MODULE'].toString().toLowerCase(),
            title: tabOpportunityData[index]['TAB_DESC'].toString(),
            list: result ?? [],
            isSelectable: false,
            isEditable: true,
          ),
        ),
      );
    }
  }

  Widget _buildTabTypeIcon(DynamicTabProvide provider, int index) {
    if (tabOpportunityData[index]['TAB_TYPE'] == 'L') {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: CircleAvatar(
          radius: 8,
          backgroundColor: Color(int.parse(tabOpportunityData[index]['TAB_HEX'].toString())),
        ),
      );
    } else {
      return SizedBox(width: 30);
    }
  }
}



