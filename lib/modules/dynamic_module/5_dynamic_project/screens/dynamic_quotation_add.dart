import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_quotation_view_Records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class DynamicQuotationAddScreen extends StatefulWidget {
  final Map<String, dynamic> quotation;
  final bool readonly;

  const DynamicQuotationAddScreen({
    Key? key,
    required this.quotation,
    required this.readonly,
  }) : super(key: key);

  @override
  _DynamicQuotationAddScreenState createState() => _DynamicQuotationAddScreenState();
}

class _DynamicQuotationAddScreenState extends State<DynamicQuotationAddScreen> {
  bool _readonly = true;
  dynamic _quotation;

  bool _isValid = false;

  var activeFields = DynamicProjectService().getDynamicActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _quotation = this.widget.quotation;
    log("_quotation$_quotation");

    if (_quotation['QUOTE_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('Quotation');

      defaultValues.forEach((element) {
        _quotation[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_quotation['QUOTE_TYPE_ID'] == null) _quotation['QUOTE_TYPE_ID'] = 'STD';
    }

    validate();

    super.initState();
  }

  void _onChange(String key, dynamic value, bool isRequired) {
    setState(() {
      if (key == 'SITE_COUNTRY' && _quotation[key] != value) {
        _quotation['SITE_COUNTY'] = '';
      }

      _quotation[key] = value;
    });

    validate();
  }

  void validate() {
    var isValid = DynamicProjectService().validateEntity(_quotation);

    setState(() {
      _isValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    var visibleFileds = activeFields.where((e) => e['COLVAL']).toList();
    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onTap : null,
      ),
      title: LangUtil.getString('Entities', 'Quotation.Description.Plural'),
      body: Container(
        child: Column(
          children: [
            PsaHeader(
                isVisible: true,
                icon: 'assets/images/Quote.png',
                title: _quotation?['DESCRIPTION'] ??
                    LangUtil.getString('Entities', 'NewQuotation.Title')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: DataFieldService().generateFields(
                          key,
                          'quotation',
                          _quotation,
                          visibleFileds,
                          mandatoryFields,
                          _readonly,
                          _onChange),
                    ),
                    DynamicQuotationViewRelatedRecords(
                      quotation: _quotation,
                      readonly: _readonly,
                      onChange: onChange,
                      quotationId: _quotation["QUOTE_ID"]!=null?_quotation["QUOTE_ID"]:"",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  onChange(List<dynamic> entity) {
    entity.forEach((prop) {
      _quotation[prop['KEY']] = prop['VALUE'];
      print(_quotation);
    });

    validate();
  }

  onInfoSave(dynamic quotation) async {
    setState(() {
      _quotation = quotation;
    });

    await saveProject();
  }

  onInfoBack() {
    validate();
  }

  onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveProject();
  }

  Future<void> saveProject() async {
    try {
      context.loaderOverlay.show();
       print("qupattion$_quotation");
      if (_quotation['QUOTE_ID'] != null) {
        await DynamicProjectService().updateEntity(_quotation!['QUOTE_ID'], _quotation);
      } else {
        var newEntity = await DynamicProjectService().addNewEntity(_quotation);
        _quotation['QUOTE_ID'] = newEntity['QUOTE_ID'];
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
