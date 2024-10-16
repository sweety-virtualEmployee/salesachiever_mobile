import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectStaffZoneFilterValueScreen extends StatelessWidget {
  final String title;
  final String field;
  final String condition;
  final String contextId;
  final String relatedEntityType;
  final String staffZoneListTitle;
  final String id;
  final String tableName;
  final String staffZoneType;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  SelectStaffZoneFilterValueScreen({
    Key? key,
    required this.title,
    required this.field,
    required this.condition,
    required this.contextId,
    required this.tableName,
    required this.staffZoneType,
    required this.relatedEntityType,
    this.sortBy,
    required this.id,
    required this.staffZoneListTitle,
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
                onTap: () {
                  List<dynamic> filter =
                  List<dynamic>.from(filterBy ?? []);

                  filter.add({
                    'TableName': tableName,
                    'FieldName': field,
                    'Comparison': condition,
                    'ItemValue': items[index].itemId,
                  });

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context,filter);
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
