import 'package:flutter/cupertino.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_checkbox_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_datefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_floatfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_numberfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_timefield_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class InfoFieldService {
  static Widget generateFields(
    String entityType,
    String entityTypeId,
    dynamic entity,
    List<dynamic> filedList,
    bool readonly,
    Function onChange,
  ) {
    List<Widget> widgets = [];

    filedList.sort((a, b) => a['ORDER_NUM'].compareTo(b['ORDER_NUM']));

    for (dynamic field in filedList) {
     var isRequired = field['ISREQUIRED'];
      print("field['FIELD_TYPE']${field['FIELD_TYPE']}");
      print("field['FIELD_TYPE']${field['FIELD_NAME']}");
      switch (field['FIELD_TYPE']) {
        case 'L':
          widgets.add(
            PsaDropdownRow(
              isRequired: isRequired,
              type: entityType,
              tableName: field['FIELD_TABLE'],
              fieldName: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'H':
          widgets.add(
            PsaTextFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString(),
              keyboardType: TextInputType.text,
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'C':
          widgets.add(
            PsaTextFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString(),
              keyboardType: TextInputType.text,
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'I':
          widgets.add(
            PsaNumberFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']],
              keyboardType: TextInputType.number,
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'F':
          widgets.add(
            PsaFloatFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'D':
          widgets.add(
            PsaDateFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'B':
          print("entity?[field['FIELD_NAME']]?.toString() ?? ''${entity?[field['FIELD_NAME']]?.toString() ?? ''}");
          bool isChecked = entity?[field['FIELD_NAME']].toString() == 'true';
          print("ischecked$isChecked");
          widgets.add(
            PsaCheckBoxRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: isChecked,
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'T':
          widgets.add(
            PsaTimeFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'M':
          widgets.add(
            PsaTextAreaFieldRow(
              isRequired: isRequired,
              maxLines: null,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['FIELD_TABLE'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly,
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
      }
    }

    return CupertinoFormSection(
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }
}
