import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class CommonHeader extends StatelessWidget {
  final dynamic entity;
  final String entityType;
  const CommonHeader({Key? key,required this.entityType,required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: entityType=="COMPANY"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/company_icon.png',
        title: entity?['ACCTNAME'],
        projectID: entity?['ACCT_ID'],
        status: entity?['ACCT_TYPE_ID'],
        siteTown: entity?['ADDR1'],
        backgroundColor: Color(0xff3cab4f),
      ):entityType=="OPPORTUNITY"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/opportunity_icon.png',
        title: entity?['CREATOR_ID'],
        projectID: entity?['DEAL_ID'],
        status: entity?['DESCRIPTION'],
        siteTown: entity?['DEAL_TYPE_ID'],
        backgroundColor: Color(0xffA4C400),
      ): entityType=="CONTACT"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/contact_icon.png',
        title: entity?['FIRSTNAME'],
        projectID: entity?['CONT_ID'],
        status: entity?['CONTACT_STATUS']==null?"":entity?['CONTACT_STATUS'],
        siteTown: entity?['E_MAIL'],
        backgroundColor: Color(0xff4C99E0),
      ): entityType=="ACTION"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/actions_icon.png',
        title: entity?['DESCRIPTION'],
        projectID: entity?['ACCT_ID'],
        status: entity?['ACTION_ID'],
        siteTown: entity?['ACTION_TIME'],
        backgroundColor: Color(0xffae1a3e).withOpacity(0.1),
      ):DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/projects_icon.png',
        title: entity?['PROJECT_TITLE'] ??
            LangUtil.getString('Entities', 'Project.Create.Text'),
        projectID: entity?['PROJECT_ID'],
        status: entity?['SELLINGSTATUS_ID'],
        siteTown: entity?['OWNER_ID'],
        backgroundColor: Color(0xffE67E6B),
      ),
    );
  }
}
