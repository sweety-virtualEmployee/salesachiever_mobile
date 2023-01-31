import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_floatfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_numberfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class PotentialInfoSection extends StatefulWidget {
  const PotentialInfoSection({
    Key? key,
    required deal,
    required bool readonly,
    required Function onChange,
    required Function onSave,
    required Function onBack,
  })  : _deal = deal,
        _readonly = readonly,
        _onChange = onChange,
        _onSave = onSave,
        _onBack = onBack,
        super(key: key);

  final dynamic _deal;
  final bool _readonly;
  final Function _onChange;
  final Function _onSave;
  final Function _onBack;

  @override
  _PotentialInfoSectionState createState() => _PotentialInfoSectionState();
}

class _PotentialInfoSectionState extends State<PotentialInfoSection> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaTextFieldRow(
          key: Key('productId'),
          fieldKey: 'PRODUCT_ID',
          title: LangUtil.getString('DEAL_POTENTIAL', 'PRODUCT_ID'),
          value: this.widget._deal['PRODUCT_ID'] != null ? this.widget._deal['PRODUCT_ID'].toString() : "0",
          readOnly: true,
        ),
        PsaFloatFieldRow(
          key: Key('value'),
          fieldKey: 'VALUE',
          title: LangUtil.getString('DEAL_POTENTIAL', 'VALUE'),
          value: this.widget._deal['VALUE'] != null ? this.widget._deal['VALUE'] : 0.00,
          readOnly: this.widget._readonly,
          onChange: (_, __) => widget._onChange(_,__),
        ),
        PsaFloatFieldRow(
          key: Key('quantity'),
          fieldKey: 'QUANTITY',
          title: LangUtil.getString('DEAL_POTENTIAL', 'QUANTITY'),
          value: this.widget._deal['QUANTITY'] != null ? this.widget._deal['QUANTITY'] : 0,
          readOnly: this.widget._readonly,
          onChange: (_, __) => widget._onChange(_,__),
        ),
        PsaTextFieldRow(
          key: Key('notes'),
          fieldKey: 'NOTES',
          title: LangUtil.getString('DEAL_POTENTIAL', 'NOTES'),
          value: this.widget._deal['NOTES'] != null ? this.widget._deal['NOTES'] : '',
          readOnly: this.widget._readonly,
          onChange: (_, __) => widget._onChange(_,__),
        ),
      ],
    );
  }
}
