import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/shared/screens/filtering/select_filter_condition_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SelectFilterFieldScreen extends StatelessWidget {
  final String title;
  final String type;
  final String list;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;

  const SelectFilterFieldScreen({
    Key? key,
    required this.title,
    required this.type,
    required this.list,
    this.sortBy,
    this.filterBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> lookupFields;
    if(type=="COMPANY"){
      lookupFields = Hive.box<dynamic>('dataDictionary')
          .values
          .where((e) =>
      e['TABLE_NAME'].toString().toLowerCase() == "ACCOUNT".toLowerCase() &&
          e['FIELD_TYPE'] == 'L')
          .map((e) => {
        'TEXT': LangUtil.getListValue("ACCOUNT", e['FIELD_NAME']),
        'FIELD_NAME': e['FIELD_NAME'],
        'TABLE_NAME': e['TABLE_NAME'].toString().toUpperCase()
      })
          .toList();

      lookupFields.sort((a, b) => a['TEXT'].compareTo(b['TEXT']));
    }
    else if(type=="OPPORTUNITY"){
      lookupFields = Hive
          .box<dynamic>('dataDictionary')
          .values
          .where((e) =>
      e['TABLE_NAME'].toString().toLowerCase() == "DEAL".toLowerCase() &&
          e['FIELD_TYPE'] == 'L')
          .map((e) =>
      {
        'TEXT': LangUtil.getListValue("DEAL", e['FIELD_NAME']),
        'FIELD_NAME': e['FIELD_NAME'],
        'TABLE_NAME': e['TABLE_NAME'].toString().toUpperCase()
      })
          .toList();

      lookupFields.sort((a, b) => a['TEXT'].compareTo(b['TEXT']));
    }else {
      lookupFields = Hive
          .box<dynamic>('dataDictionary')
          .values
          .where((e) =>
      e['TABLE_NAME'].toString().toLowerCase() == type.toLowerCase() &&
          e['FIELD_TYPE'] == 'L')
          .map((e) =>
      {
        'TEXT': LangUtil.getListValue(type, e['FIELD_NAME']),
        'FIELD_NAME': e['FIELD_NAME'],
        'TABLE_NAME': e['TABLE_NAME'].toString().toUpperCase()
      })
          .toList();

      lookupFields.sort((a, b) => a['TEXT'].compareTo(b['TEXT']));
    }
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
                  lookupFields[index]['TEXT'],
                ),
              ),
              onTap: () => Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) =>
                      SelectFilterConditionScreen(
                    title: lookupFields[index]['TEXT'],
                    entity: type,
                    sortBy: sortBy,
                    filterBy: filterBy,
                    tableName: lookupFields[index]['TABLE_NAME'],
                    fieldName: lookupFields[index]['FIELD_NAME'],
                    list: list,
                  ),
                ),
              ),
            );
          },
          itemCount: lookupFields.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
