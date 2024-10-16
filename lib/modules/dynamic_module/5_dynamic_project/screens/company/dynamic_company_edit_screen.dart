import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamicPsaLooksUp.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_checkbox_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_county_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_datefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_floatfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_multiselect_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_numberfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_related_value_record.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_timefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicCompanyEditScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final String? tabId;
  final bool readonly;
  final String entityName;
  final String entityType;

  const DynamicCompanyEditScreen({
    Key? key,
    required this.entity,
    required this.readonly,
    this.tabId,
    required this.entityName,
    required this.entityType,
  }) : super(key: key);

  @override
  State<DynamicCompanyEditScreen> createState() => _DynamicCompanyEditScreenState();
}

class _DynamicCompanyEditScreenState extends State<DynamicCompanyEditScreen> {
  String _notes = '';
  bool? _isNewNote;
  static final _key = GlobalKey<FormState>();

  var mandatoryFields = LookupService().getMandatoryFields();

  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = Provider.of<DynamicTabProvide>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _dynamicTabProvider.setCompanyEntity(widget.entity);
        _dynamicTabProvider.setReadOnly(widget.readonly);
      }
    });
    callApi();

    super.initState();
  }
  var fieldData;
  var filedEntity;

  callApi() async {
    print("lets check entity ${widget.entityType}");
    await getProjectForm(widget.entity['ACCT_ID']??"Init");
  }

  Future<List> getProjectForm(String id) async {
    print("LEt chech id$id");
    print("LEt chech id${widget.tabId}");

    final dynamic response =
    await DynamicProjectApi().getProjectForm(widget.tabId.toString(), id);
    setState(() {
      fieldData = response;
    });
    print("fieldData${response}");

    return response;
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    setState(() {
      if (key == 'SITE_COUNTRY' && _dynamicTabProvider.getCompanyEntity[key] != value) {
        _dynamicTabProvider.getCompanyEntity['SITE_COUNTY'] = '';
      }

      _dynamicTabProvider.getCompanyEntity[key] = value;
    });
  }

  onRelatedValueSave(List<dynamic> entity) {
    entity.forEach((prop) {
      setState(() {
        _dynamicTabProvider.getCompanyEntity[prop['KEY']] = prop['VALUE'];
      });
    });
  }

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
    if (fieldData != null) {
      for (dynamic field in filedList) {
        print("field of entity${field['FIELD_TYPE']}");
        print("field of entity${field['FIELD_NAME']}");
        var isRequired = mandatoryFields.any((e) =>
        e['TABLE_NAME'] == field['TABLE_NAME'] &&
            e['FIELD_NAME'] == field['FIELD_NAME']);
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
                  readOnly: readonly ||
                      (field['DISABLED'] != null && field['DISABLED']),
                  onChange: (_, __) => onChange(_, __, isRequired),
                  country: entity?['COUNTRY']?.toString() ?? '',
                ),
              );
            } else if (field['TABLE_NAME'] == 'PROJECT' &&
                field['FIELD_NAME'] == 'SITE_COUNTY') {
              print("thia");
              widgets.add(
                PsaCountyDropdownRow(
                  isRequired: isRequired,
                  tableName: field['TABLE_NAME'],
                  fieldName: field['FIELD_NAME'],
                  title: LangUtil.getString(
                      field['TABLE_NAME'], field['FIELD_NAME']),
                  value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                  readOnly: readonly ||
                      (field['DISABLED'] != null && field['DISABLED']),
                  onChange: (_, __) => onChange(_, __, isRequired),
                  country: entity?['SITE_COUNTRY']?.toString() ?? '',
                ),
              );
            } else {
              print("no");
              widgets.add(
                PsaDropdownRow(
                  type: type,
                  isRequired: isRequired,
                  tableName: field['TABLE_NAME'],
                  fieldName: field['FIELD_NAME'],
                  title: LangUtil.getString(
                      field['TABLE_NAME'], field['FIELD_NAME']),
                  value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                  readOnly: readonly ||
                      (field['DISABLED'] != null && field['DISABLED']),
                  onChange: (_, __) => onChange(_, __, isRequired),
                ),
              );
            }
            break;
          case 'C':
            if (field["FIELD_NAME"].contains("_ID")) {
              print("field['Data${field['FIELD_NAME']}");
              widgets.add(PsaRelatedValueRow(
                title:
                LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
                value: field['Data_Value'],
                type: field['FIELD_NAME'],
                entity: _dynamicTabProvider.getCompanyEntity,
                onChange: onRelatedValueSave,
                onTap: () {},
                isVisible: true,
                isRequired: isRequired,
              ));

            }
            else {
              widgets.add(
                PsaTextFieldRow(
                  isRequired: isRequired,
                  fieldKey: field['FIELD_NAME'],
                  title: LangUtil.getString(
                      field['TABLE_NAME'], field['FIELD_NAME']),
                  value: entity?[field['FIELD_NAME']]?.toString(),
                  keyboardType: TextInputType.text,
                  readOnly: readonly ||
                      (field['DISABLED'] != null && field['DISABLED']),
                  onChange: (_, __) => onChange(_, __, isRequired),
                  updatedFieldKey: updatedFieldKey,
                ),
              );
            }
            break;
          case 'I':
            if (field['FIELD_TYPE'] == "I") {
              print("field name checking ${entity?[field['FIELD_NAME']]}");
              print("field name checking ${[field['FIELD_NAME']]}");
            }
            widgets.add(
              PsaNumberFieldRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']],
                keyboardType: TextInputType.number,
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'F':
            widgets.add(
              PsaFloatFieldRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'D':
            widgets.add(
              PsaDateFieldRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'B':
            print(
                "LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME'])${LangUtil
                    .getString(
                    field['TABLE_NAME'], field['FIELD_NAME'])}");
            widgets.add(
              PsaCheckBoxRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']],
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'T':
            widgets.add(
              PsaTimeFieldRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'M':
            widgets.add(
              PsaTextAreaFieldRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'U':
            widgets.add(
              DynamicPsaDropdownRow(
                type: type,
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                tableName: field['LKTable'],
                fieldName: field['LKField'],
                returnField: field['LKReturn'],
                lkApi: field['LKAPI'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'V':
            widgets.add(
              PsaMultiSelectRow(
                type: type,
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                selectedValue: field['Data_Value'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['Data_Value']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
            break;
          case 'Z':
            widgets.add(PsaRelatedValueRow(
              title:
              LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: field['Data_Value'],
              type: field['FIELD_NAME'],
              entity: field,
              onChange: onRelatedValueSave,
              onTap: () {},
              isVisible: true,
            ));
        }
      }
    } else {
      return Center(child: PsaProgressIndicator());
    }
    return CupertinoFormSection(
      backgroundColor: CupertinoColors.white,
      key: key,
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicTabProvide>(
        builder: (context, provider, child) {
          return PsaScaffold(
            action: PsaEditButton(
              text: _dynamicTabProvider.getReadOnly ? 'Edit' : 'Save',
              onTap: onTap ,
            ),
            title: "${capitalizeFirstLetter(widget.entityType)} - ${widget.entityName}",
            body: Container(
              child: Column(
                children: [
                  Container(
                      height: 80,
                      child: CommonHeader(
                          entityType: widget.entityType.toUpperCase(), entity: provider.getCompanyEntity)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              child: fieldData != null
                                  ? generateFields(
                                  _key,
                                  widget.entityType,
                                  provider.getCompanyEntity,
                                  fieldData,
                                  mandatoryFields,
                                  _dynamicTabProvider.getReadOnly,
                                  _onChange)
                                  : Center(child: PsaProgressIndicator()))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  onTap() async {
    if (_dynamicTabProvider.getReadOnly) {
      _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
      return;
    }


    await saveProject();
  }

  Future<void> saveProject() async {
    try {
      context.loaderOverlay.show();
        if (_dynamicTabProvider.getCompanyEntity['ACCT_ID'] != null) {
          await CompanyService().updateEntity(_dynamicTabProvider.getCompanyEntity['ACCT_ID'], _dynamicTabProvider.getCompanyEntity);
        } else {
          var newEntity = await CompanyService().addNewEntity(_dynamicTabProvider.getCompanyEntity);
          _dynamicTabProvider.getCompanyEntity['ACCT_ID'] = newEntity['ACCT_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await CompanyService().addCompanyNote(_dynamicTabProvider.getCompanyEntity['ACCT_ID'], _notes);
          } else {
            await CompanyService()
                .updateCompanyNote(_dynamicTabProvider.getCompanyEntity['ACCT_ID'], _notes);
          }
        }
      _dynamicTabProvider.setCompanyEntity( _dynamicTabProvider.getCompanyEntity);
      _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
    } on DioException catch (e) {
      _dynamicTabProvider.setCompanyEntity(_dynamicTabProvider.getCompanyEntity);
      List<String> values = [];
      if (e.error is List) {
        List<dynamic> errorList = e.error as List<dynamic>;
        if (errorList.isNotEmpty && errorList[0] is Map) {
          Map<String, dynamic> errorData = errorList[0] as Map<String, dynamic>;
          var dataList = errorData["Data"] as List? ?? [];
          for (int i = 0; i < dataList.length; i++) {
            String fieldString = LangUtil.getString(widget.entityType, dataList[i]);
            values.add(fieldString);
          }
          print("values: $values");
          ErrorUtil.showErrorMessage(context, "${errorData["Message"]}\n${values}");
        }
      }
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
