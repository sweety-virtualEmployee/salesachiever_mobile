import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PsaFloatFieldRow extends StatefulWidget {
  final String fieldKey;
  final String? title;
  final double? value;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Function? onChange;
  final bool? isRequired;

  const PsaFloatFieldRow({
    Key? key,
    required this.fieldKey,
    required this.title,
    this.readOnly = false,
    this.value,
    this.keyboardType,
    this.onChange,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _PsaFloatFieldRowState createState() => _PsaFloatFieldRowState();
}

class _PsaFloatFieldRowState extends State<PsaFloatFieldRow> {
  final textController = TextEditingController();

  @override
  void initState() {
    var value = widget.value;

    textController.text = value?.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CupertinoFormRow(
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Text(
                widget.title ?? '',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: widget.isRequired! && textController.text.isEmpty
                        ? Colors.red
                        : Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CupertinoTextField(
                  controller: textController,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  keyboardType: widget.keyboardType,
                  readOnly: widget.readOnly,
                  onChanged: (value) {
                    if (widget.onChange != null) {
                      if (value.isEmpty)
                        widget.onChange!(widget.fieldKey, null);
                      else
                        widget.onChange!(
                            widget.fieldKey, double.tryParse(value));
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    // ThousandsSeparatorInputFormatter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
