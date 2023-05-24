import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/CustomWidgets/CustomUrlLauncher.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyListItemWidget extends EntityListItemWidget {
  const CompanyListItemWidget({
    Key? key,
    required entity,
    required refresh,
    bool isSelectable = false,
  })  : assert(entity != null),
        super(
          key: key,
          entity: entity,
          refresh: refresh,
          isSelectable: isSelectable,
        );

  @override
  _CompanyListItemWidgetState createState() => _CompanyListItemWidgetState();
}

class _CompanyListItemWidgetState
    extends EntityListItemWidgetState<CompanyListItemWidget> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    String companyName = widget.entity['ACCTNAME'] ?? '';
    String address =
        '${widget.entity['ADDR1'] ?? ''}, ${widget.entity['ADDR2'] ?? ''}, ${widget.entity['ADDR3'] ?? ''}';
    String email = widget.entity['EMAILORWEB'] ?? '';
    String telephone = widget.entity['TEL'] ?? '';

    return ListTile(
      dense: true,
      title: Text(
        companyName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: Text(
              address,
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: const Icon(
                    Icons.public,
                    size: 12,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(email,style: TextStyle(color:Colors.blueAccent,),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: const Icon(
                    Icons.phone,
                    size: 12,
                    color: Colors.blueAccent,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    CustomUrlLauncher.launchPhoneURL(telephone);
                    //CustomUrlLauncher.callNumber(telephone);
                  },
                    child: Text(telephone,style: TextStyle(color:Colors.blueAccent,),)),
              ],
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(context.platformIcons.rightChevron),
        ],
      ),
      onTap: () async {
        if (widget.isSelectable) {
          print("yes");
          Navigator.pop(context, {
            'ID': widget.entity['ACCT_ID'],
            'TEXT': widget.entity['ACCTNAME']
          });
          return;
        }

        context.loaderOverlay.show();

        dynamic company =
            await CompanyService().getEntity(widget.entity['ACCT_ID']);

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CompanyEditScreen(
                company: company.data,
                readonly: true,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
  }
}
