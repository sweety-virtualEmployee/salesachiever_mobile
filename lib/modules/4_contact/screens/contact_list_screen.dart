import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/widgets/contact_list_item.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ContactListScreen extends StatelessWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String listName;
  final bool isSelectable;

  const ContactListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.listName,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString('Entities', 'Contact.Description'),
      body: PsaEntityListView(
        service: ContactService(listName: listName),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return ContactListItemWidget(
              entity: entity, refresh: refresh, isSelectable: isSelectable);
        },
        type: 'CONTACT',
        list: listName,
        sortBy: sortBy,
        filterBy: filterBy,
      ),
    );
  }
}
