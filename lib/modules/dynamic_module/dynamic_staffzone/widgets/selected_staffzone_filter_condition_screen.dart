import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/slected_staffzone_filter_value_screen.dart';
import 'package:salesachiever_mobile/shared/screens/filtering/select_filter_value_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/hive_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectStaffZoneFilterConditionScreen extends StatelessWidget {
  final String title;
  final String tableName;
  final String fieldName;
  final String relatedEntityType;
  final String staffZoneListTitle;
  final String id;
  final String staffZoneType;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  const SelectStaffZoneFilterConditionScreen({
    Key? key,
    required this.title,
    required this.tableName,
    required this.fieldName,
    required this.staffZoneType,
    required this.staffZoneListTitle,
    required this.id,
    this.sortBy,
    this.filterBy, required this.relatedEntityType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> conditions = [
      {
        'Id': '5',
        'Value': LangUtil.getListValue(
            'SAGridControlBaseEditors', 'FilterClauseEquals')
      },
      {
        'Id': '6',
        'Value': LangUtil.getString(
            'SAGridControlBaseEditors', 'FilterClauseDoesNotEqual')
      }
    ];

    return PsaScaffold(
      title: title,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (BuildContext _context, int index) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  conditions[index]['Value'],
                ),
              ),
              onTap: () => Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => SelectStaffZoneFilterValueScreen(
                    title: title,
                    tableName: tableName,
                    sortBy: sortBy,
                    filterBy: filterBy,
                    field: fieldName,
                    contextId:
                    HiveUtil.getContextId(tableName, tableName, fieldName),
                    condition: conditions[index]['Id'],
              staffZoneType: staffZoneType, relatedEntityType: relatedEntityType, id: id,staffZoneListTitle: staffZoneListTitle,
                  ),
                ),
              ),
            );
          },
          itemCount: conditions.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
