import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_edit_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionListItemWidget extends EntityListItemWidget {
  const ActionListItemWidget({
    Key? key,
    required entity,
    required refresh,
  })  : assert(entity != null),
        super(key: key, entity: entity, refresh: refresh);

  @override
  _ActionListItemWidgetState createState() => _ActionListItemWidgetState();
}

class _ActionListItemWidgetState
    extends EntityListItemWidgetState<ActionListItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget getIcon(BuildContext context, String type) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        type == 'T'
            ? 'assets/images/action_telephone_icon.png'
            : type == 'E'
                ? 'assets/images/action_email_icon.png'
                : type == 'A'
                    ? 'assets/images/action_appointment_icon.png'
                    : type == 'L'
                        ? 'assets/images/action_document_icon.png'
                        : 'assets/images/action_general_icon.png',
        width: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      subtitle: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: getIcon(context, widget.entity['__ACTION_CLASS']),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlatformText(
                         widget.entity['DESCRIPTION'] ?? '',
                        //widget.entity['ACCTNAME'] ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      PlatformText(
                        '${widget.entity['FIRSTNAME'] ?? ''} ${widget.entity['SURNAME'] ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      widget.entity['COMPLETED'] != null &&
                              widget.entity['COMPLETED']
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: Colors.black54,
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                context.platformIcons.person,
                size: 16,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: PlatformText(
                  _getUserName(
                    widget.entity['ACTION_SAUSER'],
                  ),
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: PlatformText(
                  '${DateUtil.getFormattedDate(widget.entity['ACTION_DATE'] ?? '')}' +
                      ' ' +
                      '${DateUtil.getFormattedTime(widget.entity['ACTION_TIME'] ?? '')}' +
                      ' - ' +
                      '${DateUtil.getFormattedDate(widget.entity['ACTION_END_DATE'] ?? '')}' +
                      ' ' +
                      '${DateUtil.getFormattedTime(widget.entity['ACTION_END_TIME'] ?? '')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: PlatformText(
                   widget.entity['ACCTNAME'] ?? '',
                  //widget.entity['DESCRIPTION'] ?? '',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
        context.loaderOverlay.show();

        dynamic action =
            await ActionService().getEntity(widget.entity['ACTION_ID']);

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ActionEditScreen(
                action: action.data,
                readonly: true,
                popScreens: 1,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
  }

  _getUserName(String? userName) {
    if (userName == null || userName == '') return '';

    return LangUtil.getListValue('SAUSER.SAUSER_ID', userName);
  }
}
