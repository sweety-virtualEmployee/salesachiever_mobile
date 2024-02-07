import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_tab_screen.dart';
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

class DynamicEditScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final String? tabId;
  final bool readonly;
  final String entityName;
  final String entityType;

  const DynamicEditScreen({
    Key? key,
    required this.entity,
    required this.readonly,
    this.tabId,
    required this.entityName,
    required this.entityType,
  }) : super(key: key);

  @override
  State<DynamicEditScreen> createState() => _DynamicEditScreenState();
}

class _DynamicEditScreenState extends State<DynamicEditScreen> {
  String _notes = '';
  bool? _isNewNote;
  static final _key = GlobalKey<FormState>();

  var mandatoryFields = LookupService().getMandatoryFields();

  late DynamicTabProvide _dynamicTabProvider;

  @override
  void initState() {
    super.initState();
    _dynamicTabProvider = DynamicTabProvide();
    _dynamicTabProvider.setEntity(widget.entity);
   _dynamicTabProvider.setReadOnly(widget.readonly);
    callApi();

    super.initState();
  }
  var fieldData;
  var filedEntity;

  callApi() async {
    String id = "";
    print("lets check entity ${widget.entityType}");
    if(widget.entity.isNotEmpty) {
      if (widget.entityType == "COMPANY") {
        id = widget.entity['ACCT_ID'];
      } else if (widget.entityType == "CONTACT"||widget.entityType == "CONTACTS") {
        id = widget.entity['CONT_ID']??"Init";
      } else if (widget.entityType == "ACTION"||widget.entityType == "ACTIONS") {
        id = widget.entity['ACTION_ID']??"Init";
      } else if (widget.entityType == "OPPORTUNITY") {
        id = widget.entity['DEAL_ID'];
      } else if (widget.entityType == "QUOTATION") {
        id = widget.entity['QUOTE_ID'];
      } else if (widget.entityType == "PROJECTS"){
        id = widget.entity['PROJECT_ID']??"Init";
      }
      else{
        id ="Init";
      }
    }else{
      id = "Init";
    }
    await getProjectForm(id);
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
      if (key == 'SITE_COUNTRY' && _dynamicTabProvider.getEntity[key] != value) {
        _dynamicTabProvider.getEntity['SITE_COUNTY'] = '';
      }

      _dynamicTabProvider.getEntity[key] = value;
    });
  }

  onRelatedValueSave(List<dynamic> entity) {
    entity.forEach((prop) {
      setState(() {
        _dynamicTabProvider.getEntity[prop['KEY']] = prop['VALUE'];
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
        print("field of entity${_dynamicTabProvider.getEntity}");
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
                entity: _dynamicTabProvider.getEntity,
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
      key: key,
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }


  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider<DynamicTabProvide>(
        create: (context) => _dynamicTabProvider,
        child: Consumer<DynamicTabProvide>(
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
                        height: 70,
                        child: CommonHeader(
                            entityType: widget.entityType.toUpperCase(), entity: provider.getEntity)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                child: fieldData != null
                                    ? generateFields(
                                    _key,
                                    widget.entityType,
                                    provider.getEntity,
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
        ),
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
      if (widget.entityType.toUpperCase() == "COMPANY") {
        if (_dynamicTabProvider.getEntity['ACCT_ID'] != null) {
          await CompanyService().updateEntity(_dynamicTabProvider.getEntity!['ACCT_ID'], _dynamicTabProvider.getEntity);
        } else {
          var newEntity = await CompanyService().addNewEntity(_dynamicTabProvider.getEntity);
          _dynamicTabProvider.getEntity['ACCT_ID'] = newEntity['ACCT_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await CompanyService().addCompanyNote(_dynamicTabProvider.getEntity['ACCT_ID'], _notes);
          } else {
            await CompanyService()
                .updateCompanyNote(_dynamicTabProvider.getEntity['ACCT_ID'], _notes);
          }
        }
        _dynamicTabProvider.setEntity( _dynamicTabProvider.getEntity);
        _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicTabScreen(
                entity: _dynamicTabProvider.getEntity,
                title: "Add New Company",
                readonly: true,
                moduleId: "003",
                entityType: widget.entityType,
              );
            },
          ),
        );
      } else if (widget.entityType.toUpperCase() == "CONTACT"||widget.entityType.toUpperCase() == "CONTACTS") {
        if (_dynamicTabProvider.getEntity['CONT_ID'] != null) {
          await ContactService().updateEntity(_dynamicTabProvider.getEntity['CONT_ID'], _dynamicTabProvider.getEntity);
        } else {
          var newEntity = await ContactService().addNewEntity(_dynamicTabProvider.getEntity);
          _dynamicTabProvider.getEntity['CONT_ID'] = newEntity['CONT_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await ContactService().addContactNote(_dynamicTabProvider.getEntity['CONT_ID'], _notes);
          } else {
            await ContactService()
                .updateContactNote(_dynamicTabProvider.getEntity['CONT_ID'], _notes)
                .onError((error, stackTrace) => null);
          }
        }
        _dynamicTabProvider.setEntity( _dynamicTabProvider.getEntity);
        _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicTabScreen(
                entity: _dynamicTabProvider.getEntity,
                title: "Add New Contact",
                readonly: true,
                moduleId: "004",
                entityType: widget.entityType,
              );
            },
          ),
        );
      } else if (widget.entityType.toUpperCase() == "ACTION"||widget.entityType.toUpperCase() == "ACTIONS") {
        if (_dynamicTabProvider.getEntity['ACTION_ID'] != null) {
          await ActionService().updateEntity(_dynamicTabProvider.getEntity!['ACTION_ID'], _dynamicTabProvider.getEntity);
        } else {
          var newEntity = await ActionService().addNewEntity(_dynamicTabProvider.getEntity);
          _dynamicTabProvider.getEntity['ACTION_ID'] = newEntity['ACTION_ID'];
        }
        _dynamicTabProvider.setEntity( _dynamicTabProvider.getEntity);
        _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicTabScreen(
                entity: _dynamicTabProvider.getEntity,
                title: "Add New Action",
                readonly: true,
                moduleId: "009",
                entityType: widget.entityType,
              );
            },
          ),
        );
      } else if (widget.entityType.toUpperCase() == "OPPORTUNITY") {
        if (_dynamicTabProvider.getEntity['DEAL_ID'] != null) {
          await OpportunityService().updateEntity(_dynamicTabProvider.getEntity!['DEAL_ID'], _dynamicTabProvider.getEntity);
        } else {
          var newEntity = await OpportunityService().addNewEntity(_dynamicTabProvider.getEntity);
          _dynamicTabProvider.getEntity['DEAL_ID'] = newEntity['DEAL_ID'];
        }

        if (_isNewNote != null) {
          if (_isNewNote!) {
            await OpportunityService().addDealNote(_dynamicTabProvider.getEntity['DEAL_ID'], _notes);
          } else {
            await OpportunityService()
                .updateDealNote(_dynamicTabProvider.getEntity['DEAL_ID'], _notes);
          }
        }
        _dynamicTabProvider.setEntity( _dynamicTabProvider.getEntity);
        _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicTabScreen(
                entity: _dynamicTabProvider.getEntity,
                title: "Add New Opportunity",
                readonly: true,
                moduleId: "006",
                entityType: widget.entityType,
              );
            },
          ),
        );
      } else {
        if (_dynamicTabProvider.getEntity['PROJECT_ID'] != null) {
          await ProjectService().updateEntity(_dynamicTabProvider.getEntity['PROJECT_ID'], _dynamicTabProvider.getEntity);
        } else {
          var newEntity = await ProjectService().addNewEntity(_dynamicTabProvider.getEntity);
          _dynamicTabProvider.getEntity['PROJECT_ID'] = newEntity['PROJECT_ID'];
        }
        if (_isNewNote != null) {
          if (_isNewNote!) {
            await ProjectService()
                .addProjectNote(_dynamicTabProvider.getEntity['PROJECT_ID'], _notes);
          } else {
            await ProjectService()
                .updateProjectNote(_dynamicTabProvider.getEntity['PROJECT_ID'], _notes);
          }
        }
        _dynamicTabProvider.setEntity( _dynamicTabProvider.getEntity);
        _dynamicTabProvider.setReadOnly(!_dynamicTabProvider.getReadOnly);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicTabScreen(
                entity: _dynamicTabProvider.getEntity,
                title: "Add New Company",
                readonly: true,
                moduleId: "005",
                entityType: widget.entityType,
              );
            },
          ),
        );
      }

    } on DioError catch (e) {
      _dynamicTabProvider.setEntity(_dynamicTabProvider.getEntity);
      ErrorUtil.showErrorMessage(context, "${e.error[0]["Message"]}\n${e.error[0]["Data"]}");
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
