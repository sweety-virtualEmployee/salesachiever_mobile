import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_county_list_picker.dart';
import 'package:salesachiever_mobile/utils/hive_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class PsaCountyDropdownRow extends StatelessWidget {
  final String tableName;
  final String fieldName;
  final String title;
  final String value;
  final bool readOnly;
  final Function? onChange;
  final bool? isRequired;
  final String? country;

  const PsaCountyDropdownRow({
    Key? key,
    required this.tableName,
    required this.fieldName,
    required this.title,
    required this.value,
    this.readOnly = true,
    this.onChange,
    this.isRequired = false,
    this.country,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contextId = HiveUtil.getContextId('account', tableName, fieldName);
    _onTap() async {
      if (!readOnly) {
        var result = await Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => PsaCountyListPicker(
              title: title,
              contextId: contextId,
              country: country,
            ),
          ),
        );

        if (this.onChange != null) this.onChange!(fieldName, result);
      }
    }

    return Container(
      color: Colors.white,
      child: CupertinoFormRow(
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color:
                        isRequired! && value == '' ? Colors.red : Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CupertinoTextField(
                  onTap: _onTap,
                  controller: TextEditingController()
                    ..text = LangUtil.getListValue(contextId, value),
                  readOnly: true,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  suffix: Icon(context.platformIcons.rightChevron,color: Colors.grey,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
