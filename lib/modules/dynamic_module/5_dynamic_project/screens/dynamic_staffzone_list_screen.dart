import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/selected_staffzone_sort_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/staffzone_sort_fields_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicStaffZoneListScreen extends StatefulWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String staffZoneType;
  final String id;
  final String relatedEntityType;

  const DynamicStaffZoneListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.staffZoneType,
    required this.id,
    required this.relatedEntityType,
  }) : super(key: key);

  @override
  _DynamicStaffZoneListScreenState createState() =>
      _DynamicStaffZoneListScreenState();
}

class _DynamicStaffZoneListScreenState
    extends State<DynamicStaffZoneListScreen> {
  List<dynamic> staffZone = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await DynamicProjectService().getStaffZoneEntity(
          widget.relatedEntityType,
          widget.staffZoneType,
          widget.id,
          widget.sortBy);
      setState(() {
        staffZone = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: "${capitalizeFirstLetter(widget.staffZoneType)} - List",
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : staffZone.isEmpty
              ? Center(child: Text("No data available"))
              : Column(
                  children: [
                    ListAction(
                      title:
                          LangUtil.getString('List', 'ListFilter.SortBy.Label'),
                      selectedCount: widget.sortBy?.length ?? 0,
                      onTap: () => Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) =>
                              SelectedStaffZoneSortFieldsScreen(
                            title: LangUtil.getString(
                                'List', 'ListFilter.SortBy.Label'),
                            type: widget.staffZoneType,
                            sortBy: widget.sortBy,
                            id: widget.id,
                            list: widget.relatedEntityType,
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: staffZone.length,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        var item = staffZone[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            PlatformText(
                              '${item['DESCRIPTION'] ?? ''}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            PlatformText(
                              "Submitted By: ${item['SUBMITTED_BY'] ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            PlatformText(
                              "Submitted On: ${item['SUBMITTED_ON'] ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            PlatformText(
                              "CIP_1: ${item['CIP_1'] ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}
