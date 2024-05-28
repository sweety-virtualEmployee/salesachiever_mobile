import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/dynamic_Staffzone_list_Screen.dart';


class PsaStaffZoneRelatedValue extends StatefulWidget {
  final String title;
  final String tabTitle;
  final String relatedEntityType;
  final String staffZoneEntity;
  final String tableName;
  final String id;
  final bool isRequired;
  final Function onChange;
  final dynamic entity;




  PsaStaffZoneRelatedValue({
    Key? key,
    required this.title,
    required this.isRequired,
    required this.entity,
    required this.staffZoneEntity,
    required this.relatedEntityType,
    required this.tableName,
    required this.id,
    required this.tabTitle,
    required this.onChange,
  }) : super(key: key);
  @override
  State<PsaStaffZoneRelatedValue> createState() => _PsaStaffZoneRelatedValueState();
}

class _PsaStaffZoneRelatedValueState extends State<PsaStaffZoneRelatedValue> {
  String selectedRateAgreement = "";

  @override
  void initState() {
    selectedRateAgreement = widget.entity["RATE_AGREEMENT_DESC"] ?? "";
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
                widget.title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color:
                    widget.isRequired ? Colors.red : Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: CupertinoTextField(
                  onTap: () async {
                    var rateAgreement = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DynamicStaffZoneListScreen(
                              relatedEntityType: widget.relatedEntityType,
                              staffZoneType:widget.staffZoneEntity,
                              title:  widget.tabTitle,
                              tableName: widget.tableName,
                              id: widget.id,
                              isSelectable: true,
                            ),
                      ),
                    );
                    print("rate agrenkd nbkljbv");
                    print(rateAgreement);
                    if (rateAgreement != null) {
                      widget.onChange([
                        {
                          'KEY': 'RATE_AGREEMENT_ID',
                          'VALUE': rateAgreement['ID']
                        },
                        {'KEY': 'RATE_AGREEMENT_DESCRIPTION', 'VALUE': rateAgreement['TEXT']},
                      ]);
                    }
                    setState(() {
                      selectedRateAgreement = rateAgreement['TEXT'];
                    });
                  },
                  controller: TextEditingController()
                    ..text = selectedRateAgreement,
                  readOnly: true,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  style: TextStyle(
                      color: Colors.grey.shade700, fontSize: 15),
                  suffix: Icon(
                    context.platformIcons.rightChevron,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
