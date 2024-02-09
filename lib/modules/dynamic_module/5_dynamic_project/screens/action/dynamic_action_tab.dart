import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_edit.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_info_Screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_related_entity.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/company/dynamic_company_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/contact/dynamic_contact_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_notes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicActionTabScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final String title;
  final bool readonly;
  final String? tabId;
  final String? moduleId;
  final String? tabType;
  final String? entityName;
  final String entityType;
  final bool isRelatedEntity;

  const DynamicActionTabScreen({
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
  State<DynamicActionTabScreen> createState() => _DynamicActionTabScreenState();
}

class _DynamicActionTabScreenState extends State<DynamicActionTabScreen> {
  DynamicProjectService service = DynamicProjectService();
  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = Provider.of<DynamicTabProvide>(context, listen: false);
    print("widget.entityType1${widget.entity}");
    _dynamicTabProvider.setActionEntity(widget.entity);
    fetchData();
    super.initState();
  }


  Future<void> fetchData() async {
    try {
      var data = await (widget.tabType == "P"
          ? service.getEntitySubTabForm(
          widget.moduleId.toString(), widget.tabId.toString())
          : service.getProjectTabs(widget.moduleId.toString()));
      _dynamicTabProvider.setActionData(data);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicTabProvide>(builder: (context, provider, child) {
      return PsaScaffold(
        title: "${capitalizeFirstLetter(widget.entityType)} Tabs",
        body: Column(
          children: [
            Container(height: 70,child: CommonHeader(entityType: widget.entityType.toUpperCase(), entity: provider.getActionEntity)),
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
                            itemCount: provider.getActionTabData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (provider.getActionTabData[index]['TAB_TYPE'] == "C") {
                                    _onCTap(provider, index);
                                  } else if (provider.getActionTabData[index]['TAB_TYPE'] == "P") {
                                    _onPTap(provider, index);
                                  } else if (provider.getActionTabData[index]['TAB_TYPE'] == "L") {
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
                                            provider.getActionTabData[index]['TAB_DESC'].toString(),
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
    if (provider.getActionTabData[index]['TAB_DESC'] == "Information") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DynamicActionInfoScreen(
                      action: provider.getActionEntity,
                      readonly: true,
                      onBack: () {},
                      onSave: () {}
                  )));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DynamicActionEditScreen(
                entityName: provider.getActionTabData[index]['TAB_DESC']
                    .toString(),
                entity: provider.getActionEntity,
                tabId: provider.getActionTabData[index]['TAB_ID'],
                readonly: true,
                entityType: widget.entityType,
              ),
        ),
      );
    }
  }

  void _onPTap(DynamicTabProvide provider, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicActionTabScreen(
          entity: provider.getActionEntity,
          entityType: widget.entityType,
          entityName: provider.getActionTabData[index]['TAB_DESC'].toString(),
          tabId: provider.getActionTabData[index]['TAB_ID'],
          moduleId: provider.getActionTabData[index]['MODULE_ID'],
          tabType: provider.getActionTabData[index]['TAB_TYPE'],
          title: provider.getActionEntity['PROJECT_TITLE'] ?? LangUtil.getString('Entities', 'Project.Create.Text'),
          readonly: true,
          isRelatedEntity: false,
        ),
      ),
    );
  }
  void _onLTap(DynamicTabProvide provider, int index) async {
    if (provider.getActionEntity.isEmpty) {
      ErrorUtil.showErrorMessage(context, "Please create the record first");
    } else {
      if(provider.getActionTabData[index]['TAB_DESC'] == "Notes"){
        print(provider.getActionEntity);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicProjectNotes(
                project: provider.getActionEntity,
                notesData: {},
                typeNote: provider.getActionEntity["ACTION_ID"],
                isNewNote: true,
                entityType: widget.entityType,
              );
            },
          ),
        );
      }
      else if (provider.getActionTabData[index]['TAB_DESC'] == "Companies") {
        if (provider.getActionEntity["ACCT_ID"] == null) {
          ErrorUtil.showErrorMessage(context, "No Company linked to this Action");
        } else {
          var entity = await DynamicProjectService().getEntityById("COMPANY", provider.getActionEntity['ACCT_ID']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicCompanyTabScreen(
                entity: entity.data,
                title: provider.getActionEntity['ACCTNAME'] != null ? provider.getActionEntity['ACCTNAME'] : "",
                readonly: true,
                moduleId: "003",
                entityType: "COMPANY",
                isRelatedEntity: true,
              ),
            ),
          );
        }
      }if (provider.getActionTabData[index]['TAB_DESC'] == "Projects") {
        if (provider.getActionEntity["PROJECT_ID"] == null) {
          ErrorUtil.showErrorMessage(context, "No Project linked to this Action");
        } else {
          var entity = await DynamicProjectService().getEntityById("PROJECT", provider.getActionEntity['PROJECT_ID']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicProjectTabScreen(
                entity: entity.data,
                title: provider.getActionEntity['PROJECT_TITLE'] != null ? provider.getActionEntity['PROJECT_TITLE'] : "",
                readonly: true,
                moduleId: "005",
                entityType: "PROJECT",
                isRelatedEntity: true,
              ),
            ),
          );
        }
      }
      if (provider.getActionTabData[index]['TAB_DESC'] == "Contacts") {
        if (provider.getActionEntity["CONT_ID"] == null) {
          ErrorUtil.showErrorMessage(context, "No Contact linked to this Action");
        } else {
          var entity = await DynamicProjectService().getEntityById("CONTACT", provider.getActionEntity['CONT_ID']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DynamicContactTabScreen(
                  entity: entity.data,
                  title: provider.getActionEntity['FIRSTNAME'] != null
                      ? provider.getActionEntity['FIRSTNAME']
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

  Widget _buildTabTypeIcon(DynamicTabProvide provider, int index) {
    if (provider.getActionTabData[index]['TAB_TYPE'] == 'L') {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: CircleAvatar(
          radius: 8,
          backgroundColor: Color(int.parse(provider.getActionTabData[index]['TAB_HEX'].toString())),
        ),
      );
    } else {
      return SizedBox(width: 30);
    }
  }
}



