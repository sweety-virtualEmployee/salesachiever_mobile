import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_info_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/screens/potential_list_opportunity.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class OpportunityInfoSection extends StatefulWidget {
  const OpportunityInfoSection({
    Key? key,
    required deal,
    required bool readonly,
    required bool isNew,
    required Function onChange,
    required Function onNoteChange,
    required Function onSave,
    required Function onBack,
  })  : _deal = deal,
        _readonly = readonly,
        _isNew = isNew,
        _onChange = onChange,
        _onNoteChange = onNoteChange,
        _onSave = onSave,
        _onBack = onBack,
        super(key: key);

  final dynamic _deal;
  final bool _readonly;
   final bool _isNew;
  final Function _onChange;
  final Function _onNoteChange;
  final Function _onSave;
  final Function _onBack;

  @override
  _OpportunityInfoSectionState createState() => _OpportunityInfoSectionState();
}

class _OpportunityInfoSectionState extends State<OpportunityInfoSection> {
  late Future<List<dynamic>> futureNote;

  Future<List<dynamic>> _fetchData() async {
    return await OpportunityService().getDealNote(widget._deal!['DEAL_ID']);
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
          type: 'Deal',
          tableName: 'DEAL',
          fieldName: 'DEAL_TYPE_ID',
          title: LangUtil.getString('DEAL', 'DEAL_TYPE_ID'),
          value: widget._deal['DEAL_TYPE_ID'] ?? '',
          readOnly: widget._readonly,
          isRequired: true,
          onChange: (_, __) => widget._onChange(_, __, false),
        ),
        FutureBuilder<List<dynamic>>(
            future: futureNote,
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return PsaTextAreaFieldRow(
                  key: Key('placehoder'),
                  fieldKey: 'NOTES',
                  title: LangUtil.getString(
                      'OpportunityEditWindow', 'NotesTab.Header'),
                  value: '',
                );

              return PsaTextAreaFieldRow(
                key: Key('control'),
                fieldKey: 'NOTES',
                title: LangUtil.getString(
                    'OpportunityEditWindow', 'NotesTab.Header'),
                value: (snapshot.data != null && snapshot.data!.length > 0)
                    ? snapshot.data![0]['NOTES']
                    : '',
                onChange: (_, __, ____) =>
                    widget._onNoteChange(_, __, snapshot.data?.length),
                readOnly: widget._readonly,
              );
            }),
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'InformationTab.Header',
          ),
          color: OpportunityService().validateUserFields(widget._deal)
              ? null
              : Colors.red,
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            if (widget._readonly) return false;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => OpportunityInfoScreen(
                  deal: widget._deal,
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
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'PotentialTab.Header',
          ),
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            if (widget._deal['DEAL_ID'] == null || widget._readonly ||
                widget._deal['DEAL_ID'] == '' || this.widget._isNew ) return false;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) =>
                    PotentialListOpportunity(dealId: widget._deal!['DEAL_ID']),
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
