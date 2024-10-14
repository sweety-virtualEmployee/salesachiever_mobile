import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class PsaCountyListPicker extends StatelessWidget {
  final String title;
  final String contextId;
  final String? country;

  const PsaCountyListPicker({
    Key? key,
    required this.title,
    required this.contextId,
    this.country,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> result = Hive.box<dynamic>('county')
        .values
        .where((e) => e['COUNTRY_ID'] == country)
        .toList();

    result.sort((a, b) => a['COUNTY_NAME'].compareTo(b['COUNTY_NAME']));

    return PsaScaffold(
      title: title,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          itemBuilder: (BuildContext _context, int index) {
            return InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: PlatformText(
                  result[index]['COUNTY_NAME'],
                ),
              ),
              onTap: () => Navigator.pop(context, result[index]['COUNTY_NAME']),
            );
          },
          itemCount: result.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
