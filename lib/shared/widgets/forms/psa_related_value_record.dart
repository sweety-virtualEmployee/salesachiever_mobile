import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../modules/3_company/screens/company_edit_screen.dart';
import '../../../modules/3_company/services/company_service.dart';

class PsaRelatedValueRow extends StatefulWidget {
  final String title;
   String value;
  final String type;
  final dynamic entity;
  final Function onTap;
  final bool isRequired;
  final bool isVisible;

   PsaRelatedValueRow({
    Key? key,
    required this.title,
    required this.onTap,
    required this.value,
    required this.type,
    this.isRequired = false,
    this.entity,
    required this.isVisible,
  }) : super(key: key);

  @override
  _PsaRelatedValueRowState createState() => _PsaRelatedValueRowState();
}

class _PsaRelatedValueRowState extends State<PsaRelatedValueRow> {

   var entity;
  @override
  void initState() {
    callApi(widget.type);
    super.initState();
  }

  callApi(String type) async {
    if(type=="ACCT_ID") {
      context.loaderOverlay.show();
      var company = await CompanyService().getEntity(widget.value);
      print(company);
      setState(() {
        entity = company.data;
      });
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(widget.type=="ACCT_ID"){

          await Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (BuildContext context) => CompanyEditScreen(
                  company: entity.data, readonly: false),
            ),
          );

        }
      },
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: CupertinoTextField(
                    onTap: () => widget.onTap(),
                    controller: TextEditingController()
                      ..text =widget.value,
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
