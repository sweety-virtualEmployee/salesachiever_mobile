import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_checkbox_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_county_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_datefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_floatfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_numberfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_timefield_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DataFieldService {
  Widget generateFields(
      Key key,
      String type,
      dynamic entity,
      List<dynamic> filedList,
      List<dynamic> mandatoryFields,
      bool readonly,
      Function onChange,
      [String? updatedFieldKey]) {
    List<Widget> widgets = [];
    print(mandatoryFields.where((element) =>element['TABLE_NAME'] == "ACCIDENT_RECORD"));
    for (dynamic field in filedList) {
      print("madndatoryfields$mandatoryFields");
      print("madndatoryfields$filedList");
      var isRequired = mandatoryFields.any((e) =>
          e['TABLE_NAME'] == field['TABLE_NAME'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);
      print("isRqurierdds${isRequired} field name${field['FIELD_NAME']}${field["TABLE_NAME"]}");
      if(field['FIELD_TYPE']=="I"){
        print("check the condition");
        print(field["FIELD_NAME"]);
        print(entity?[field['FIELD_NAME']]);
      }
      switch (field['FIELD_TYPE']) {
        case 'L':
          if (field['TABLE_NAME'] == 'ACCOUNT' &&
              field['FIELD_NAME'] == 'COUNTY') {
            widgets.add(
              PsaCountyDropdownRow(
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
                country: entity?['COUNTRY']?.toString() ?? '',
              ),
            );
          } else if (field['TABLE_NAME'] == 'PROJECT' &&
              field['FIELD_NAME'] == 'SITE_COUNTY') {
            widgets.add(
              PsaCountyDropdownRow(
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
                country: entity?['SITE_COUNTRY']?.toString() ?? '',
              ),
            );
          } else {
            widgets.add(
              PsaDropdownRow(
                type: type,
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
          }
          break;
        case 'C':
          widgets.add(
            PsaTextFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString(),
              keyboardType: TextInputType.text,
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
              updatedFieldKey: updatedFieldKey,
            ),
          );
          break;
        case 'I':
          widgets.add(
            PsaNumberFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']] ?? 0,
              keyboardType: TextInputType.number,
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'F':
          print("entity?[field['FIELD_NAME']]${entity?[field['FIELD_NAME']]}");
          print("field['FIELD_NAME']${field['FIELD_NAME']}");
          if(entity?[field['FIELD_NAME']]==null){
            print("yes it is null for ${entity?[field['FIELD_NAME']]}");
          }
          widgets.add(
            PsaFloatFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']] != null
                  ? double.tryParse((entity?[field['FIELD_NAME']]).toString()) ?? 0.0
                  : 0.0,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
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
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'B':
          bool isChecked = entity?[field['FIELD_NAME']] == 'Y'; // Adjust 'Y' as needed
          widgets.add(
            PsaCheckBoxRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: isChecked,
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
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
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'M':
          widgets.add(
            PsaTextAreaFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly: readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
      }
    }
    return CupertinoFormSection(
      key: key,
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }
}
