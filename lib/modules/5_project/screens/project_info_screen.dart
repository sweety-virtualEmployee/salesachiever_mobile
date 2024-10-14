import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/shared/services/info_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ProjectInfoScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool readonly;
  final Function onSave;
  final Function onBack;

  ProjectInfoScreen({
    Key? key,
    required this.project,
    required this.readonly,
    required this.onSave,
    required this.onBack,
  }) : super(key: key);

  @override
  _ProjectInfoScreenState createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  dynamic _project;
  bool _readonly = true;
  bool _isValid = false;
  String _projectTypeId = '';
  List<dynamic> filedsList = [];

  void _onChange(String key, dynamic value, bool isRequired) {
    _project[key] = value;
    _validate();
  }

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _project = this.widget.project;
    _projectTypeId = _project['PROJECT_TYPE_ID'] ?? 'STD';

    _initialize();
    _validate();

    super.initState();
  }

  _initialize() {
    var userFields = ProjectService().getuserFields();
    var visibleFields = LookupService().getVisibleUserFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    filedsList = userFields
        .where((uf) => visibleFields.any((vf) =>
            vf['UDF_ID'] == uf['UDF_ID'] && vf['TYPE_ID'] == _projectTypeId))
        .toList();

    filedsList.forEach((field) {
      var isRequired = mandatoryFields.any((e) =>
          e['TABLE_NAME'] == field['FIELD_TABLE'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);

      field['ISREQUIRED'] = isRequired;
    });
  }

  _validate() {
    var isValid = ProjectService().validateEntity(_project);

    setState(() {
      _isValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onBack();
        return true;
      },
      child: PsaScaffold(
        action: PsaEditButton(
            text: _readonly ? 'Edit' : 'Save',
            onTap: (!_isValid && !_readonly)
                ? null
                : () async {
                    if (_readonly) {
                      setState(() => _readonly = !_readonly);
                      return;
                    }

                    try {
                      context.loaderOverlay.show();

                      if (_project['PROJECT_ID'] != null) {
                        await ProjectService()
                            .updateEntity(_project!['PROJECT_ID'], _project);
                      } else {
                        var newEntity =
                            await ProjectService().addNewEntity(_project);
                        _project['PROJECT_ID'] = newEntity['PROJECT_ID'];
                      }

                      await widget.onSave(_project);

                      setState(() => _readonly = !_readonly);

                      Navigator.pop(context);
                    } on DioException catch (e) {
                      ErrorUtil.showErrorMessage(context, e.message!);
                    } catch (e) {
                      ErrorUtil.showErrorMessage(
                          context, MessageUtil.getMessage('500'));
                    } finally {
                      context.loaderOverlay.hide();
                    }
                  }),
        title: LangUtil.getString(
          'ProjectEditWindow',
          'InformationTab.Header',
        ),
        body: SingleChildScrollView(
          child: Container(
            child: InfoFieldService.generateFields(
              'Project',
              _projectTypeId,
              _project,
              filedsList,
              _readonly,
              _onChange,
            ),
          ),
        ),
      ),
    );
  }
}
