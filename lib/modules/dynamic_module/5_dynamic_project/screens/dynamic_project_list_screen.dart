import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_quotation_add.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
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
  State<DynamicProjectListScreen> createState() => _DynamicProjectListScreenState();
}

class _DynamicProjectListScreenState extends State<DynamicProjectListScreen> {
  DynamicProjectService service = DynamicProjectService();
  List<dynamic> sortBy=[];
  List<dynamic> filterBy=[];

  @override
  void initState() {
    super.initState();
  }

  Future<List<List<dynamic>>> fetchData() async {
    List<dynamic> sortValue = await service.getSortValues(widget.listName);
    List<dynamic> filterValue = await service.getFilterValues(widget.listName);
    print("filter value$filterValue");
    int sortOrder;
    for (int i = 0; i < sortValue.length; i++) {
      if (sortValue[i]["VAR_VALUE"] == "ASC") {
        sortOrder = 1;
      } else {
        sortOrder = 2;
      }
      sortBy.add({
        'TableName': widget.listType,
        'FieldName': sortValue[i]["VAR_NAME"],
        'SortOrder': sortOrder,
        'SortIndex': 0
      });
    }
    for (int i = 0; i < filterValue.length; i++) {
      filterBy.add({
        'TableName': widget.listType,
        'FieldName': filterValue[i]["VAR_NAME"],
        'Comparison': '5',
        'ItemValue': filterValue[i]["VAR_VALUE"],
      });
    }
    return [sortBy,filterBy];
  }

  @override
  Widget build(BuildContext context) {
    print("sortby data check$filterBy");
    return FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PsaScaffold(title: "${capitalizeFirstLetter(widget.listType)} - List",body: SizedBox()); // You can show a loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
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
                      type: widget.listType
                  );
                },
                type: widget.listType,
                list: widget.listName,
                sortBy: sortBy,
                filterBy:filterBy,
              ),
              action: PsaAddButton(
                onTap: () {
                  print("checking list type");
                  print(widget.listType);
                  if (widget.listType == "COMPANY") {
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            CompanyEditScreen(
                              company: {},
                              readonly: false,
                            ),
                      ),
                    );
                  }
                  else if (widget.listType == "CONTACT") {
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            ContactEditScreen(
                              contact: {},
                              readonly: false,
                            ),
                      ),
                    );
                  }
                  else if (widget.listType == "ACTION") {
                    Navigator.pushNamed(context, '/action/type');
                  }
                  else if (widget.listType == "OPPORTUNITY") {
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            OpportunityEditScreen(
                              deal: {},
                              readonly: false,
                            ),
                      ),
                    );
                  }
                  else if (widget.listType == "QUOTATION") {
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            DynamicQuotationAddScreen(
                              quotation: {},
                              readonly: false,
                            ),
                      ),
                    );
                  }
                  else if (widget.listType == "PROJECT") {
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
                },
              ),
            );
          }
        }
    );
  }
}
