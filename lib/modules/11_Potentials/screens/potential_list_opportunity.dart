import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/screens/product_list_screen.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/services/potential_service.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/widgets/potential_list_item.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view_no_filter.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class PotentialListOpportunity extends StatelessWidget {
  final String dealId;
  final bool isSelectable;

  const PotentialListOpportunity({
    Key? key,
    required this.dealId,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: '',
      body: PsaEntityListViewNofilter(
        service: PotentialService(listName: dealId),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return PotentialListItemWidget(
              entity: entity, refresh: refresh, isSelectable: isSelectable);
        },
        type: 'DEAL_POTENTIAL',
        id: dealId
      ),
      action: PsaAddButton(
        onTap: () => Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => ProductListScreen(
              dealId: dealId,
            ),
          ),
        ),
      ),
    );
  }
}
