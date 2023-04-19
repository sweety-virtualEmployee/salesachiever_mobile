import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_List_picker.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_list_picker.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/hive_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

import '../services/dynamic_project_service.dart';

class DynamicPsaDropdownRow extends StatefulWidget {
  final String type;
  final String tableName;
  final String fieldName;
  final String returnField;
  final String title;
  final String value;
  final String? lkApi;
  final bool readOnly;
  final Function? onChange;
  final bool? isRequired;
  final String fieldKey;

  const DynamicPsaDropdownRow({
    Key? key,
    required this.type,
    required this.tableName,
    required this.fieldName,
    required this.returnField,
    this.lkApi,
    required this.title,
    required this.value,
    required this.fieldKey,
    this.readOnly = true,
    this.onChange,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _DynamicPsaDropdownRowState createState() => _DynamicPsaDropdownRowState();
}

class _DynamicPsaDropdownRowState extends State<DynamicPsaDropdownRow> {
  String selectedValue = '';
  DynamicProjectService service = DynamicProjectService();
  TextEditingController controller=TextEditingController();


  @override
  void initState() {
    selectedValue = widget.value;
    getListValue();
    super.initState();
  }

  getListValue() async {
    context.loaderOverlay.show();
    print("data of the value");
    print(widget.lkApi);
    List<String> urlParts = widget.lkApi!.split('/');
    String lastPart = urlParts.last;
    if (lastPart.isNotEmpty) {
      var response = await service.getLookByRecordId(widget.lkApi!);
      setState(() {
        controller.text = response["ACCTNAME"];
      });
    } else {
      setState(() {
        controller.text ="";
      });    }

    context.loaderOverlay.hide();
  }


  @override
  Widget build(BuildContext context) {

    _onTap() async{
      if (!widget.readOnly) {
      context.loaderOverlay.show();
      var response = await service.getLookByDDL(widget.tableName,widget.fieldName,widget.returnField,1);
      context.loaderOverlay.hide();
      print(widget.readOnly);
        var result = await Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => DynamicPsaListPicker(
              title: widget.title,
              listValue: response,
              fieldName: widget.fieldName,
              tableName: widget.tableName,
              returnField: widget.returnField,
            ),
          ),
        );
        print("come back");
        print(result);
        setState(() {
          if (result != null && result != '') {
            selectedValue = result['ID'];

            if (this.widget.onChange != null)
              this.widget.onChange!(widget.fieldKey, selectedValue);
          }
          if(result['TEXT']!=null) {
            controller.text = result['TEXT'];
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
                  readOnly: true,
                  controller: controller,
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
