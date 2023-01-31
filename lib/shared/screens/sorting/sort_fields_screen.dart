import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/screens/sorting/select_sort_order_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SortFieldsScreen extends StatelessWidget {
  final String title;
  final String type;
  final String list;
  final List<dynamic>? sortBy;

  const SortFieldsScreen(
      {Key? key,
      required this.title,
      required this.type,
      required this.list,
      this.sortBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> dataList = LangUtil.getLocaleList(type);
    dataList.sort((a, b) => a.displayValue.compareTo(b.displayValue));

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
                  builder: (BuildContext context) => SelectSortOrderScreen(
                    title: title,
                    entity: type,
                    sortBy: sortBy,
                    field: dataList[index].itemId,
                    list: list,
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
