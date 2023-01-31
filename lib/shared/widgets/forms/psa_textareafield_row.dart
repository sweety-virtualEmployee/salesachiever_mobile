import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PsaTextAreaFieldRow extends StatefulWidget {
  final String fieldKey;
  final String? title;
  final String? value;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Function? onChange;
  final bool? isRequired;

  const PsaTextAreaFieldRow({
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
  _PsaTextAreaFieldRowState createState() => _PsaTextAreaFieldRowState();
}

class _PsaTextAreaFieldRowState extends State<PsaTextAreaFieldRow> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.value?.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CupertinoFormRow(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.title ?? '',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: widget.isRequired! && textController.text.isEmpty
                          ? Colors.red
                          : Colors.black),
                ),
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
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: widget.readOnly,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: (value) {
                    if (widget.onChange != null)
                      widget.onChange!(widget.fieldKey, value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
