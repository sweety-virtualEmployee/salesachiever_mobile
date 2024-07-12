import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/CustomWidgets/CustomUrlLauncher.dart';
import 'package:url_launcher/url_launcher.dart';

class PsaTextFieldRow extends StatefulWidget {
  final String fieldKey;
  final String? title;
  final String? value;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Function? onChange;
  final bool? isRequired;
  final String? updatedFieldKey;
  final int? maxLines;

  const PsaTextFieldRow({
    Key? key,
    required this.fieldKey,
    required this.title,
    this.readOnly = false,
    this.value,
    this.keyboardType,
    this.onChange,
    this.maxLines = 1,
    this.isRequired = false,
    this.updatedFieldKey,
  }) : super(key: key);

  @override
  _PsaTextFieldRowState createState() => _PsaTextFieldRowState();
}

class _PsaTextFieldRowState extends State<PsaTextFieldRow> {
  final textController = TextEditingController();
  List <dynamic>data =[];
  bool ?_validNumber;

  @override
  void initState() {
    _validNumber;
    print("yeslvhkdba");
    print(widget.value);
    textController.text = widget.value?.toString() ?? '';
    super.initState();
  }

  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    print("widget.titile${widget.title}");

    _validNumber =  RegExp(r'^[789]\d{13}$').hasMatch(textController.text);
 //   bool _validURL = Uri.parse(textController.text).isAbsolute;
    bool _validEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(textController.text);

    if (widget.updatedFieldKey != null &&
        widget.updatedFieldKey != '' &&
        widget.updatedFieldKey != widget.fieldKey) {
      textController.text = widget.value?.toString() ?? '';
    }

    return Container(
      color: Colors.white,
      child: CupertinoFormRow(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CupertinoTextField(
                  maxLines: widget.maxLines,
                  controller: textController,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  style: TextStyle(
                      color:  widget.title == "Web Site"?Colors.blue:widget.title == "Telephone # (Cell)"?Colors.blue:widget.title == "Telephone # (Direct)"?Colors.blue: widget.title == "Telephone # (Home)"?Colors.blue:
                      widget.title == "Telephone number"?Colors.blue:
                      widget.title == "Office Phone"?Colors.blue:
                      widget.title == "Phone Number"?Colors.blue: _validEmail || _validNumber!
                          ? Colors.blue
                          : Colors.grey.shade700,
                      fontSize: 15),
                  keyboardType: widget.keyboardType,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: widget.readOnly,
                  onTap: () {
                    if (widget.readOnly && widget.title=="Web Site")
                     // print(widget.title);
                      _launchURL(textController.text);
                    else if ( _validEmail)
                      _launchURL('mailto:${textController.text}');
                    else if ( widget.title=="Telephone number"|| widget.title=="Telephone # (Cell)"|| widget.title=="Telephone # (Direct)"|| widget.title=="Telephone # (Home)"||widget.title=="Phone Number"||widget.title=="Office Phone")
                     CustomUrlLauncher.launchPhoneURL(textController.text);
                  },
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

typedef ValueCallback = void Function(String value);
