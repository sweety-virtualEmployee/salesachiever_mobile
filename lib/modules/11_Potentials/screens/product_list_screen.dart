import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/services/potential_service.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/widgets/potential_list_item.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ProductListScreen extends StatelessWidget {
  final String dealId;
  final bool isSelectable;

  const ProductListScreen({
    Key? key,
    required this.dealId,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString('ProductSearchWindow', 'Title'),
      body: PsaEntityListView(
        service: PotentialService(listName: dealId),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return PotentialListItemWidget(
              entity: entity, dealId: dealId, refresh: refresh, isSelectable: isSelectable);
        },
        type: 'DEAL_POTENTIAL',
        list: dealId,
        hideSortFilter: true,
      ),
    );
  }
}
