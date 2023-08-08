import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_quotation_add.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class QuotationListItemWidget extends EntityListItemWidget {
  const QuotationListItemWidget({
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
  _QuotationListItemWidgetState createState() =>
      _QuotationListItemWidgetState();
}

class _QuotationListItemWidgetState
    extends EntityListItemWidgetState<QuotationListItemWidget> {
  @override
  void initState() {
    print("entity check${widget.entity}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dealDesc = widget.entity['QUOTATION_DESCRIPTION'] ?? '';

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlatformText(
                '${widget.entity['QUOTATION_REPRESENTATIVE'] ?? ''}',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              PlatformText(
                widget.entity['ACCOUNT_ACCTNAME'] ?? '',
                //widget.entity['ACCTNAME'] ?? '',
                style: TextStyle(color: Colors.black, fontSize: 12),
                overflow: TextOverflow.fade,
                softWrap: false,
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
            'ID': widget.entity['QUOTATION_QUOTE_ID'],
            'TEXT': widget.entity['QUOTATION_DESCRIPTION']
          });
          return;
        }
        context.loaderOverlay.show();

        dynamic quotation =
        await DynamicProjectService()
            .getEntityById("QUOTATION",
            widget.entity['QUOTATION_QUOTE_ID']);

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DynamicQuotationAddScreen(
                quotation: quotation.data,
                readonly: true,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
  }
}
