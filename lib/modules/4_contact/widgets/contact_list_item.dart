import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/CustomWidgets/CustomUrlLauncher.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class ContactListItemWidget extends EntityListItemWidget {
  const ContactListItemWidget({
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
  _ContactListItemWidgetState createState() => _ContactListItemWidgetState();
}

class _ContactListItemWidgetState
    extends EntityListItemWidgetState<ContactListItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Text(
          '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Text(
              widget.entity['ACCTNAME'] ?? '',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: const Icon(
                    Icons.email,
                    size: 12,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(widget.entity['E_MAIL'] ?? '',
                    style: TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
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
                    CustomUrlLauncher.launchPhoneURL(widget.entity['TEL_DIRECT'] ?? '');
                  },
                    child: Text(widget.entity['TEL_DIRECT'] ?? '',style: TextStyle(color: Colors.blue),)),
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
          Navigator.pop(context, {
            'ID': widget.entity['CONT_ID'],
            'TEXT':
                '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}',
            'DATA': widget.entity,
          });
          return;
        }

        try {
          context.loaderOverlay.show();

          dynamic contact =
              await ContactService().getEntity(widget.entity['CONT_ID']);

          dynamic company =
              await CompanyService().getEntity(contact.data['ACCT_ID']);

          contact.data['ACCTNAME'] = company.data['ACCTNAME'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ContactEditScreen(
                  contact: contact.data,
                  readonly: true,
                );
              },
            ),
          ).then((value) => widget.refresh());
        } on DioException catch (e) {
          ErrorUtil.showErrorMessage(context, e.message!);
        } catch (e) {
          ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
        } finally {
          context.loaderOverlay.hide();
        }
      },
    );
  }
}
