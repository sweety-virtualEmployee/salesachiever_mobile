import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicProjectViewRelatedRecords extends StatelessWidget {
  const DynamicProjectViewRelatedRecords({
    Key? key,
    required entity,
    required projectId,
  })  : _entity = entity,
        _projectId = projectId,
        super(key: key);

  final dynamic _entity;
  final String _projectId;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'project',
          title: LangUtil.getString(
            'ProjectEditWindow',
            'AccountsTab.Header',
          ),
          id: _projectId,
          relatedEntityType: 'companies',
          isEditable: true,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'project',
          title: LangUtil.getString(
            'ProjectEditWindow',
            'ActionTab.Header',
          ),
          id: _projectId,
          relatedEntityType: 'actions',
          isEditable: false,
        ),
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          RelatedEntityWidget(
            entity: _entity,
            entityType: 'project',
            title: LangUtil.getString(
              'ProjectEditWindow',
              'OpportunitiesTab.Header',
            ),
            id: _projectId,
            relatedEntityType: 'OpportunityLinks?pageSize=1000&pageNumber=1',
            isEditable: false,
          )
      ],
    );
  }
}
