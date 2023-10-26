import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/0_home/screens/home_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_staffzone_list_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class SelectStaffZoneSortOrderScreen extends StatelessWidget {
  final String title;
  final String entity;
  final String field;
  final String list;
  final String id;
  final List<dynamic>? sortBy;
  final List<dynamic> items = [
    {'key': 1, 'value': 'Ascending'},
    {'key': 2, 'value': 'Desending'},
  ];

  SelectStaffZoneSortOrderScreen({
    Key? key,
    required this.title,
    required this.entity,
    required this.field,
    required this.list,
    this.sortBy,
    required this.id,
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
              onTap: () => Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) {
                    List<dynamic> sort =
                    new List<dynamic>.empty(growable: true);

                    if (sortBy != null) sort.addAll(sortBy!);

                    sort.add({
                      'TableName': entity,
                      'FieldName': field,
                      'SortOrder': items[index]['key'],
                      'SortIndex': 0
                    });

                    print("sortbyb dta$sort");
                    print("sortby$list");
                    print("sortby$id");
                    print("sortby$entity");

                      return DynamicStaffZoneListScreen(
                        sortBy: sort,
                        staffZoneType:entity,
                        id: id,
                        relatedEntityType: list,
                      );
                      },
                ),
              ),
            );
          },
          itemCount: 2,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}