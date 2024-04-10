import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/selected_staffzone_sort_order_Screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class StaffZoneSortFieldsScreen extends StatelessWidget {
  final String title;
  final String relatedEntityType;
  final String tableName;
  final String staffZoneType;
  final String id;
  final String staffZoneListTitle;
  final List<dynamic>? sortBy;

  const StaffZoneSortFieldsScreen(
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
    print("type value$tableName");
    List<Locale> dataList;
      dataList = LangUtil.getLocaleList(tableName);
      dataList.sort((a, b) => a.displayValue.compareTo(b.displayValue));
      print("data list ${dataList.toString()}");
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
                  dataList[index].displayValue,
                ),
              ),
              onTap: () => Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => SelectStaffZoneSortOrderScreen(
                    title: title,
                    staffZoneType: staffZoneType,
                    tableName: tableName,
                    sortBy: sortBy,
                    field: dataList[index].itemId,
                    relatedEntityType: relatedEntityType,
                    staffZoneListTitle:staffZoneListTitle,
                    id: id,
                  ),
                ),
              ),
            );
          },
          itemCount: dataList.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
