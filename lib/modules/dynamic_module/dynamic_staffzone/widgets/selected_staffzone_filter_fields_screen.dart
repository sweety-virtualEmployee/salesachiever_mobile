import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/select_staffzone_filter_field_value_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectedStaffZoneFilterFieldsScreen extends StatelessWidget {
  final String title;
  final String relatedEntityType;
  final String tableName;
  final String staffZoneType;
  final String id;
  final String staffZoneListTitle;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  const SelectedStaffZoneFilterFieldsScreen(
      {Key? key,
      required this.tableName,
      required this.relatedEntityType,
      required this.staffZoneType,
      required this.id,
      required this.staffZoneListTitle,
      required this.title,
      this.sortBy,
      this.filterBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("filter scree$filterBy");
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
                    LangUtil.getString(
                        tableName, filterBy?[index]['FieldName']),
                  ),
                ),
                onTap: () => print('lll'),
              ),
              filterBy?.length != 0
                  ? IconButton(
                      onPressed: () async {
                        filterBy!.removeWhere((item) =>
                            item['FieldName'] == filterBy?[index]['FieldName']);
                        Navigator.pop(
                            context, filterBy); // Pass updated sortBy back
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
        itemCount: filterBy?.length ?? 0,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black26,
        ),
      ),
      action: PsaAddButton(
        onTap: () => Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => SelectStaffZoneFilterFieldScreen(
              title: title,
              relatedEntityType: relatedEntityType,
              sortBy: sortBy,
              filterBy: filterBy,
              staffZoneListTitle: staffZoneListTitle,
              id: id,
              staffZoneType: staffZoneType,
              tableName: tableName,
            ),
          ),
        ),
      ),
    );
  }
}
