import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/screens/sorting/sort_fields_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectedSortFieldsScreen extends StatelessWidget {
  final String title;
  final String type;
  final String list;
  final List<dynamic>? sortBy;

  const SelectedSortFieldsScreen(
      {Key? key,
      required this.title,
      required this.type,
      required this.list,
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
                    '${LangUtil.getString(type, sortBy?[index]['FieldName'])} (${sortBy?[index]['SortOrder'] == 1 ? LangUtil.getString('Entities', 'List.SortSet.Ascending.Text') : LangUtil.getString('Entities', 'List.SortSet.Descending.Text')})',
                  ),
                ),
                onTap: () => print('lll'),
              ),
              AuthUtil.hasAccess(int.parse(
                      ACCESS_CODES['Saving sort and filters'].toString()))
                  ? IconButton(
                      onPressed: () async {
                        await DynamicProjectService().deleteSortFilter(
                            sortBy?[index]['FieldName'], "SORT", list);
                        Navigator.push(
                            context,
                            platformPageRoute(
                                context: context,
                                builder: (BuildContext context) {
                                  return DynamicProjectListScreen(
                                    listType: type,
                                    listName: list,
                                  );
                                }));
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
            builder: (BuildContext context) => SortFieldsScreen(
              title: title,
              type: type,
              sortBy: sortBy,
              list: list,
            ),
          ),
        ),
      ),
    );
  }
}
