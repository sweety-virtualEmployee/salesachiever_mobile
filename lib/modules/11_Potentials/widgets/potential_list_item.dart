import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/screens/potential_edit_screen.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class PotentialListItemWidget extends EntityListItemWidget {
  final String? dealId;

  const PotentialListItemWidget({
    Key? key,
    required entity,
    this.dealId,
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
  _PotentialListItemWidgetState createState() =>
      _PotentialListItemWidgetState();
}

class _PotentialListItemWidgetState
    extends EntityListItemWidgetState<PotentialListItemWidget> {
  String? _dealId = null;

  @override
  void initState() {
    _dealId = this.widget.dealId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: Text(
                      '${LangUtil.getString('PRODUCT_TREE', 'PRODUCT_CODE')} :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: Text(
                      '${LangUtil.getString('PRODUCT_TREE', 'DESCRIPTION')} :',
                      style: TextStyle(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
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
                      child: Text(
                        widget.entity['PRODUCT_CODE'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['DESCRIPTION'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: Text(
                      '${LangUtil.getString('DEAL_POTENTIAL', 'VALUE')} :',
                      style: TextStyle(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child: Text(
                      '${LangUtil.getString('DEAL_POTENTIAL', 'QUANTITY')} :',
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['VALUE'] != null
                            ? widget.entity['VALUE'].toString()
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Text(
                        widget.entity['QUANTITY'] != null
                            ? widget.entity['QUANTITY'].toString()
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ],
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
        if (widget.isSelectable) {
          Navigator.pop(context, {
            'ID': widget.entity['DEALPOT_ID'],
            'TEXT': widget.entity['DESCRIPTION']
          });
          return;
        }

        context.loaderOverlay.show();

        dynamic potential = widget.entity;
        // await PotentialService().getEntity(widget.entity['DEALPOT_ID']);

        context.loaderOverlay.hide();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PotentialEditScreen(
                potential: potential,
                dealId: _dealId,
                readonly: potential["DEALPOT_ID"] != null ? true: false,
              );
            },
          ),
        ).then((value) => widget.refresh());
      },
    );
  }
}
