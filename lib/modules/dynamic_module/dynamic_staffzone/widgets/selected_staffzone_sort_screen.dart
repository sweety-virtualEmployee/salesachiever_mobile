import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/staffzone_sort_fields_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectedStaffZoneSortFieldsScreen extends StatelessWidget {
  final String relatedEntityType;
  final String tableName;
  final String staffZoneType;
  final String id;
  final String staffZoneListTitle;
  final String title;
  final List<dynamic>? sortBy;

  const SelectedStaffZoneSortFieldsScreen(
      {Key? key,
      required this.tableName,
      required this.relatedEntityType,
      required this.staffZoneType,
      required this.id,
      required this.staffZoneListTitle,
      required this.title,
      this.sortBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: title,
      body: ListView.separated(
        itemBuilder: (BuildContext _context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: PlatformText(
                    '${LangUtil.getString(staffZoneType, sortBy?[index]['FieldName'])} (${sortBy?[index]['SortOrder'] == 1 ? 'Ascending' : 'Descending'})',
                  ),
                ),
                onTap: () => print('lll'),
              ),
              sortBy?.length != 0
                  ? IconButton(
                      onPressed: () async {
                        sortBy!.removeWhere((item) =>
                            item['FieldName'] == sortBy?[index]['FieldName']);
                        Navigator.pop(
                            context, sortBy); // Pass updated sortBy back
                      },
                      icon: Icon(
                        context.platformIcons.clear,
                        color: Colors.red,
                      ),
                    )
                  : SizedBox()
            ],
          );
        },
        itemCount: sortBy?.length ?? 0,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black26,
        ),
      ),
      action: PsaAddButton(
        onTap: () => Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => StaffZoneSortFieldsScreen(
              title: title,
              tableName: tableName,
              relatedEntityType: relatedEntityType,
              sortBy: sortBy,
              staffZoneType: staffZoneType,
              staffZoneListTitle: staffZoneListTitle,
              id: id,
            ),
          ),
        ),
      ),
    );
  }
}
