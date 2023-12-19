import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_attachment_manager.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_create_related_records.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_info_section.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_view_related_records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ActionEditScreen extends StatefulWidget {
  final Map<String, dynamic> action;
  final bool readonly;
  final int popScreens;

  const ActionEditScreen({
    Key? key,
    required this.action,
    required this.readonly,
    required this.popScreens,
  }) : super(key: key);

  @override
  _ActionEditScreenState createState() => _ActionEditScreenState();
}

class _ActionEditScreenState extends State<ActionEditScreen> {
  bool _readonly = true;
  dynamic _action;
  // String _notes = '';
  // bool? _isNewNote;
  bool _isValid = false;

  var activeFields = ActionService().getActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  var key = UniqueKey();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _action = this.widget.action;

     print("_action12$_action");
    if (_action['ACTION_ID'] == null) {
      _action['ACTION_DATE'] = DateTime.now().toString();
      _action['ACTION_TIME'] = DateTime.now().toString();
      _action['ACTION_END_DATE'] = DateTime.now().toString();
      _action['ACTION_END_TIME'] = DateTime.now().toString();
      _action['SAUSER_ID'] = AuthUtil.getUserName();

      if (_action['ACTION_TYPE_ID'] == null) _action['ACTION_TYPE_ID'] = 'STD';

      if (_action['DESCRIPTION'] == null && _action['ACCTNAME'] != null)
        _action['DESCRIPTION'] = _action['ACCTNAME'];
    }
    setDealDescription();
    validate();

    super.initState();
  }

  setDealDescription() async {
    if (_action['DEAL_ID'] != null) {
      dynamic deal = await OpportunityService().getEntity(_action['DEAL_ID']);
      setState(() {
        _action['DEAL_DESCRIPTION'] = deal.data['DESCRIPTION'];
      });
    }
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    setState(() {
      if (key == 'NOTES' && (value == null || value == '')) value = ' ';

      _action[key] = value;
    });

    validate();
  }

  void validate() {
    var isValid = ActionService().validateEntity(_action);

    setState(() {
      _isValid = isValid;
    });
  }

  String _getIcon(String actionClass) {
    if (actionClass == 'T')
      return 'assets/images/new_phone_action.png';
    else if (actionClass == 'E')
      return 'assets/images/new_email_action.png';
    else if (actionClass == 'A')
      return 'assets/images/new_apmt_action.png';
    else if (actionClass == 'L')
      return 'assets/images/new_doc_action.png';
    else
      return 'assets/images/new_general_action.png';
  }

  String _getTtitle(String actionClass) {
    if (actionClass == 'T')
      return LangUtil.getString('Entities', 'Telephone.Create.Text');
    else if (actionClass == 'E')
      return LangUtil.getString('Entities', 'Email.Create.Text');
    else if (actionClass == 'A')
      return LangUtil.getString('Entities', 'Appointment.Create.Text');
    else if (actionClass == 'L')
      return LangUtil.getString('Entities', 'Document.Create.Text');
    else
      return LangUtil.getString('Entities', 'General.Create.Text');
  }

  @override
  Widget build(BuildContext context) {
    var visibleFields = activeFields.where((e) => e['COLVAL'] == true).toList();

    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onSave : null,
      ),
      title: LangUtil.getString('Entities', 'Action.Description.Plural'),
      body: Container(
        child: Form(
          child: Column(
            children: [
              PsaHeader(
                isVisible: false,
                icon: _getIcon(_action['CLASS']),
                title: (_action['ACTION_ID'] != null)
                    ? _action['ACCTNAME'] ?? ''
                    : _getTtitle(_action['CLASS']),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Builder(
                          builder: (BuildContext context) {
                            return DataFieldService().generateFields(
                              key,
                              'action',
                              _action,
                              visibleFields,
                              mandatoryFields,
                              _readonly,
                              _onChange,
                            );
                          },
                        ),
                      ),
                      ActionInfoSection(
                        action: _action,
                        readonly: _readonly,
                        onChange: _onChange,
                        onSave: onInfoSave,
                        onBack: onInfoBack,
                      ),
                      if ((_action['CLASS'] == 'L' ||
                              _action['CLASS'] == 'A'||_action['CLASS'] == 'E') &&
                          _action['ACTION_ID'] != null )
                        ActionAttachmentManager(action: _action),
                      if (_action['CLASS'] != 'G')
                        ActionViewRelatedRecords(
                          action: _action,
                          readonly: _readonly,
                          onChange: onChange,
                        ),
                      if (_action['CLASS'] != 'G')
                        ActionCreateRelatedRecords(
                          action: _action,
                          readonly: _readonly,
                          onChange: onChange,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onChange(List<dynamic> entity) {
    entity.forEach((prop) {
      _action[prop['KEY']] = prop['VALUE'];

      if (prop['KEY'] == 'ACCTNAME' &&
          (_action['DESCRIPTION'] == null || _action['DESCRIPTION'] == '')) {
        key = UniqueKey();

        setState(() {
          _action['DESCRIPTION'] = prop['VALUE'];
        });
      }
    });

    validate();
  }

  onInfoSave(dynamic action) {
    setState(() {
      _action = action;
    });
  }

  onInfoBack() {
    validate();
  }

  onSave() async {
   print(_action);
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }
    bool newAct = false;
    int count = 0;
    try {
      context.loaderOverlay.show();
      print("her");
      setState(() {
        print(_action['ACTION_DATE']);
        print(_action['ACTION_TIME']);
        _action['ACTION_DATE'] = DateUtil.formatDate(_action['ACTION_DATE'],_action['ACTION_TIME']);
        _action['ACTION_TIME'] = DateUtil.formatDate(_action['ACTION_DATE'],_action['ACTION_TIME']);
        _action['ACTION_END_DATE'] = DateUtil.formatDate(_action['ACTION_END_DATE'],_action['ACTION_END_TIME']);
        _action['ACTION_END_TIME'] = DateUtil.formatDate(_action['ACTION_END_DATE'],_action['ACTION_END_TIME']);
       print("Set staete$_action");
      });
      if(DateTime.parse(_action['ACTION_DATE']).isBefore(DateTime.parse(_action['ACTION_END_DATE']))||
          DateTime.parse(_action['ACTION_DATE']).isAtSameMomentAs(DateTime.parse(_action['ACTION_END_DATE']))){
        if (_action['ACTION_ID'] != null) {
          await ActionService().updateEntity(_action!['ACTION_ID'], _action);
        } else {
          var newEntity = await ActionService().addNewEntity(_action);
          _action['ACTION_ID'] = newEntity['ACTION_ID'];
          newAct = true;
        }

        if (_action['DEAL_ID'] != null && newAct) {
          var deal = {};
          deal['DEAL_ID'] = _action['DEAL_ID'];
          deal['ACCT_ID'] = _action['ACCT_ID'];
          deal['ACTION_ID'] = _action['ACTION_ID'];
          await OpportunityService().addCompanyOppLink(deal);
        }

        setState(() => _readonly = !_readonly);

        Navigator.of(context).popUntil((_) => count++ >= widget.popScreens);
      }
      else{
        ErrorUtil.showErrorMessage(context, 'Start Date cannot be later than End Date');
      }

    } on DioError catch (e) {
      print(e.toString());
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      if (!newAct) {
        print(e.toString());
        ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
      } else {
        Navigator.of(context).popUntil((_) => count++ >= widget.popScreens);
      }
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
