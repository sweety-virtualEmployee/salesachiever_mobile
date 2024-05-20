import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/select_staffzone_filter_field_value_screen.dart';
import 'package:salesachiever_mobile/shared/screens/filtering/select_filter_field_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectedStaffZoneFilterFieldsScreen extends StatefulWidget {
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
        this.sortBy,this.filterBy})
      : super(key: key);

  @override
  _SelectedStaffZoneFilterFieldsScreenState createState() =>
      _SelectedStaffZoneFilterFieldsScreenState();
}

class _SelectedStaffZoneFilterFieldsScreenState
    extends State<SelectedStaffZoneFilterFieldsScreen> {
  dynamic filterBy;

  @override
  void initState() {
    filterBy = widget.filterBy;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: widget.title,
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
                        widget.tableName, widget.filterBy?[index]['FieldName']),
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
        itemCount: widget.filterBy?.length ?? 0,
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
              title: widget.title,
              relatedEntityType: widget.relatedEntityType,
              sortBy: widget.sortBy,
              filterBy: filterBy,
              staffZoneListTitle: widget.staffZoneListTitle,
              id: widget.id,
              staffZoneType: widget.staffZoneType, tableName: widget.tableName,
            ),
          ),
        ),
      ),
    );
  }
}
