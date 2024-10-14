import 'package:flutter/cupertino.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class PotentialViewRelatedRecords extends StatelessWidget {
  const PotentialViewRelatedRecords({
    Key? key,
    required entity,
    required dealId,
  })  : _entity = entity,
        _dealId = dealId,
        super(key: key);

  final dynamic _entity;
  final String _dealId;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'deal',
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'ContactsTab.Header',
          ),
          id: _dealId,
          relatedEntityType: 'contacts',
          isEditable: false,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'deal',
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'ProjectsTab.Header',
          ),
          id: _dealId,
          relatedEntityType: 'projects',
          isEditable: true,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'deal',
          title: LangUtil.getString(
            'OpportunityEditWindow',
            'ActionTab.Header',
          ),
          id: _dealId,
          relatedEntityType: 'actions',
          isEditable: false,
        ),
      ],
    );
  }
}
