import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamicPsaLooksUp.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_checkbox_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_county_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_datefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_floatfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_numberfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_timefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
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
  dynamic _project;
  String _notes = '';
  bool? _isNewNote;
  bool _isValid = false;
  var mandatoryFields = LookupService().getMandatoryFields();

  static final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _project = this.widget.project;
    print("sweety***----$_project");
    callApi();

  /*  if (_project['PROJECT_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('Project');

      defaultValues.forEach((element) {
        _project[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_project['PROJECT_ID'] == null) _project['PROJECT_TYPE_ID'] = 'STD';
    }
*/
    validate();

    super.initState();
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    print("on change method");
    print("key$key");
    print("value$value");
    setState(() {
      if (key == 'SITE_COUNTRY' && _project[key] != value) {
        _project['SITE_COUNTY'] = '';
      }

      _project[key] = value;
    });

    validate();
  }

  callApi() async {
    String id="";
    if(widget.entityType == "COMPANY"){
     id= _project['ACCT_ID'];
    }
    else{
      id= _project['PROJECT_ID'];
    }
    await getProjectForm(id);
  }

  void validate() {
    var isValid = ProjectService().validateEntity(_project);

    setState(() {
      _isValid = isValid;
    });
  }

  var fieldData;
  var filedEntity;

  Future<List> getProjectForm(String id) async {
    print("LEt chech id$id");

    final dynamic response = await DynamicProjectApi().getProjectForm(widget.tabId.toString(), id);
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
                returnField:field['LKReturn'],
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
    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onTap : null,
      ),
      title: "${capitalizeFirstLetter(widget.entityType)} - ${widget.projectName}",
      body: Container(
        child: Column(
          children: [
            widget.entityType=="COMPANY"?DynamicPsaHeader(
              isVisible: true,
              icon: 'assets/images/company_icon.png',
              title: _project?['ACCTNAME'],
              projectID: _project?['ACCT_ID'],
              status: _project?['ACCT_TYPE_ID'],
              siteTown: _project?['ADDR1'],
              backgroundColor: Color(0xff3cab4f),
            ):DynamicPsaHeader(
              isVisible: true,
              icon: 'assets/images/projects_icon.png',
              title: _project?['PROJECT_TITLE'] ??
                  LangUtil.getString('Entities', 'Project.Create.Text'),
              projectID: _project?['PROJECT_ID'],
              status: _project?['SELLINGSTATUS_ID'],
              siteTown: _project?['OWNER_ID'],
              backgroundColor: Color(0xffE67E6B),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Container(child: _buildDynamicType(_key)),
                    Container(
                        child: fieldData != null
                            ? generateFields(
                                _key,
                                "project",
                                _project,
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
      _project = project;
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
      print(_project['PROJECT_ID']);
      print(_project);

      if (_project['PROJECT_ID'] != null) {
        await ProjectService().updateEntity(_project!['PROJECT_ID'], _project);
      } else {
        var newEntity = await ProjectService().addNewEntity(_project);
        _project['PROJECT_ID'] = newEntity['PROJECT_ID'];
      }

      if (_isNewNote != null) {
        if (_isNewNote!) {
          await ProjectService().addProjectNote(_project['PROJECT_ID'], _notes);
        } else {
          await ProjectService()
              .updateProjectNote(_project['PROJECT_ID'], _notes);
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
