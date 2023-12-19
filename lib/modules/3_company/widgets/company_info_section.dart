import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_info_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class CompanyInfoSection extends StatefulWidget {
  const CompanyInfoSection({
    Key? key,
    required company,
    required bool readonly,
    required Function onChange,
    required Function onNoteChange,
    required Function onSave,
    required Function onBack,
  })  : _company = company,
        _readonly = readonly,
        _onChange = onChange,
        _onNoteChange = onNoteChange,
        _onSave = onSave,
        _onBack = onBack,
        super(key: key);

  final dynamic _company;
  final bool _readonly;
  final Function _onChange;
  final Function _onNoteChange;
  final Function _onSave;
  final Function _onBack;

  @override
  _CompanyInfoSectionState createState() => _CompanyInfoSectionState();
}

class _CompanyInfoSectionState extends State<CompanyInfoSection> {
  late Future<List<dynamic>> futureNote;


  Future<List<dynamic>> _fetchData() async {
    return await CompanyService().getCompanyNote(widget._company!['ACCT_ID']);
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
          type: 'Account',
          tableName: 'ACCOUNT',
          fieldName: 'ACCT_TYPE_ID',
          title: LangUtil.getString('ACCOUNT', 'ACCT_TYPE_ID'),
          value: widget._company['ACCT_TYPE_ID'] ?? '',
          readOnly: widget._readonly,
          isRequired: true,
          onChange: (_, __) => widget._onChange(_, __, true),
        ),
        FutureBuilder<List<dynamic>>(
            future: futureNote,
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return PsaTextAreaFieldRow(
                  key: Key('placehoder'),
                    fieldKey: 'NOTES',
                  title: LangUtil.getString(
                      'AccountEditWindow', 'NotesTab.Header'),
                  value: '',
                );

              return PsaTextAreaFieldRow(
                key: Key('control'),
                fieldKey: 'NOTES',
                title:
                    LangUtil.getString('AccountEditWindow', 'NotesTab.Header'),
                value: (snapshot.data != null && snapshot.data!.length > 0)
                    ? snapshot.data![0]['NOTES']
                    : '',
                onChange: (_, __) =>
                    widget._onNoteChange(_, __, snapshot.data?.length),
                readOnly: widget._readonly,
              );
            }),
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'AccountEditWindow',
            'InformationTab.Header',
          ),
          color: CompanyService().validateUserFields(widget._company)
              ? null
              : Colors.red,
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            if (widget._company['ACCT_TYPE_ID'] == null ||
                widget._company['ACCT_TYPE_ID'] == '') return false;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => CompanyInfoScreen(
                  company: widget._company,
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
