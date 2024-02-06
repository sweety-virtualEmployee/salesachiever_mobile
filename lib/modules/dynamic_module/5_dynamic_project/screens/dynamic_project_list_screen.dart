import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_quotation_add.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_tab_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
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
    print("sort by $sortBy");
  }

  Future<void> fetchData() async {
    List<dynamic> sortValue = await service.getSortValues(widget.listName);
    List<dynamic> filterValue = await service.getFilterValues(widget.listName);
    print("filter value$filterValue");
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
        print("lenth of filter value${filterValue[i]["VAR_VALUE"]}");
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
    print("filter by array $filterBy"); 
  }

  @override
  Widget build(BuildContext context) {
    print("sortby data check$filterBy");
    if (isDataLoaded) {
      return PsaScaffold(
      title: "${capitalizeFirstLetter(widget.listType)} - List",
      body: PsaEntityListView(
        service: DynamicProjectService(listName: widget.listName),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          print("entity passed$entity");
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
          print("checking list type");
          print(widget.listType);
          if (widget.listType == "COMPANY") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: {},
                    title: "Add New Company",
                    readonly: true,
                    moduleId: "003",
                    entityType: widget.listType,
                  );
                },
              ),
            );
          } else if (widget.listType == "CONTACT") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: {},
                    title: "Add New Contact",
                    readonly: true,
                    moduleId: "004",
                    entityType: widget.listType,
                  );
                },
              ),
            );
          } else if (widget.listType == "ACTION") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: {},
                    title: "Add New Action",
                    readonly: true,
                    moduleId: "009",
                    entityType: widget.listType,
                  );
                },
              ),
            );
          } else if (widget.listType == "OPPORTUNITY") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: {},
                    title: "Add New Opportunity",
                    readonly: true,
                    moduleId: "006",
                    entityType: widget.listType,
                  );
                },
              ),
            );
          } else if (widget.listType == "QUOTATION") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: {},
                    title: "Add New Quotation",
                    readonly: true,
                    moduleId: "007",
                    entityType: widget.listType,
                  );
                },
              ),
            );
          } else if (widget.listType == "PROJECT") {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicTabScreen(
                    entity: {},
                    title: "Add New Project",
                    readonly: true,
                    moduleId: "005",
                    entityType: widget.listType,
                  );
                },
              ),
            );
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
