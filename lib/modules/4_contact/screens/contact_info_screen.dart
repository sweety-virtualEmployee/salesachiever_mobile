import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/shared/services/info_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ContactInfoScreen extends StatefulWidget {
  final Map<String, dynamic> contact;
  final bool readonly;
  final Function onSave;
  final Function onBack;

  ContactInfoScreen({
    Key? key,
    required this.contact,
    required this.readonly,
    required this.onSave,
    required this.onBack,
  }) : super(key: key);

  @override
  _ContactInfoScreenState createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  dynamic _contact;
  bool _readonly = true;
  bool _isValid = false;
  String _contactTypeId = '';
  List<dynamic> filedsList = [];

  void _onChange(String key, dynamic value, bool isRequired) {
    _contact[key] = value;
    _validate();
  }

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _contact = this.widget.contact;

    _contactTypeId = _contact['CONTYPE_ID'] ?? 'STD';

    _initialize();
    _validate();

    super.initState();
  }

  _initialize() {
    var userFields = ContactService().getuserFields();
    var visibleFields = LookupService().getVisibleUserFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    filedsList = userFields
        .where((uf) => visibleFields.any((vf) =>
            vf['UDF_ID'] == uf['UDF_ID'] && vf['TYPE_ID'] == _contactTypeId))
        .toList();

    filedsList.forEach((field) {
      var isRequired = mandatoryFields.any((e) =>
          e['TABLE_NAME'] == field['FIELD_TABLE'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);

      field['ISREQUIRED'] = isRequired;
    });
  }

  _validate() {
    var isValid = ContactService().validateEntity(_contact);

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

                      if (_contact['CONT_ID'] != null) {
                        await ContactService()
                            .updateEntity(_contact!['CONT_ID'], _contact);
                      } else {
                        var newEntity =
                            await ContactService().addNewEntity(_contact);
                        _contact['CONT_ID'] = newEntity['CONT_ID'];
                      }

                      await widget.onSave(_contact);

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
          'ContactEditWindow',
          'InformationTab.Header',
        ),
        body: SingleChildScrollView(
          child: Container(
            child: InfoFieldService.generateFields(
              'Contact',
              _contactTypeId,
              _contact,
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
