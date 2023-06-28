import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_edit_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_type_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/0_home/screens/home_screen.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/screens/list_category_screen.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/screens/list_view_screen.dart';
import 'package:salesachiever_mobile/modules/1_login/screens/login_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_quotation_add.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  '/company': (context) => CompanyListScreen(
        listName: 'acsrch_api',
      ),
  '/company/edit': (context) => CompanyEditScreen(
        company: {},
        readonly: false,
      ),
  '/contact': (context) => ContactListScreen(
        listName: 'cont_api',
      ),
  '/contact/edit': (context) => ContactEditScreen(
        contact: {},
        readonly: false,
      ),
  '/project': (context) => ProjectListScreen(
        listName: 'pjfilt_api',
      ),
  '/project/edit': (context) => ProjectEditScreen(
        project: {},
        readonly: false,
      ),
  '/action': (context) => ActionListScreen(
        listName: 'action_api',
      ),
  '/action/type': (context) => ActionTypeScreen(popScreens: 0),
  '/action/edit': (context) =>
      ActionEditScreen(action: {}, readonly: false, popScreens: 0),
  '/listManager': (context) => ListCategoryScreen(),
  '/listManager/details': (context) =>
      ListViewScreen(category: 'category', title: 'title'),
  '/oppertunity': (context) => OpportunityListScreen(
        listName: 'acsrch_api',
      ),
  '/oppertunity/edit': (context) => OpportunityEditScreen(
        deal: {},
        readonly: false,
      ),
  '/quotation/edit': (context) => DynamicQuotationAddScreen(
    readonly: false, quotation: {},
  ),
};
