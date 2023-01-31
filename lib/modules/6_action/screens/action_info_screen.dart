import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/services/info_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ActionInfoScreen extends StatefulWidget {
  final Map<String, dynamic> action;
  final bool readonly;
  final Function onSave;
  final Function onBack;

  ActionInfoScreen({
    Key? key,
    required this.action,
    required this.readonly,
    required this.onSave,
    required this.onBack,
  }) : super(key: key);

  @override
  _ActionInfoScreenState createState() => _ActionInfoScreenState();
}

class _ActionInfoScreenState extends State<ActionInfoScreen> {
  dynamic _action;
  bool _readonly = true;
  bool _isValid = false;
  String _actionTypeId = '';
  List<dynamic> filedsList = [];

  void _onChange(String key, dynamic value, bool isRequired) {
    _action[key] = value;
    _validate();
  }

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _action = this.widget.action;

    _actionTypeId = _action['ACTION_TYPE_ID'] ?? 'STD';

    _initialize();
    _validate();

    super.initState();
  }

  _initialize() {
    var userFields = ActionService().getuserFields();
    var visibleFields = LookupService().getVisibleUserFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    filedsList = userFields
        .where((uf) => visibleFields.any((vf) =>
            vf['UDF_ID'] == uf['UDF_ID'] && vf['TYPE_ID'] == _actionTypeId))
        .toList();

    filedsList.forEach((field) {
      var isRequired = mandatoryFields.any((e) =>
          e['TABLE_NAME'] == field['FIELD_TABLE'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);

      field['ISREQUIRED'] = isRequired;
    });
  }

  _validate() {
    var isValid = ActionService().validateEntity(_action);

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

                      if (_action['ACTION_ID'] != null) {
                        await ActionService()
                            .updateEntity(_action!['ACTION_ID'], _action);
                      } else {
                        var newEntity =
                            await ActionService().addNewEntity(_action);
                        _action['ACTION_ID'] = newEntity['ACTION_ID'];
                      }

                      await widget.onSave(_action);

                      setState(() => _readonly = !_readonly);

                      Navigator.pop(context);
                    } on DioError catch (e) {
                      ErrorUtil.showErrorMessage(context, e.message);
                    } catch (e) {
                      ErrorUtil.showErrorMessage(
                          context, MessageUtil.getMessage('500'));
                    } finally {
                      context.loaderOverlay.hide();
                    }
                  }),
        title: LangUtil.getString(
          'AccountEditWindow',
          'InformationTab.Header',
        ),
        body: SingleChildScrollView(
          child: Container(
            child: InfoFieldService.generateFields(
              'Action',
              _actionTypeId,
              _action,
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
