import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class CompanyViewRelatedRecords extends StatelessWidget {
  const CompanyViewRelatedRecords({
    Key? key,
    required entity,
    required companyId,
  })  : _entity = entity,
        _companyId = companyId,
        super(key: key);

  final dynamic _entity;
  final String _companyId;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'company',
          title: LangUtil.getString(
            'AccountEditWindow',
            'ContactsTab.Header',
          ),
          id: _companyId,
          relatedEntityType: 'contacts',
          isEditable: false,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'company',
          title: LangUtil.getString(
            'AccountEditWindow',
            'ProjectsTab.Header',
          ),
          id: _companyId,
          relatedEntityType: 'projects',
          isEditable: true,
        ),
        RelatedEntityWidget(
          entity: _entity,
          entityType: 'company',
          title: LangUtil.getString(
            'AccountEditWindow',
            'ActionTab.Header',
          ),
          id: _companyId,
          relatedEntityType: 'actions',
          isEditable: false,
        ),
        /*if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
          RelatedEntityWidget(
            entity: _entity,
            entityType: 'company',
            title: LangUtil.getString(
              'AccountEditWindow',
              'OpportunityActionsMenuTextBlock.Text',
            ),
            id: _companyId,
            relatedEntityType: 'OpportunityLinks?pageSize=1000&pageNumber=1',
            isEditable: true,
          ),*/
      ],
    );
  }
}
