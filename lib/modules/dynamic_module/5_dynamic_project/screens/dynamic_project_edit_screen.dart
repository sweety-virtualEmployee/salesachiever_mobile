import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/associated_entity_widget.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
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

class DynamicProjectEditScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final String? tabId;
  final bool readonly;
  final String projectName;
  final String entityType;

  const DynamicProjectEditScreen({
    Key? key,
    required this.project,
    required this.readonly,
    this.tabId,
    required this.projectName,
    required this.entityType,
  }) : super(key: key);

  @override
  _DynamicProjectEditScreenState createState() =>
      _DynamicProjectEditScreenState();
}

class _DynamicProjectEditScreenState extends State<DynamicProjectEditScreen> {
  bool _readonly = true;
  dynamic _entity;
  String _notes = '';
  bool? _isNewNote;
  bool _isValid = false;
  var mandatoryFields = LookupService().getMandatoryFields();

  static final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _entity = this.widget.project;
    print("sweety***----${widget.entityType}");
    callApi();
    validate();

    super.initState();
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    print("on change method");
    print("key$key");
    print("value$value");
    setState(() {
      if (key == 'SITE_COUNTRY' && _entity[key] != value) {
        _entity['SITE_COUNTY'] = '';
      }

      _entity[key] = value;
    });

    validate();
  }

  callApi() async {
    String id = "";
    if (widget.entityType == "COMPANY") {
      id = _entity['ACCT_ID'];
    } else if (widget.entityType == "CONTACT") {
      id = _entity['CONT_ID'];
    } else if (widget.entityType == "ACTION") {
      id = _entity['ACTION_ID'];
    } else if (widget.entityType == "OPPORTUNITY") {
      id = _entity['DEAL_ID'];
    } else {
      id = _entity['PROJECT_ID'];
    }
    await getProjectForm(id);
  }

  void validate() {
    if (widget.entityType == "COMPANY") {
      var isValid = CompanyService().validateEntity(_entity);
      setState(() {
        _isValid = isValid;
      });
    } else if (widget.entityType == "CONTACT") {
      var isValid = ContactService().validateEntity(_entity);
      setState(() {
        _isValid = isValid;
      });
    } else if (widget.entityType == "ACTION") {
      var isValid = ActionService().validateEntity(_entity);
      setState(() {
        _isValid = isValid;
      });
    } else if (widget.entityType == "OPPORTUNITY") {
      var isValid = OpportunityService().validateEntity(_entity);
      setState(() {
        _isValid = isValid;
      });
    } else {
      var isValid = ProjectService().validateEntity(_entity);
      setState(() {
        _isValid = isValid;
      });
    }
  }

  var fieldData;
  var filedEntity;

  Future<List> getProjectForm(String id) async {
    print("LEt chech id$id");
    print("LEt chech id${widget.tabId}");

    final dynamic response =
        await DynamicProjectApi().getProjectForm(widget.tabId.toString(), id);
    print("response${response}");
    setState(() {
      fieldData = response;
    });
    log("fieldData${response}");

    return response;
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
            if(field["FIELD_NAME"].contains("_ID")){

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
      key: key,
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }

  onRelatedValueSave(List<dynamic> entity) {
    entity.forEach((prop) {
      setState(() {
        _entity[prop['KEY']] = prop['VALUE'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onTap : null,
      ),
      title:
          "${capitalizeFirstLetter(widget.entityType)} - ${widget.projectName}",
      body: Container(
        child: Column(
          children: [
            Container(
                height: 61,
                child: CommonHeader(
                    entityType: widget.entityType, entity: _entity)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Container(child: _buildDynamicType(_key)),
                    Container(
                        child: fieldData != null
                            ? generateFields(
                                _key,
                                widget.entityType,
                                _entity,
                                fieldData,
                                mandatoryFields,
                                _readonly,
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

  onInfoSave(dynamic project) async {
    setState(() {
      _entity = project;
    });

    await saveProject();
  }

  onInfoBack() {
    validate();
  }

  onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveProject();
  }

  Future<void> saveProject() async {
    try {
      context.loaderOverlay.show();
      print("saving the project");
      print(_entity);
      if (widget.entityType == "COMPANY") {
        if (_entity['ACCT_ID'] != null) {
          await CompanyService().updateEntity(_entity!['ACCT_ID'], _entity);
        } else {
          var newEntity = await CompanyService().addNewEntity(_entity);
          _entity['ACCT_ID'] = newEntity['ACCT_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await CompanyService().addCompanyNote(_entity['ACCT_ID'], _notes);
          } else {
            await CompanyService()
                .updateCompanyNote(_entity['ACCT_ID'], _notes);
          }
        }
      } else if (widget.entityType == "CONTACT") {
        if (_entity['CONT_ID'] != null) {
          await ContactService().updateEntity(_entity!['CONT_ID'], _entity);
        } else {
          var newEntity = await ContactService().addNewEntity(_entity);
          _entity['CONT_ID'] = newEntity['CONT_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await ContactService().addContactNote(_entity['CONT_ID'], _notes);
          } else {
            await ContactService()
                .updateContactNote(_entity['CONT_ID'], _notes)
                .onError((error, stackTrace) => null);
          }
        }
      } else if (widget.entityType == "ACTION") {
        if (_entity['ACTION_ID'] != null) {
          await ActionService().updateEntity(_entity!['ACTION_ID'], _entity);
        } else {
          var newEntity = await ActionService().addNewEntity(_entity);
          _entity['ACTION_ID'] = newEntity['ACTION_ID'];
        }
      } else if (widget.entityType == "OPPORTUNITY") {
        if (_entity['DEAL_ID'] != null) {
          await OpportunityService().updateEntity(_entity!['DEAL_ID'], _entity);
        } else {
          var newEntity = await OpportunityService().addNewEntity(_entity);
          _entity['DEAL_ID'] = newEntity['DEAL_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await OpportunityService().addDealNote(_entity['DEAL_ID'], _notes);
          } else {
            await OpportunityService()
                .updateDealNote(_entity['DEAL_ID'], _notes);
          }
        }
      } else {
        if (_entity['PROJECT_ID'] != null) {
          await ProjectService().updateEntity(_entity!['PROJECT_ID'], _entity);
        } else {
          var newEntity = await ProjectService().addNewEntity(_entity);
          _entity['PROJECT_ID'] = newEntity['PROJECT_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await ProjectService()
                .addProjectNote(_entity['PROJECT_ID'], _notes);
          } else {
            await ProjectService()
                .updateProjectNote(_entity['PROJECT_ID'], _notes);
          }
        }
      }

      setState(() => _readonly = !_readonly);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
