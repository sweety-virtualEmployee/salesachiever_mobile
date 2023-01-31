import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/api/dynamic_project_api.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
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

class DynamicProjectEditScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final String? tabId;
  final bool readonly;
  final String projectName;

  const DynamicProjectEditScreen({
    Key? key,
    required this.project,
    required this.readonly,
    this.tabId, required this.projectName,
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
    // projectresult;
    callApi();

    if (_project['PROJECT_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('Project');

      defaultValues.forEach((element) {
        _project[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_project['PROJECT_ID'] == null) _project['PROJECT_TYPE_ID'] = 'STD';
    }

    validate();

    super.initState();
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    setState(() {
      if (key == 'SITE_COUNTRY' && _project[key] != value) {
        _project['SITE_COUNTY'] = '';
      }

      _project[key] = value;
    });

    validate();
  }

  callApi() async {
    print("hy");
    await getProjectForm();
  }

  void _onNoteChange(String key, String value, int? state) {
    setState(() {
      _notes = value;
      _isNewNote = state == null || state == 0;
    });
  }

  void validate() {
    var isValid = ProjectService().validateEntity(_project);

    setState(() {
      _isValid = isValid;
    });
  }

  var fieldData;
  var filedEntity;

  Future<List> getProjectForm() async {
    final dynamic response = await DynamicProjectApi()
        .getProjectForm(widget.tabId.toString(), _project['PROJECT_ID']);
    print("response${response}");
    setState(() {
      fieldData = response;
    });
    log("fieldData${response}");

    return response;
  }

  // Future<List> getProjectEntity() async {
  //   final dynamic response = await DynamicProjectApi().getActiveFeaturesEntity();
  //   print("response${response}");
  //   setState(() {
  //     filedEntity = response;
  //   });
  //   log("fieldEntity${response}");
  //
  //   return response;
  // }
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

  Widget _buildDynamicType(Key key) {
    List<Widget> widgets = [];
    // print("icon------"+fieldData[i]['FIELD_TYPE'].toString());
    // print("activeField"+activeFields.toString());
    if (fieldData != null) {
      for (int i = 0; i < fieldData.length; i++) {
        // bool isRequired = fieldData[i]['Mandatory']=="N"?false:true;
        var isRequired = mandatoryFields.any((e) =>
            e['TABLE_NAME'] == fieldData[i]['TABLE_NAME'] &&
            e['FIELD_DESC'] == fieldData[i]['FIELD_DESC']);
        switch (fieldData[i]['FIELD_TYPE']) {
          case 'L':
            widgets.add(
              PsaDropdownRow(
                isRequired: isRequired,
                type: "",
                tableName: fieldData[i]['FIELD_TABLE'] == null
                    ? ""
                    : fieldData[i]['FIELD_TABLE'],
                fieldName: fieldData[i]['FIELD_DESC'] == null
                    ? ""
                    : fieldData[i]['FIELD_DESC'],
                title: LangUtil.getStringNew(fieldData, i),
                // LangUtil.getStringNew(fieldData[i]['FIELD_TABLE']==null? "":fieldData[i]['FIELD_TABLE'],fieldData[i]['FIELD_NAME']==null?"":fieldData[i]['FIELD_NAME'],),
                value: fieldData != ""
                    ? fieldData[i]['Data_Value']?.toString() ?? ''
                    : "",
                //activeFields[fieldData[i]['FIELD_NAME']==null?"":fieldData[i]['FIELD_NAME']]?.toString() ?? '',
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'H':
            widgets.add(
              PsaTextFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                // LangUtil.getString(fieldData[i]['FIELD_TABLE'],fieldData[i]['FIELD_NAME']),
                value: fieldData != ""
                    ? fieldData[i]['Data_Value']?.toString() ?? ''
                    : "",
                keyboardType: TextInputType.text,
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'C':
            widgets.add(
              PsaTextFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                value: fieldData != ""
                    ? fieldData[i]['Data_Value']?.toString() ?? ''
                    : "",
                keyboardType: TextInputType.text,
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'I':
            widgets.add(
              PsaNumberFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                value: fieldData != "" ? 0 : 0,
                keyboardType: TextInputType.number,
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'F':
            widgets.add(
              PsaFloatFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                value: fieldData[i]['Data_Value'] != ""
                    ? double.parse(fieldData[i]['Data_Value'])
                    : 0.0,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'D':
            widgets.add(
              PsaDateFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                value: fieldData != ""
                    ? fieldData[i]['Data_Value']?.toString() ?? ''
                    : "",
                //activeFields[fieldData['FIELD_NAME']]?.toString() ?? '',
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'B':
            widgets.add(
              PsaCheckBoxRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                // LangUtil.getStringNew(fieldData[i]['FIELD_TABLE']!=null?fieldData[i]['FIELD_TABLE']:"Field Table", fieldData[i]['FIELD_NAME']!=null?fieldData[i]['FIELD_NAME']:""),
                value: fieldData[i]['Data_Value'] != ""
                    ? fieldData[i]['Data_Value']
                    : true,
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'T':
            widgets.add(
              PsaTimeFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                //LangUtil.getStringNew(fieldData[i]['FIELD_TABLE']!=null?fieldData[i]['FIELD_TABLE']:"Field Table", fieldData[i]['FIELD_NAME']!=null?fieldData[i]['FIELD_NAME']:""),
                value: fieldData != ""
                    ? DateFormat("dd-MM-yyyy")
                            .parse(fieldData[i]['Data_Value'])
                            ?.toString() ??
                        ''
                    : "",
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
          case 'M':
            widgets.add(
              PsaTextAreaFieldRow(
                isRequired: isRequired,
                fieldKey: fieldData[i]['FIELD_DESC'] != null
                    ? fieldData[i]['FIELD_DESC']
                    : "",
                title: LangUtil.getStringNew(fieldData, i),
                //  LangUtil.getStringNew(fieldData[i]['FIELD_TABLE']!=null?fieldData[i]['FIELD_TABLE']:"Field Table", fieldData[i]['FIELD_NAME']!=null?fieldData[i]['FIELD_NAME']:""),
                value: fieldData != ""
                    ? fieldData[i]['Data_Value']?.toString() ?? ''
                    : "",
                readOnly: _readonly,
                onChange: (_, __) => _onChange(_, __, isRequired),
              ),
            );
            break;
        }
        //print("icon--"+icon);
      }
    } else {
      return Center(child: PsaProgressIndicator());
    }

    return CupertinoFormSection(
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }

  @override
  Widget build(BuildContext context) {
    // var visibleFileds = activeFields.where((e) => e['COLVAL']).toList();

    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onTap : null,
      ),
      title: LangUtil.getString('Entities', 'Project.Description.Plural')+"- ${widget.projectName}",
      body: Container(
        child: Column(
          children: [
            DynamicPsaHeader(
              isVisible: true,
              icon: 'assets/images/projects_icon.png',
              title: _project?['PROJECT_TITLE'] ??
                  LangUtil.getString('Entities', 'Project.Create.Text'),
              projectID: _project?['PROJECT_ID'],
              status: _project?['SELLINGSTATUS_ID'],
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
                    // Container(
                    //   child: DataFieldService().generateFields(
                    //       key,
                    //       'project',
                    //       _project,
                    //       visibleFileds,
                    //       mandatoryFields,
                    //       _readonly,
                    //       _onChange),
                    // ),
                    // ProjectInfoSection(
                    //   project: _project,
                    //   readonly: _readonly,
                    //   onChange: _onChange,
                    //   onNoteChange: _onNoteChange,
                    //   onSave: onInfoSave,
                    //   onBack: onInfoBack,
                    // ),
                    // ProjectViewRelatedRecords(
                    //   entity: _project,
                    //   projectId: _project['PROJECT_ID'] ?? '',
                    // ),
                    // ProjectCreateRelatedRecords(project: _project),
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
