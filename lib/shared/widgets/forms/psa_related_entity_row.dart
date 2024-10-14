import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaRelatedEntityRow extends StatefulWidget {
  final String title;
  final dynamic entity;
  final Function onTap;
  final bool isRequired;
  final bool isVisible;

  const PsaRelatedEntityRow({
    Key? key,
    required this.title,
    required this.onTap,
    this.isRequired = false,
    this.entity,
    required this.isVisible,
  }) : super(key: key);

  @override
  _PsaRelatedEntityRowState createState() => _PsaRelatedEntityRowState();
}

class _PsaRelatedEntityRowState extends State<PsaRelatedEntityRow> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
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
                      color: widget.isRequired ? Colors.red : Colors.black),
                ),
              ),
              widget.isVisible?SizedBox(width: 10,):SizedBox(),
              widget.isVisible? Expanded(
                  child: CircleAvatar(radius:10,backgroundColor: widget.title == "Companies"
                      ? Colors.green
                      : widget.title == "Contact"
                      ? Colors.blue
                      : widget.title == "Project"
                      ? Colors.red
                      : widget.title == "Actions"
                      ? Colors.yellow
                      : widget.title == "Opportunities"
                      ? Colors.lightGreen
                      : Colors.transparent,
                   // child: Text("6",style: TextStyle(color: Colors.black,fontSize: 12),),
                  )
              )
                  :SizedBox(),
                Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: CupertinoTextField(
                    onTap: () => widget.onTap(),
                    controller: TextEditingController()
                      ..text = widget.entity?['TEXT'] ?? '',
                    readOnly: true,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    suffix: Icon(context.platformIcons.rightChevron),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
