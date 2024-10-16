import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_type_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/company/dynamic_company_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/contact/dynamic_contact_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_quotation_add.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/quotation/dynamic_quotation_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicProjectListScreen extends StatefulWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String listName;
  final String listType;
  final bool isSelectable;

  const DynamicProjectListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.listName,
    required this.listType,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  State<DynamicProjectListScreen> createState() =>
      _DynamicProjectListScreenState();
}

class _DynamicProjectListScreenState extends State<DynamicProjectListScreen> {
  DynamicProjectService service = DynamicProjectService();
  List<dynamic>? sortBy = [];
  List<dynamic>? filterBy = [];
  bool isDataLoaded = false; // Track whether data has been loaded

  @override
  void initState() {
    super.initState();
    print("list value");
    print(widget.listType);
    print(widget.listName);
    if(AuthUtil.hasAccess(
        int.parse(ACCESS_CODES['Saving sort and filters'].toString()))){
      fetchData();

    }
    else{
     fetchDefaultValue();
    }
  }

  Future<void> fetchDefaultValue()async {
    setState(() {
      sortBy = widget.sortBy;
      filterBy = widget.filterBy;
      isDataLoaded = true;
    });
  }

  Future<void> fetchData() async {
    List<dynamic> sortValue = await service.getSortValues(widget.listName);
    List<dynamic> filterValue = await service.getFilterValues(widget.listName);
    setState(() {
      int sortOrder;
      for (int i = 0; i < sortValue.length; i++) {
        if (sortValue[i]["VAR_VALUE"] == "ASC") {
          sortOrder = 1;
        } else {
          sortOrder = 2;
        }
        sortBy?.add({
          'TableName': widget.listType,
          'FieldName': sortValue[i]["VAR_NAME"],
          'SortOrder': sortOrder,
          'SortIndex': 0
        });
      }
      for (int i = 0; i < filterValue.length; i++) {
        if (filterValue[i]["VAR_VALUE"] != null) {
          List<String> varValueParts = filterValue[i]["VAR_VALUE"].split(':');
          if (varValueParts.length == 2) {
            String beforeColon = varValueParts[0].trim();
            String afterColon = varValueParts[1].trim();
            filterBy?.add({
              'TableName': widget.listType,
              'FieldName': filterValue[i]["VAR_NAME"],
              'Comparison': beforeColon, // Value before colon
              'ItemValue': afterColon, // Value after colon
            });
          } else {
            print("Invalid VarValue format");
          }
        } else {
          print(filterValue[i]["VarValue"]);
        }
      }
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDataLoaded) {
      return PsaScaffold(
      title: "${capitalizeFirstLetter(widget.listType)} - List",
      body: PsaEntityListView(
        service: DynamicProjectService(listName: widget.listName),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return DynamicProjectListItemWidget(
              entity: entity,
              refresh: refresh,
              isSelectable: widget.isSelectable,
              isEditable: false,
              type: widget.listType);
        },
        type: widget.listType,
        list: widget.listName,
        sortBy: sortBy,
        filterBy: filterBy,
      ),
      action: PsaAddButton(
        onTap: () {
          if (widget.listType == "COMPANY") {
            if(AuthUtil.hasAccess(
                int.parse(ACCESS_CODES['Show Dynamic Forms for New Records'].toString()))) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicCompanyTabScreen(
                      entity: {},
                      title: "Add New Company",
                      readonly: false,
                      moduleId: "003",
                      entityType: widget.listType,
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            }
            else{
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => CompanyEditScreen(
                    company: {},
                    readonly: false,
                  ),
                ),
              );
            }
          } else if (widget.listType == "CONTACT") {
            if(AuthUtil.hasAccess(
                int.parse(ACCESS_CODES['Show Dynamic Forms for New Records'].toString()))) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicContactTabScreen(
                      entity: {},
                      title: "Add New Contact",
                      readonly: false,
                      moduleId: "004",
                      entityType: widget.listType,
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            }else{
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => ContactEditScreen(
                    contact: {},
                    readonly: false,
                  ),
                ),
              );
            }
          } else if (widget.listType == "ACTION") {
            if(AuthUtil.hasAccess(
                int.parse(ACCESS_CODES['Show Dynamic Forms for New Records'].toString()))) {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) =>
                      DynamicActionTypeScreen(
                        action: {},
                        popScreens: 2,
                        listType: widget.listType,
                      ),
                ),
              );
            }
            else{
              Navigator.pushNamed(context, '/action/type');
            }
          } else if (widget.listType == "OPPORTUNITY") {
            if(AuthUtil.hasAccess(
                int.parse(ACCESS_CODES['Show Dynamic Forms for New Records'].toString()))) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicProjectTabScreen(
                      entity: {},
                      title: "Add New Opportunity",
                      readonly: false,
                      moduleId: "006",
                      entityType: widget.listType,
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            }
            else{
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => OpportunityEditScreen(
                    deal: {},
                    readonly: false,
                  ),
                ),
              );
            }
          } else if (widget.listType == "QUOTATION") {
            if(AuthUtil.hasAccess(
                int.parse(ACCESS_CODES['Show Dynamic Forms for New Records'].toString()))) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicQuotationTabScreen(
                      entity: {},
                      title: "Add New Quotation",
                      readonly: false,
                      moduleId: "007",
                      entityType: widget.listType,
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            }
            else{
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicQuotationAddScreen(
                    quotation: {},
                    readonly: false,
                  ),
                ),
              );
            }
          } else if (widget.listType == "PROJECT") {
            if (AuthUtil.hasAccess(
                int.parse(ACCESS_CODES['Show Dynamic Forms for New Records']
                    .toString()))) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicProjectTabScreen(
                      entity: {},
                      title: "Add New Project",
                      readonly: false,
                      moduleId: "005",
                      entityType: widget.listType,
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            }
            else {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) =>
                      ProjectEditScreen(
                        project: {},
                        readonly: false,
                      ),
                ),
              );
            }
          }
        },
      ),
    );
    } else {
      return Container(
      color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.grey,

          ),
        ));
    }
  }
}
