import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/related_entity_widget.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ContactViewRelatedRecords extends StatelessWidget {
   ContactViewRelatedRecords({
    Key? key,
    required entity,
    required contactId,
     required Function onChange,
   })  : _entity = entity,
        _contactId = contactId,
         _onChange = onChange,
        super(key: key);

  final dynamic _entity;
  final String _contactId;
   final Function _onChange;


  @override
  Widget build(BuildContext context) {
    print("let check entity data${_entity}");
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        Container(
          color: Colors.white,
          child: CupertinoFormRow(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Row(
                children: [
                  Text(
                    LangUtil.getString(
                      'ContactEditWindow',
                      'AccountTab.Header',
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 20,),
                  Expanded(child: Text(_entity["ACCTNAME"]!=null?_entity["ACCTNAME"]:"")),
                  Spacer(),
                  IconButton(onPressed: () async {
                      if (_entity['ACCT_ID'] != null) {
                        context.loaderOverlay.show();

                        var company =
                            await CompanyService().getEntity(_entity['ACCT_ID']);

                        await Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) => CompanyEditScreen(
                                company: company.data, readonly: false),
                          ),
                        );

                        context.loaderOverlay.hide();
                      } else {
                        var company = await Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (BuildContext context) => CompanyListScreen(
                              listName: 'acsrch_api',
                              isSelectable: true,
                            ),
                          ),
                        );
                        print(company);
                        if (company != null)
                          _onChange([
                            {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                            {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                          ]);
                      }
                    
                  }, icon: Icon(context.platformIcons.rightChevron),)

                ],
              ),
            ),
          ),
        ),
      /*  Container(
          color: Colors.white,
          child: CupertinoFormRow(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Row(
                children: [
                  Text(
                    LangUtil.getString(
                      'ContactEditWindow',
                      'AccountTab.Header',
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 20,),
                  Text(_entity["ACCTNAME"]!=null?_entity["ACCTNAME"]:""),
                  Spacer(),
                  IconButton(onPressed: () async {
                    if (_entity['ACCT_ID'] != null) {
                      context.loaderOverlay.show();

                      var company =
                      await CompanyService().getEntity(_entity['ACCT_ID']);

                      await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => CompanyEditScreen(
                              company: company.data, readonly: false),
                        ),
                      );

                      context.loaderOverlay.hide();
                    } else {
                      var company = await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => CompanyListScreen(
                            listName: 'acsrch_api',
                            isSelectable: true,
                          ),
                        ),
                      );
                      print(company);
                      if (company != null)
                        _onChange([
                          {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                          {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                        ]);
                    }

                  }, icon: Icon(context.platformIcons.rightChevron),)

                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: CupertinoFormRow(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Row(
                children: [
                  Text(
                    LangUtil.getString(
                      'ContactEditWindow',
                      'AccountTab.Header',
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 20,),
                  Text(_entity["ACCTNAME"]!=null?_entity["ACCTNAME"]:""),
                  Spacer(),
                  IconButton(onPressed: () async {
                    if (_entity['ACCT_ID'] != null) {
                      context.loaderOverlay.show();

                      var company =
                      await CompanyService().getEntity(_entity['ACCT_ID']);

                      await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => CompanyEditScreen(
                              company: company.data, readonly: false),
                        ),
                      );

                      context.loaderOverlay.hide();
                    } else {
                      var company = await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => CompanyListScreen(
                            listName: 'acsrch_api',
                            isSelectable: true,
                          ),
                        ),
                      );
                      print(company);
                      if (company != null)
                        _onChange([
                          {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                          {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                        ]);
                    }

                  }, icon: Icon(context.platformIcons.rightChevron),)

                ],
              ),
            ),
          ),
        ),
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['OPPORTUNTIY'].toString())))
        Container(
          color: Colors.white,
          child: CupertinoFormRow(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Row(
                children: [
                  Text(
                    LangUtil.getString(
                      'ContactEditWindow',
                      'AccountTab.Header',
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 20,),
                  Text(_entity["ACCTNAME"]!=null?_entity["ACCTNAME"]:""),
                  Spacer(),
                  IconButton(onPressed: () async {
                    if (_entity['ACCT_ID'] != null) {
                      context.loaderOverlay.show();

                      var company =
                      await CompanyService().getEntity(_entity['ACCT_ID']);

                      await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => CompanyEditScreen(
                              company: company.data, readonly: false),
                        ),
                      );

                      context.loaderOverlay.hide();
                    } else {
                      var company = await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => CompanyListScreen(
                            listName: 'acsrch_api',
                            isSelectable: true,
                          ),
                        ),
                      );
                      print(company);
                      if (company != null)
                        _onChange([
                          {'KEY': 'ACCT_ID', 'VALUE': company['ID']},
                          {'KEY': 'ACCTNAME', 'VALUE': company['TEXT']},
                        ]);
                    }

                  }, icon: Icon(context.platformIcons.rightChevron),)

                ],
              ),
            ),
          ),
        ),*/
        /*RelatedEntityWidget(
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
*/       /* if (AuthUtil.hasAccess(
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
          )*/
      ],
    );
  }
}
