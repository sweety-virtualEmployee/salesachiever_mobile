import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class OpportunityListItemWidget extends EntityListItemWidget {
  const OpportunityListItemWidget({
    Key? key,
    required entity,
    required refresh,
    bool isSelectable = false,
    required bool isEditable,
    this.onEdit,
    this.onDelete,
  })  : assert(entity != null),
        super(
          key: key,
          entity: entity,
          refresh: refresh,
          isSelectable: isSelectable,
          isEditable: isEditable,
        );

  final Function()? onEdit;
  final Function()? onDelete;

  @override
  _OpportunityListItemWidgetState createState() =>
      _OpportunityListItemWidgetState();
}

class _OpportunityListItemWidgetState
    extends EntityListItemWidgetState<OpportunityListItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dealDesc = widget.entity['DEAL_DESCRIPTION'] ?? '';

    return ListTile(
      dense: true,
      title: Text(
        dealDesc,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: SizedBox(
                      width: 90,
                      child: Text(
                        '${LangUtil.getString('DEAL', 'VALUE')} :',
                        style: TextStyle(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                    child: SizedBox(
                      width: 70,
                      child: Text(
                        '${LangUtil.getString('ENTITY_RTBF', 'STATUS_ID')} :',
                        style: TextStyle(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: SizedBox(
                        width: 90,
                        child: Text(
                          widget.entity['VALUE'] != null
                              ? widget.entity['VALUE'].toString()
                              : '0.00',
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: SizedBox(
                        width: 70,
                        child: Text(
                          widget.entity['SELLINGSTATUS_ID'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.entity['CONTACT'] == null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                      child: SizedBox(
                        width: 90,
                        child: Text(
                          '${LangUtil.getString('DEAL', 'START_DATE')} :',
                          style: TextStyle(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ),
                  if (widget.entity['CONTACT'] == null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                      child: SizedBox(
                        width: 70,
                        child: Text(
                          '${LangUtil.getString('DEAL', 'END_DATE')} :',
                          style: TextStyle(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ),
                  if (widget.entity['CONTACT'] != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                      child: Text(
                        '${LangUtil.getString('AccountEditWindow', 'ContactActionsMenuTextBlock.Text')} :',
                        style: TextStyle(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.entity['CONTACT'] == null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Text(
                          DateUtil.getFormattedDate(
                              widget.entity['START_DATE']),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    if (widget.entity['CONTACT'] == null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Text(
                          DateUtil.getFormattedDate(widget.entity['END_DATE']),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    if (widget.entity['CONTACT'] != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Text(
                          widget.entity['CONTACT'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.isEditable)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onEdit,
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: widget.onDelete,
                  child: Text('Delete'),
                )
              ],
            )
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
            'ID': widget.entity['DEAL_ID'],
            'TEXT': widget.entity['DESCRIPTION']
          });
          return;
        }
        context.loaderOverlay.show();

        dynamic deal =
            await OpportunityService().getEntity(widget.entity['DEAL_ID'].toString());

        if (deal.data['PROJECT_ID'] != null) {
          var project =
              await ProjectService().getEntity(deal.data['PROJECT_ID']);
          deal.data['PROJECT_TITLE'] = project.data['PROJECT_TITLE'];
        }

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OpportunityEditScreen(
                deal: deal.data,
                readonly: true,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
  }
}
