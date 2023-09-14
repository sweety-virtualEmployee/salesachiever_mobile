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
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectFilterValueScreen extends StatelessWidget {
  final String title;
  final String entity;
  final String field;
  final String list;
  final String condition;
  final String contextId;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  SelectFilterValueScreen({
    Key? key,
    required this.title,
    required this.entity,
    required this.field,
    required this.list,
    required this.condition,
    required this.contextId,
    this.sortBy,
    this.filterBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> items = LangUtil.getLocaleList(contextId);
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Text(
                    items[index].displayValue,
                  ),
                ),
                onTap: () async {
                  List<dynamic> response = await DynamicProjectService()
                      .setFilterValue(list, field, items[index].itemId,condition);
                  print("response check");
                  print(response[0]);
                  Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (BuildContext context) {
                        List<dynamic> filter = new List<dynamic>.empty(growable: true);
                        if (AuthUtil.hasAccess(int.parse(
                            ACCESS_CODES['Saving sort and filters']
                                .toString()))) {
                          if (filterBy != null) filter.addAll(filterBy!);
                          for (int i = 0; i < response.length; i++) {
                            filter.add({
                              'TableName': entity,
                              'FieldName': response[i]["VAR_NAME"],
                              'Comparison': condition,
                              'ItemValue': "${response[i]["VAR_VALUE"]}",
                            });
                          }
                        } else {
                          if (filterBy != null) filter.addAll(filterBy!);

                          filter.add({
                            'TableName': entity,
                            'FieldName': field,
                            'Comparison': condition,
                            'ItemValue': items[index].itemId,
                          });}

                          return DynamicProjectListScreen(
                            listType: entity,
                            sortBy: sortBy,
                            filterBy: filter,
                            listName: list,
                          );
                        }
                    ),
                  );
                });
          },
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
