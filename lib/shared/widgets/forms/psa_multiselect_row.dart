import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_list_picker.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_multiselect_list.dart';
import 'package:salesachiever_mobile/utils/hive_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class PsaMultiSelectRow extends StatefulWidget {
  final String type;
  final String tableName;
  final String fieldName;
  final String selectedValue;
  final String title;
  final String value;
  final bool readOnly;
  final Function? onChange;
  final bool? isRequired;

  const PsaMultiSelectRow({
    Key? key,
    required this.type,
    required this.tableName,
    required this.fieldName,
    required this.title,
    required this.value,
    required this.selectedValue,
    this.readOnly = true,
    this.onChange,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _PsaMultiSelectRowState createState() => _PsaMultiSelectRowState();
}

class _PsaMultiSelectRowState extends State<PsaMultiSelectRow> {
  String selectedValue = '';

  @override
  void initState() {
    print("value of multiselecyy${widget.value}");
    print("value of multiselecyy${widget.selectedValue}");
    selectedValue = widget.selectedValue;
    print(selectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var contextId =
    HiveUtil.getContextId(widget.type, widget.tableName, widget.fieldName);

    _onTap() async {
      if (!widget.readOnly) {
        var result = await Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => PsaMultiListPicker(
              selectedValue:widget.selectedValue,
              title: widget.title,
              contextId: contextId,
            ),
          ),
        );
        print("here we are");
        print(result);
        setState(() {
          if (result != null && result != '') {
            selectedValue = result['selectedValue'];

            if (this.widget.onChange != null)
              this.widget.onChange!(widget.fieldName, selectedValue);
          }
        });
      }
    }

    return Container(
      color: Colors.white,
      child: CupertinoFormRow(
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Text(
                widget.title,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: widget.isRequired! && selectedValue == ''
                        ? Colors.red
                        : Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CupertinoTextField(
                  onTap: _onTap,
                  controller: TextEditingController()
                    ..text = LangUtil.getMultiListValue(contextId, selectedValue),
                  readOnly: true,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  suffix: Icon(context.platformIcons.rightChevron,color: Colors.grey,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
