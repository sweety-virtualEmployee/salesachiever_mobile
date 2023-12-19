import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_related_entity_row.dart';

class AssociatedEntityWidget extends StatelessWidget {
  const AssociatedEntityWidget({
    Key? key,
    required this.title,
    required this.entity,
    this.isRequired = false,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final dynamic entity;
  final bool isRequired;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    print("entity values$entity");
    return PsaRelatedEntityRow(
      isVisible: false,
      isRequired: (isRequired && entity?['ID'] == null),
      title: title,
      entity: entity,
      onTap: () async {
        await onTap();
      },
    );
  }
}
