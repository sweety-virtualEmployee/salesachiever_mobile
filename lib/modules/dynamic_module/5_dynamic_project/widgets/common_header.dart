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
      body: entityType.toUpperCase()=="COMPANY"||entityType.toUpperCase() == "COMPANIES"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/company_icon.png',
        title: entity?['ACCTNAME']??LangUtil.getString('Entities', 'Account.Description.Plural'),
        projectID: "",
        status: entity?['TOWN']??"",
        siteTown: entity?['ADDR1']??"",
        backgroundColor: Color(0xff3cab4f),
      ):entityType.toUpperCase()=="QUOTATION"||entityType.toUpperCase()=="QUOTES"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/Quote.png',
        title: entity?['DESCRIPTION'],
        projectID: "",
        status: "",
        siteTown: entity?['QUOTE_CATEGORY']??"",
        backgroundColor: Color(0xff00aba9),
      ):entityType.toUpperCase()=="OPPORTUNITY"||entityType.toUpperCase()=="OPPORTUNITIES"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/opportunity_icon.png',
        title: entity?['CREATOR_ID'],
        projectID: "",
        status: entity?['DESCRIPTION'],
        siteTown: entity?['DEAL_TYPE_ID'],
        backgroundColor: Color(0xffA4C400),
      ): entityType.toUpperCase()=="CONTACT"||entityType.toUpperCase()=="CONTACTS"?DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/contact_icon.png',
        title: entity?['FIRSTNAME']??entity?['LASTNAME']??LangUtil.getString('Entities', 'Contact.Description.Plural'),
        projectID: "",
        status: entity?['CONTACT_STATUS']==null?"":entity?['CONTACT_STATUS'],
        siteTown: entity?['E_MAIL']??"",
        backgroundColor: Color(0xff4C99E0),
      ): entityType.toUpperCase()=="ACTION"||entityType.toUpperCase()=="ACTIONS"?DynamicPsaHeader(
        isVisible: true,
        icon:entity["CLASS"]=="A"?"assets/images/new_apmt_action.png":
        entity["CLASS"]=="T"? "assets/images/new_phone_action.png":
        entity["CLASS"]=="E"?"assets/images/new_email_action.png":
        entity["CLASS"]=="L"?"assets/images/new_doc_action.png":
        entity["CLASS"]=="G"?"assets/images/new_general_action.png":
            'assets/images/actions_icon.png',
        title: entity?['DESCRIPTION']?? LangUtil.getString('Entities', 'Action.Description.Plural'),
        projectID: "",
        status: "",
        siteTown: entity?['ACTION_TIME']??"",
        backgroundColor: Colors.white,
      ):DynamicPsaHeader(
        isVisible: true,
        icon: 'assets/images/projects_icon.png',
        title: entity?['PROJECT_TITLE'] ??
            LangUtil.getString('Entities', 'Project.Create.Text'),
        projectID: "",
        status: entity?['SELLINGSTATUS_ID']?? "",
        siteTown: entity?['OWNER_ID']?? "",
        backgroundColor: Color(0xffE67E6B),
      ),
    );
  }
}
