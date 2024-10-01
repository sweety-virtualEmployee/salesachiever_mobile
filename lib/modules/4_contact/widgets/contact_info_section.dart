import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_info_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/utils/common_list_notes.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ContactInfoSection extends StatefulWidget {
  const ContactInfoSection({
    Key? key,
    required contact,
    required bool readonly,
    required Function onChange,
    required Function onNoteChange,
    required Function onSave,
    required Function onBack,
  })  : _contact = contact,
        _readonly = readonly,
        _onChange = onChange,
        _onNoteChange = onNoteChange,
        _onSave = onSave,
        _onBack = onBack,
        super(key: key);

  final dynamic _contact;
  final bool _readonly;
  final Function _onChange;
  final Function _onNoteChange;
  final Function _onSave;
  final Function _onBack;

  @override
  _ContactInfoSectionState createState() => _ContactInfoSectionState();
}

class _ContactInfoSectionState extends State<ContactInfoSection> {
  late Future futureNote;

  Future<dynamic> _fetchData() async {
    return await ContactService().getContactNote(widget._contact!['CONT_ID']);
  }

  @override
  void initState() {
    futureNote = _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaDropdownRow(
          type: 'Contact',
          tableName: 'CONTACT',
          fieldName: 'CONTYPE_ID',
          title: LangUtil.getString('CONTACT', 'CONTYPE_ID'),
          value: widget._contact['CONTYPE_ID'] ?? '',
          readOnly: widget._readonly,
          isRequired: true,
          onChange: (_, __) => widget._onChange(_, __, true),
        ),
        widget._contact!['CONT_ID']!=null?PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
              'AccountEditWindow', 'NotesTab.Header'),
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => CommonListNotes(
                  entityId: widget._contact['CONT_ID'],
                  entityType: "Contact",
                ),
              ),
            );
          },
        ):SizedBox(),
       /* FutureBuilder<dynamic>(
            future: futureNote,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return PsaTextAreaFieldRow(
                  key: Key('placehoder'),
                  fieldKey: 'NOTES',
                  title: LangUtil.getString(
                      'ContactEditWindow', 'NotesTab.Header'),
                  value: '',
                );

              return PsaTextAreaFieldRow(
                key: Key('control'),
                fieldKey: 'NOTES',
                title:
                    LangUtil.getString('ContactEditWindow', 'NotesTab.Header'),
                value: (snapshot.data != null && snapshot.data!.length > 0)
                    ? snapshot.data![0]['NOTES']
                    : '',
                onChange: (_, __) =>
                    widget._onNoteChange(_, __, snapshot.data?.length),
                readOnly: widget._readonly,
              );
            }),*/
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'ContactEditWindow',
            'InformationTab.Header',
          ),
          color: ContactService().validateUserFields(widget._contact)
              ? null
              : Colors.red,
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            if (widget._contact['CONTYPE_ID'] == null ||
                widget._contact['CONTYPE_ID'] == '') return false;
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ContactInfoScreen(
                  contact: widget._contact,
                  readonly: widget._readonly,
                  onSave: widget._onSave,
                  onBack: widget._onBack,
                ),
              ),
            ).then((value) {
              setState(() {});
            });
          },
        ),
      ],
    );
  }
}
