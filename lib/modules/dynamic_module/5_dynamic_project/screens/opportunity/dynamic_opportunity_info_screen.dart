import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/shared/services/info_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class DynamicOpportunityInfoScreen extends StatefulWidget {
  final Map<String, dynamic> deal;
  final bool readonly;
  final Function onSave;
  final Function onBack;

  DynamicOpportunityInfoScreen({
    Key? key,
    required this.deal,
    required this.readonly,
    required this.onSave,
    required this.onBack,
  }) : super(key: key);

  @override
  _DynamicOpportunityInfoScreenState createState() => _DynamicOpportunityInfoScreenState();
}

class _DynamicOpportunityInfoScreenState extends State<DynamicOpportunityInfoScreen> {
  dynamic _deal;
  bool _readonly = true;
  bool _isValid = false;
  String _dealTypeId = '';
  List<dynamic> filedsList = [];

  void _onChange(String key, dynamic value , dynamic isRequired) {
    _deal[key] = value;
    _validate();
  }

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _deal = this.widget.deal;

    _dealTypeId = _deal['DEAL_TYPE_ID'] ?? 'STD';

    _initialize();
    _validate();

    super.initState();
  }

  _initialize() {
    var userFields = OpportunityService().getuserFields();
    var visibleFields = LookupService().getVisibleUserFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    filedsList = userFields
        .where((uf) => visibleFields.any((vf) =>
    vf['UDF_ID'] == uf['UDF_ID'] && vf['TYPE_ID'] == _dealTypeId))
        .toList();

    filedsList.forEach((field) {
      var isRequired = mandatoryFields.any((e) =>
      e['TABLE_NAME'] == field['FIELD_TABLE'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);

      field['ISREQUIRED'] = isRequired;
    });
  }

  _validate() {
    var isValid = OpportunityService().validateEntity(_deal);

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
          onTap: onSave, //_company['ACCT_ID'] != null ? onSave : null,
        ),
        title: LangUtil.getString(
          'AccountEditWindow',
          'InformationTab.Header',
        ),
        body: SingleChildScrollView(
          child: Container(
            child: InfoFieldService.generateFields(
              'Deal',
              _dealTypeId,
              _deal,
              filedsList,
              _readonly,
              _onChange,
            ),
          ),
        ),
      ),
    );
  }

  onSave() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    try {
      context.loaderOverlay.show();

      await widget.onSave(_deal);

      setState(() => _readonly = !_readonly);

      Navigator.pop(context);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
