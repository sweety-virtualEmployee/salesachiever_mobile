import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/0_home/screens/home_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectSortOrderScreen extends StatelessWidget {
  final String title;
  final String entity;
  final String field;
  final String list;
  final List<dynamic>? sortBy;
  final List<dynamic> items = [
    {
      'key': 1,
      'value': LangUtil.getString('Entities', 'List.SortSet.Ascending.Text')
    },
    {
      'key': 2,
      'value': LangUtil.getString('Entities', 'List.SortSet.Descending.Text')
    },
  ];

  SelectSortOrderScreen({
    Key? key,
    required this.title,
    required this.entity,
    required this.field,
    required this.list,
    this.sortBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: title,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (
            BuildContext _context,
            int index,
          ) {
            return InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Text(
                  items[index]['value'],
                ),
              ),
              onTap: () async {
                String sortOrder;
                if (items[index]['key'] == 1) {
                  sortOrder = "ASC";
                } else {
                  sortOrder = "DESC";
                }
                List<dynamic> response = await DynamicProjectService()
                    .setSortValue(list, field, sortOrder);
                print("response check");
                print(response[0]);
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) {
                      List<dynamic> sort =
                      new List<dynamic>.empty(growable: true);
                      if (AuthUtil.hasAccess(int.parse(
                          ACCESS_CODES['Saving sort and filters']
                              .toString()))) {


                        if (sortBy != null) sort.addAll(sortBy!);
                        for (int i = 0; i < response.length; i++) {
                          sort.add({
                            'TableName': entity,
                            'FieldName': response[i]["VAR_NAME"],
                            'SortOrder': response[i]["VAR_VALUE"],
                            'SortIndex': 0
                          });
                        }
                      } else {

                        if (sortBy != null) sort.addAll(sortBy!);

                        sort.add({
                          'TableName': entity,
                          'FieldName': field,
                          'SortOrder': items[index]['key'],
                          'SortIndex': 0
                        });
                        print("entity check $sort");
                      }
                      return DynamicProjectListScreen(
                        listType: entity,
                        sortBy: sort,
                        listName: list,
                      );
                    },
                  ),
                );
              },
            );
          },
          itemCount: 2,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26 /**/,
          ),
        ),
      ),
    );
  }
}
