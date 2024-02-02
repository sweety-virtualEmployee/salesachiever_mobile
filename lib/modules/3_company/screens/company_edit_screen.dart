import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/3_company/widgets/company_create_related_records.dart';
import 'package:salesachiever_mobile/modules/3_company/widgets/company_info_section.dart';
import 'package:salesachiever_mobile/modules/3_company/widgets/company_view_related_records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class CompanyEditScreen extends StatefulWidget {
  final Map<String, dynamic> company;
  final bool readonly;

  const CompanyEditScreen({
    Key? key,
    required this.company,
    required this.readonly,
  }) : super(key: key);

  @override
  _CompanyEditScreenState createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends State<CompanyEditScreen> {
  bool _readonly = true;
  dynamic _company;
  String _notes = '';
  bool? _isNewNote;
  bool _isValid = false;

  var activeFields = CompanyService().getDynamicActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _company = this.widget.company;
    print("data....***${widget.company}-------$_company");
    if (_company['ACCT_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('Account');

      defaultValues.forEach((element) {
        _company[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_company['ACCT_TYPE_ID'] == null) _company['ACCT_TYPE_ID'] = 'STD';
    }

    validate();

    super.initState();
  }

  void _onChange(String key, String value, bool isRequired) {
    setState(() {
      if (key == 'COUNTRY' && _company[key] != value) {
        _company['COUNTY'] = '';
      }

      _company[key] = value;
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
    var isValid = CompanyService().validateEntity(_company);

    setState(() {
      _isValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("_Comapny entity check${_company}");
    var visibleFields = activeFields.where((e) => e['COLVAL']=="1").toList();

    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onSave : null,
      ),
      title: LangUtil.getString('Entities', 'Account.Description.Plural'),
      body: Container(
        child: Column(
          children: [
            PsaHeader(
              isVisible: false,
                icon: 'assets/images/company_icon.png',
                title: _company['ACCTNAME'] ??
                    LangUtil.getString('Entities', 'Account.Create.Text')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: DataFieldService().generateFields(
                          key,
                          'Account',
                          _company,
                          visibleFields,
                          mandatoryFields,
                          _readonly,
                          _onChange),
                    ),
                    CompanyInfoSection(
                      company: _company,
                      readonly: _readonly,
                      onChange: _onChange,
                      onNoteChange: _onNoteChange,
                      onSave: onInfoSave,
                      onBack: onInfoBack,
                    ),
                    CompanyViewRelatedRecords(
                      entity: _company,
                      companyId: _company['ACCT_ID'] ?? '',
                    ),
                    CompanyCreateRelatedRecords(company: _company),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onInfoSave(dynamic company) async {
    setState(() {
      _company = company;
    });

    await saveCompany();
  }

  onInfoBack() {
    validate();
  }

  onSave() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveCompany();
  }

  Future<void> saveCompany() async {
    try {
      context.loaderOverlay.show();

      if (_company['ACCT_ID'] != null) {
        await CompanyService().updateEntity(_company!['ACCT_ID'], _company);
      } else {
        var newEntity = await CompanyService().addNewEntity(_company);
        _company['ACCT_ID'] = newEntity['ACCT_ID'];
      }

      if (_isNewNote != null) {
        if (_isNewNote!) {
          await CompanyService().addCompanyNote(_company['ACCT_ID'], _notes);
        } else {
          await CompanyService().updateCompanyNote(_company['ACCT_ID'], _notes);
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
