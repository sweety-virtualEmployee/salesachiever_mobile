import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/widgets/opportunity_create_related_records.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/widgets/opportunity_info_section.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/widgets/opportunity_view_related_records.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/shared/screens/add_related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class OpportunityEditScreen extends StatefulWidget {
  final Map<String, dynamic> deal;
  final dynamic project;
  final bool readonly;

  const OpportunityEditScreen({
    Key? key,
    required this.deal,
    this.project,
    required this.readonly,
  }) : super(key: key);

  @override
  _OpportunityEditScreenState createState() => _OpportunityEditScreenState();
}

class _OpportunityEditScreenState extends State<OpportunityEditScreen> {
  bool _readonly = true;
  dynamic _deal;
  dynamic _project;
  String _notes = '';
  bool? _isNewNote;
  bool _isValid = false;

  var activeFields = OpportunityService().getDynamicActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _deal = this.widget.deal;
    _project = this.widget.project;

    if (_deal['DEAL_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('Deal');

      defaultValues.forEach((element) {
        _deal[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_deal['DEAL_TYPE_ID'] == null) _deal['DEAL_TYPE_ID'] = 'STD';
    }

    validate();

    super.initState();
  }

  void _onChange(String key, String value, bool isRequired) {
    setState(() {
      _deal[key] = value;
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
    var isValid = OpportunityService().validateEntity(_deal);

    setState(() {
      _isValid = isValid;
    });
  }

  showPopup() async {
    List<dynamic> list = [];

    list = await CompanyService().getRelatedEntity(
      'Opportunity',
      _deal['DEAL_ID'],
      'companies?pageSize=1000&pageNumber=1',
    );

    if (list.length == 0) {
      // set up the button
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
          if (_deal['DEAL_ID'] == null) return;
          context.loaderOverlay.hide();
          Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (BuildContext context) => AddRelatedEntityScreen(
                deal: {
                  'ID': _deal['DEAL_ID'],
                  'TEXT': _deal['DESCRIPTION'],
                },
                type: "opp",
              ),
            ),
          );
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Confirmations"),
        content: Text(
            "You have not linked this Opportunity to any Companies. Do you want to create a link now?"),
        actions: [
          cancelButton,
          okButton,
        ],
      );

      // show the dialog
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var visibleFields = activeFields.where((e) => e['COLVAL']=="1").toList();

    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onSave : null,
      ),
      title: LangUtil.getString('Entities', 'Opportunity.Description.Plural'),
      body: Container(
        child: Column(
          children: [
            PsaHeader(
              isVisible: true,
                icon: 'assets/images/opportunity_icon.png',
                title: _deal['DESCRIPTION'] ??
                    LangUtil.getString(
                        'OpportunityEditWindow', 'NewOpportunity.Title')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: DataFieldService().generateFields(
                          key,
                          'Deal',
                          _deal,
                          visibleFields,
                          mandatoryFields,
                          _readonly,
                          _onChange),
                    ),
                    OpportunityInfoSection(
                      deal: _deal,
                      readonly: _readonly,
                      isNew: _deal['DEAL_ID'] == null,
                      onChange: _onChange,
                      onNoteChange: _onNoteChange,
                      onSave: onInfoSave,
                      onBack: onInfoBack,
                    ),
                    OpportunityViewRelatedRecords(
                        entity: _deal,
                        dealId: _deal['DEAL_ID'] ?? '',
                        onChange: _onChange),
                    if (_deal['DEAL_ID'] != null)
                      OpportunityCreateRelatedRecords(
                          deal: _deal, onChange: _onChange),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onInfoSave(dynamic deal) async {
    setState(() {
      _deal = deal;
    });

    await saveDeal();
  }

  onInfoBack() {
    validate();
  }

  onSave() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveDeal();
  }

  Future<void> saveDeal() async {
    try {
      context.loaderOverlay.show();
      if (_deal['DEAL_ID'] != null) {
        await showPopup();
        await OpportunityService().updateEntity(_deal!['DEAL_ID'], _deal);
      } else {
        if (_project != null) {
          _deal['PROJECT_ID'] = _project['PROJECT_ID'];
          _deal['PROJECT_TITLE'] = _project['PROJECT_TITLE'];
        }
        var newEntity = await OpportunityService().addNewEntity(_deal);
        _deal['DEAL_ID'] = newEntity['DEAL_ID'];
      }

      if (_isNewNote != null) {
        if (_isNewNote!) {
          await OpportunityService().addDealNote(_deal['DEAL_ID'], _notes);
        } else {
          await OpportunityService().updateDealNote(_deal['DEAL_ID'], _notes);
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
