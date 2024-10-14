import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/services/potential_service.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/widgets/potential_info_section.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class PotentialEditScreen extends StatefulWidget {
  final Map<String, dynamic> potential;
  final bool readonly;
  final String? dealId;

  const PotentialEditScreen({
    Key? key,
    required this.potential,
    required this.readonly,
    this.dealId,
  }) : super(key: key);

  @override
  _PotentialEditScreenState createState() => _PotentialEditScreenState();
}

class _PotentialEditScreenState extends State<PotentialEditScreen> {
  bool _readonly = true;
  dynamic _potential;
  bool _isValid = false;
  String? _dealId = null;

  var activeFields = PotentialService().getActiveFields();
  var mandatoryFields = LookupService().getMandatoryFields();

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _potential = this.widget.potential;
    _dealId = this.widget.dealId;

    if (_potential['DEALPOT_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues('DEAL_POTENTIAL');

      defaultValues.forEach((element) {
        _potential[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });

      if (_potential['TYPE_ID'] == null) _potential['TYPE_ID'] = 'STD';
    }

    validate();

    super.initState();
  }

  void _onChange(String key, dynamic value) {
    setState(() {
      _potential[key] = value;
    });

    validate();
  }

  void validate() {
    var isValid = PotentialService().validateEntity(_potential);

    setState(() {
      _isValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var visibleFields = activeFields.where((e) => e['COLVAL']).toList();

    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: (_isValid || _readonly) ? onSave : null,
      ),
      title: LangUtil.getString('ProductSearchWindow', 'Title'),
      body: Container(
        child: Column(
          children: [
            PsaHeader(
              isVisible: false,
                icon: 'assets/images/opportunity_icon.png',
                title: LangUtil.getString('OpportunityPotentialEditWindow', 'Title')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PotentialInfoSection(
                      deal: _potential,
                      readonly: _readonly,
                      onChange: _onChange,
                      onSave: onInfoSave,
                      onBack: onInfoBack,
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

  onInfoSave(dynamic potential) async {
    setState(() {
      _potential = potential;
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

      if (_potential['DEALPOT_ID'] != null) {
        await PotentialService().updateEntity(_potential!['DEALPOT_ID'], _potential);
      } else {
        _potential['DEAL_ID'] = this._dealId;
        _potential['DEALPOT_ID'] = this._dealId;
        await PotentialService().addNewEntity(_potential);
      }

      setState(() => _readonly = !_readonly);
    } on DioException catch (e) {
      ErrorUtil.showErrorMessage(context, e.message!);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
