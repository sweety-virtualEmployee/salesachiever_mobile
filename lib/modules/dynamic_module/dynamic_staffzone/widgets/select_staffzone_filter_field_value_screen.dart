import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/selected_staffzone_filter_condition_screen.dart';
import 'package:salesachiever_mobile/shared/screens/filtering/select_filter_condition_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectStaffZoneFilterFieldScreen extends StatelessWidget {
  final String title;
  final String relatedEntityType;
  final String tableName;
  final String staffZoneType;
  final String id;
  final String staffZoneListTitle;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  const SelectStaffZoneFilterFieldScreen({
    Key? key,
    required this.title,
    required this.relatedEntityType,
    required this.tableName,
    required this.staffZoneType,
    required this.id,
    required this.staffZoneListTitle,
    this.sortBy,
    this.filterBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> lookupFields;
    lookupFields = Hive.box<dynamic>('dataDictionary')
        .values
        .where((e) =>
    e['TABLE_NAME'].toString().toLowerCase() == tableName.toLowerCase() &&
        e['FIELD_TYPE'] == 'L')
        .map((e) => {
      'TEXT': LangUtil.getListValue(tableName, e['FIELD_NAME']),
      'FIELD_NAME': e['FIELD_NAME'],
      'TABLE_NAME': e['TABLE_NAME'].toString().toUpperCase()
    })
        .toList();

    lookupFields.sort((a, b) => a['TEXT'].compareTo(b['TEXT']));
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
                  lookupFields[index]['TEXT'],
                ),
              ),
              onTap: () => Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) =>
                      SelectStaffZoneFilterConditionScreen(
                        title: lookupFields[index]['TEXT'],
                        sortBy: sortBy,
                        filterBy: filterBy,
                        tableName: lookupFields[index]['TABLE_NAME'],
                        fieldName: lookupFields[index]['FIELD_NAME'],
                        staffZoneType: staffZoneType,staffZoneListTitle: staffZoneListTitle,
                        id: id, relatedEntityType: relatedEntityType,
                      ),
                ),
              ),
            );
          },
          itemCount: lookupFields.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
