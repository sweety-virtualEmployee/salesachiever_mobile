import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ContactViewRelatedRecords extends StatelessWidget {
  const ContactViewRelatedRecords({
    Key? key,
    required entity,
    required contactId,
  })  : _entity = entity,
        _contactId = contactId,
        super(key: key);

  final dynamic _entity;
  final String _contactId;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'contact',
          title: LangUtil.getString(
            'ContactEditWindow',
            'AccountTab.Header',
          ),
          id: _contactId,
          relatedEntityType: 'company',
          isEditable: false,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'contact',
          title: LangUtil.getString(
            'ContactEditWindow',
            'ProjectsTab.Header',
          ),
          id: _contactId,
          relatedEntityType: 'projects',
          isEditable: false,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'contact',
          title: LangUtil.getString(
            'ContactEditWindow',
            'ActionTab.Header',
          ),
          id: _contactId,
          relatedEntityType: 'actions',
          isEditable: false,
        ),
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          RelatedEntityWidget(
            entity: _entity,
            entityType: 'contact',
            title: LangUtil.getString(
              'ContactEditWindow',
              'OpportunityActionsMenuTextBlock.Text',
            ),
            id: _contactId,
            relatedEntityType: 'OpportunityLinks?pageSize=1000&pageNumber=1',
            isEditable: true,
          )
      ],
    );
  }
}
