import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';

class PsaMultiListPicker extends StatefulWidget {
  final String title;
  final String contextId;
   String selectedValue;

   PsaMultiListPicker({
    Key? key,
    required this.selectedValue,
    required this.title,
    required this.contextId,
  }) : super(key: key);
  @override
  State<PsaMultiListPicker> createState() => _PsaMultiListPickerState();
}

class _PsaMultiListPickerState extends State<PsaMultiListPicker> {
  String updatedString="";

  @override
  void initState() {
    updatedString = widget.selectedValue;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("list print${widget.contextId}");
    List<Locale> listValues = LangUtil.getLocaleList(widget.contextId);
    print("list print$listValues");

    listValues.sort((a, b) => a.displayValue.compareTo(b.displayValue));

    return PsaScaffold(
      title: widget.title,
      action: PsaEditButton(
        text:  'Save',
        onTap: (){
          Navigator.pop(context, {
            'selectedValue':updatedString
          });
        }
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          itemBuilder: (BuildContext _context, int index) {
            print("list print${listValues[index].itemId}");
            print("selected print${widget.selectedValue}");

            return InkWell(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    PlatformText(
                      listValues[index].displayValue,
                    ),
                    Spacer(),
                    if(updatedString.contains(listValues[index].itemId))...[
                      Icon(Icons.check_box)
                    ] else ...[
                      Icon(Icons.check_box_outline_blank)
                    ]
                  ],
                ),
              ),
              /*onTap: () => Navigator.pop(context, {
                'ID': listValues[index].itemId,
                'TEXT': listValues[index].itemId
              }),*/
              onTap: (){
                setState(() {
                  List<String> stringList = updatedString.split(',');
                  if(stringList.contains(listValues[index].itemId)){
                    stringList.remove(listValues[index].itemId);
                  }
                  else {
                    stringList.add(listValues[index].itemId);
                  }
                  updatedString = stringList.join(',');
                  print("update");
                  print(updatedString);
                });
              }
            );
          },
          itemCount: listValues.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
