
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PsaButtonRow extends StatefulWidget {
  final String title;
  final Function? onTap;
  final Widget? icon;
  final Color? color;
  final bool isVisible;

  const PsaButtonRow(
      {Key? key,
      required this.title,
      this.onTap,
      this.icon,
      this.color,
      required this.isVisible})
      : super(key: key);

  @override
  State<PsaButtonRow> createState() => _PsaButtonRowState();
}

class _PsaButtonRowState extends State<PsaButtonRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) widget.onTap!();
      },
      child: Container(
        color: Colors.white,
        child: CupertinoFormRow(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.30,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: widget.color),
                ),
              ),
              widget.isVisible
                  ? SizedBox(
                      width: 150,
                    )
                  : SizedBox(),
              widget.isVisible
                  ? Expanded(
                      child: CircleAvatar(
                      radius: 10,
                      backgroundColor: widget.title == "Companies"||widget.title == "Company"
                          ? Colors.green
                          : widget.title == "Contacts"
                              ? Colors.blue
                              : widget.title == "Projects"
                                  ? Colors.red
                                  : widget.title == "Actions"
                                      ? Colors.yellow
                                      : widget.title == "Opportunities"||widget.title == "Opportunity"
                                          ? Colors.lightGreen
                                          : Colors.grey.shade700,
                      //backgroundColor:Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                     /* child: Text(
                        "6",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),*/
                    ))
                  : SizedBox(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: CupertinoTextField(
                    onTap: () {
                      if (widget.onTap != null) widget.onTap!();
                    },
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    readOnly: true,
                    suffix: widget .icon,
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
