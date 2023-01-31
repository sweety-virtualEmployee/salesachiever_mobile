import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';

class PsaTimeFieldRow extends StatefulWidget {
  final String fieldKey;
  final String? title;
  final String? value;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Function? onChange;
  final bool? isRequired;

  const PsaTimeFieldRow({
    Key? key,
    required this.fieldKey,
    required this.title,
    this.readOnly = true,
    this.value,
    this.keyboardType,
    this.onChange,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _PsaTimeFieldRowState createState() => _PsaTimeFieldRowState();
}

class _PsaTimeFieldRowState extends State<PsaTimeFieldRow> {
  final textController = TextEditingController();
  String? value;

  @override
  void initState() {
    textController.text = widget.value?.toString() ?? '';
    value = DateUtil.getFormattedTime(widget.value);
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
                    color: widget.isRequired! && (value?.isEmpty ?? true)
                        ? Colors.red
                        : Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CupertinoTextField(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  readOnly: true,
                  onTap: () {
                    if (widget.readOnly) return;

                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,
                      onChanged: (date) {
                        onDateSelect(date);
                      },
                      onConfirm: (date) {
                        onDateSelect(date);
                      },
                      currentTime:
                          DateTime.tryParse(widget.value!) ?? DateTime.now(),
                    );
                  },
                  controller: textController..text = value ?? '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDateSelect(DateTime date) {
    setState(() {
      value = DateUtil.getFormattedTime(date.toString());
    });

    if (widget.onChange != null) widget.onChange!(widget.fieldKey, value);
  }
}
