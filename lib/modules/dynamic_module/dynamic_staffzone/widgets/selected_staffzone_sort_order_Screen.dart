import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class SelectStaffZoneSortOrderScreen extends StatelessWidget {
  final String title;
  final String staffZoneType;
  final String field;
  final String relatedEntityType;
  final String staffZoneListTitle;
  final String id;
  final String tableName;
  final List<dynamic>? sortBy;
  final List<dynamic> items = [
    {'key': 1, 'value': 'Ascending'},
    {'key': 2, 'value': 'Descending'},
  ];

  SelectStaffZoneSortOrderScreen({
    Key? key,
    required this.title,
    required this.tableName,
    required this.staffZoneType,
    required this.field,
    required this.relatedEntityType,
    this.sortBy,
    required this.id,
    required this.staffZoneListTitle,
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
              onTap: () {
                List<dynamic> sort = List<dynamic>.from(sortBy ?? []);

                sort.add({
                  'TableName': tableName,
                  'FieldName': field,
                  'SortOrder': items[index]['key'],
                  'SortIndex': 0
                });

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context,sort);
               /* Navigator.pushReplacement(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) {

                      return DynamicStaffZoneListScreen(
                        tableName: tableName,
                        sortBy: sort,
                        staffZoneType: staffZoneType,
                        id: id,
                        relatedEntityType: relatedEntityType,
                        title: staffZoneListTitle,
                      );
                    },
                  ),
                );*/
              }
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