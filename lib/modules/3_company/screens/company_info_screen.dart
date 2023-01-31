import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';

import 'package:salesachiever_mobile/shared/services/info_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';



class CompanyInfoScreen extends StatefulWidget {
  final Map<String, dynamic> company;
  final bool readonly;
  final Function onSave;
  final Function onBack;

  CompanyInfoScreen({
    Key? key,
    required this.company,
    required this.readonly,
    required this.onSave,
    required this.onBack,
  }) : super(key: key);

  @override
  _CompanyInfoScreenState createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  dynamic _company;
  bool _readonly = true;
  bool _isValid = false;
  String _companyTypeId = '';
  List<dynamic> filedsList = [];
 

  void _onChange(String key, dynamic value, bool isRequired) {
    _company[key] = value;
    _validate();
  }

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _company = this.widget.company;

    _companyTypeId = _company['ACCT_TYPE_ID'] ?? 'STD';

    _initialize();
    _validate();

    super.initState();
  }

  _initialize() {
    var userFields = CompanyService().getuserFields();
    var visibleFields = LookupService().getVisibleUserFields();
    var mandatoryFields = LookupService().getMandatoryFields();

    filedsList = userFields
        .where((uf) => visibleFields.any((vf) =>
            vf['UDF_ID'] == uf['UDF_ID'] && vf['TYPE_ID'] == _companyTypeId))
        .toList();

    filedsList.forEach((field) {
      var isRequired = mandatoryFields.any((e) =>
          e['TABLE_NAME'] == field['FIELD_TABLE'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);

      field['ISREQUIRED'] = isRequired;
    });
  }

  _validate() {
    var isValid = CompanyService().validateEntity(_company);

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
              : onSave, //_company['ACCT_ID'] != null ? onSave : null,
        ),
        title: LangUtil.getString(
          'AccountEditWindow',
          'InformationTab.Header',
        ),
        body: SingleChildScrollView(
          child: Container(
            child: InfoFieldService.generateFields(
              'Account',
              _companyTypeId,
              _company,
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

      if (_company['ACCT_ID'] != null) {
        await CompanyService().updateEntity(_company!['ACCT_ID'], _company);
      } else {
        var newEntity = await CompanyService().addNewEntity(_company);
        _company['ACCT_ID'] = newEntity['ACCT_ID'];
      }

      await widget.onSave(_company);

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
