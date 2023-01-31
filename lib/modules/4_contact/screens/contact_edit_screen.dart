import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/widgets/contact_create_related_records.dart';
import 'package:salesachiever_mobile/modules/4_contact/widgets/contact_info_section.dart';
import 'package:salesachiever_mobile/modules/4_contact/widgets/contact_view_related_records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ContactEditScreen extends StatefulWidget {
  final Map<String, dynamic> contact;
  final bool readonly;

  const ContactEditScreen({
    Key? key,
    required this.contact,
    required this.readonly,
  }) : super(key: key);

  @override
  _ContactEditScreenState createState() => _ContactEditScreenState();
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  bool _readonly = true;
  dynamic _contact;
  String _notes = '';
  bool? _isNewNote;
  bool _isValid = false;
  String _updatedFieldKey = '';

  var activeFields = ContactService().getActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _contact = this.widget.contact;

    if (_contact['CONT_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('Contact');

      defaultValues.forEach((element) {
        _contact[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_contact['CONT_ID'] == null) _contact['CONTYPE_ID'] = 'STD';
    }

    validate();

    super.initState();
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    setState(() {
      _contact[key] = value;

      if (key == 'FIRSTNAME' || key == 'SURNAME') {
        var firstName = _contact['FIRSTNAME'];
        var surname = _contact['SURNAME'];
        var initials = _contact['INITIALS'];

        _contact['INITIALS'] =
            firstName == null || firstName == '' ? '' : firstName.toString()[0];

        _contact['SALUTATION'] = '$initials $surname';
      }

      _updatedFieldKey = key;
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
    var isValid = ContactService().validateEntity(_contact);

    setState(() {
      _isValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    var visibleFields = activeFields.where((e) => e['COLVAL']).toList();

    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onTap : null,
      ),
      title: LangUtil.getString('Entities', 'Contact.Description.Plural'),
      body: Container(
        child: Column(
          children: [
            PsaHeader(
              isVisible: false,
                icon: 'assets/images/contact_icon.png',
                title: _contact['CONT_ID'] != null
                    ? '${_contact['FIRSTNAME']} ${_contact['SURNAME']}'
                    : LangUtil.getString('Entities', 'Contact.Create.Text')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: DataFieldService().generateFields(
                        key,
                        'Contact',
                        _contact,
                        visibleFields,
                        mandatoryFields,
                        _readonly,
                        _onChange,
                        _updatedFieldKey,
                      ),
                    ),
                    ContactInfoSection(
                      contact: _contact,
                      readonly: _readonly,
                      onChange: _onChange,
                      onNoteChange: _onNoteChange,
                      onSave: onInfoSave,
                      onBack: onInfoBack,
                    ),
                    ContactViewRelatedRecords(
                      entity: _contact,
                      contactId: _contact['CONT_ID'] ?? '',
                    ),
                    ContactCreateRelatedRecords(contact: _contact),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onInfoSave(dynamic contact) async {
    setState(() {
      _contact = contact;
    });

    await saveContact();
  }

  onInfoBack() {
    validate();
  }

  onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveContact();
  }

  Future<void> saveContact() async {
    try {
      context.loaderOverlay.show();

      if (_contact['CONT_ID'] != null) {
        await ContactService().updateEntity(_contact!['CONT_ID'], _contact);
      } else {
        var newEntity = await ContactService().addNewEntity(_contact);
        _contact['CONT_ID'] = newEntity['CONT_ID'];
      }

      if (_isNewNote != null) {
        if (_isNewNote!) {
          await ContactService().addContactNote(_contact['CONT_ID'], _notes);
        } else {
          await ContactService()
              .updateContactNote(_contact['CONT_ID'], _notes)
              .onError((error, stackTrace) => null);
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
