import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';

class PsaListPicker extends StatelessWidget {
  final String title;
  final String contextId;

  const PsaListPicker({
    Key? key,
    required this.title,
    required this.contextId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> listValues = LangUtil.getLocaleList(contextId);
    listValues.sort((a, b) => a.displayValue.compareTo(b.displayValue));

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
                  listValues[index].displayValue,
                ),
              ),
              onTap: () => Navigator.pop(context, {
                'ID': listValues[index].itemId,
                'TEXT': listValues[index].displayValue
              }),
            );
          },
          itemCount: listValues.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
