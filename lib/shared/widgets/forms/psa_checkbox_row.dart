import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaCheckBoxRow extends StatefulWidget {
  final String fieldKey;
  final String? title;
  final bool? value;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Function? onChange;
  final bool? isRequired;

  const PsaCheckBoxRow({
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
  _PsaCheckBoxRowState createState() => _PsaCheckBoxRowState();
}

class _PsaCheckBoxRowState extends State<PsaCheckBoxRow> {
  final textController = TextEditingController();
  bool isEmpty = true;
  bool value = false;

  @override
  void initState() {
    textController.text = widget.value?.toString() ?? '';
    isEmpty = textController.text.isEmpty;
    value = widget.value ?? false;
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
                    color: widget.isRequired! && isEmpty
                        ? Colors.red
                        : Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  children: [
                    PlatformSwitch(
                      onChanged: (bool val) {
                        if (widget.readOnly) return;

                        setState(() {
                          value = val;
                        });

                        if (widget.onChange != null)
                          widget.onChange!(widget.fieldKey, value.toString());
                      },
                      value: value,
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
}
