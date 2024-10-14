import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/screens/filtering/select_filter_field_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectedFilterFieldsScreen extends StatefulWidget {
  final String title;
  final String type;
  final String list;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  const SelectedFilterFieldsScreen({
    Key? key,
    required this.title,
    required this.type,
    required this.list,
    this.sortBy,
    this.filterBy,
  }) : super(key: key);

  @override
  _SelectedFilterFieldsScreenState createState() =>
      _SelectedFilterFieldsScreenState();
}

class _SelectedFilterFieldsScreenState
    extends State<SelectedFilterFieldsScreen> {
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
                        widget.type, widget.filterBy?[index]['FieldName']),
                  ),
                ),
                onTap: () => print('lll'),
              ),
              AuthUtil.hasAccess(int.parse(
                  ACCESS_CODES['Saving sort and filters']
                      .toString()))? IconButton(
                onPressed: () async {
                  await DynamicProjectService().deleteSortFilter(
                      widget.filterBy?[index]['FieldName'],
                      "FILTER",
                      widget.list);
                  Navigator.push(
                      context,
                      platformPageRoute(
                          context: context,
                          builder: (BuildContext context) {
                            return DynamicProjectListScreen(
                              listType: widget.type,
                              listName: widget.list,
                            );
                          }));
                },
                icon: Icon(
                  context.platformIcons.clear,
                  color: Colors.red,
                ),
              ):SizedBox()
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
            builder: (BuildContext context) => SelectFilterFieldScreen(
              title: widget.title,
              type: widget.type,
              sortBy: widget.sortBy,
              filterBy: filterBy,
              list: widget.list,
            ),
          ),
        ),
      ),
    );
  }
}
