import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/5_project/widgets/project_create_related_records.dart';
import 'package:salesachiever_mobile/modules/5_project/widgets/project_info_section.dart';
import 'package:salesachiever_mobile/modules/5_project/widgets/project_view_related_records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ProjectEditScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool readonly;

  const ProjectEditScreen({
    Key? key,
    required this.project,
    required this.readonly,
  }) : super(key: key);

  @override
  _ProjectEditScreenState createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  bool _readonly = true;
  dynamic _project;
  String _notes = '';
  bool? _isNewNote;
  bool _isValid = false;

  var activeFields = ProjectService().getActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _project = this.widget.project;

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

  @override
  Widget build(BuildContext context) {
    print("active field lenth");
    print(activeFields.length);
    var visibleFileds = activeFields.where((e) => e['COLVAL']).toList();
     return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onTap : null,
      ),
      title: LangUtil.getString('Entities', 'Project.Description.Plural'),
      body: Container(
        child: Column(
          children: [
            PsaHeader(
              isVisible: true,
                icon: 'assets/images/projects_icon.png',
                title: _project?['PROJECT_TITLE'] ??
                    LangUtil.getString('Entities', 'Project.Create.Text')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: DataFieldService().generateFields(
                          key,
                          'project',
                          _project,
                          visibleFileds,
                          mandatoryFields,
                          _readonly,
                          _onChange),
                    ),
                    ProjectInfoSection(
                      project: _project,
                      readonly: _readonly,
                      onChange: _onChange,
                      onNoteChange: _onNoteChange,
                      onSave: onInfoSave,
                      onBack: onInfoBack,
                    ),
                    ProjectViewRelatedRecords(
                      entity: _project,
                      projectId: _project['PROJECT_ID'] ?? '',
                    ),
                    ProjectCreateRelatedRecords(project: _project),
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
