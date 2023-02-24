import 'package:salesachiever_mobile/data/access_codes.dart';

var mainMenu = <dynamic>[
  {
    'key': 'HOME',
    'context': 'Application',
    'title': 'MainMenu.Home.Header',
    'subtitle': 'MainMenu.Home.SummaryDescription',
    'image': 'assets/images/home_icon.png',
    'hasChild': false,
  },
  {
    'key': 'LISTMANAGER',
    'context': 'Application',
    'title': 'MainMenu.ListManager.Header',
    'subtitle': 'MainMenu.ListManager.SummaryDescription',
    'image': 'assets/images/list_manager_icon.png',
    'hasChild': true,
  },
  {
    'key': 'COMPANY',
    'context': 'Entities',
    'title': 'Account.Description.Plural',
    'subtitle': 'Account.SummaryDescription',
    'image': 'assets/images/company_icon.png',
    'hasChild': true,
  },
  {
    'key': 'CONTACT',
    'context': 'Entities',
    'title': 'Contact.Description.Plural',
    'subtitle': 'Contact.SummaryDescription',
    'image': 'assets/images/contact_icon.png',
    'hasChild': true,
  },
  {
    'key': 'PROJECT',
    'context': 'Entities',
    'title': 'Project.Description.Plural',
    'subtitle': 'Project.SummaryDescription',
    'image': 'assets/images/projects_icon.png',
    'hasChild': true,
  },
  /*{
    'key': 'OPPORTUNITY',
    'context': 'Entities',
    'title': 'Opportunity.Description.Plural',
    'subtitle': 'Opportunity.SummaryDescription',
    'image': 'assets/images/opportunity_icon.png',
    'accessCode': ACCESS_CODES['OPPORTUNTIY'],
    'hasChild': true,
  }, */
  {
    'key': 'ACTION',
    'context': 'Entities',
    'title': 'Action.Description.Plural',
    'subtitle': 'Action.SummaryDescription',
    'image': 'assets/images/actions_icon.png',
    'hasChild': true,
  },
  {
    'key': 'CALENDAR',
    'context': 'Application',
    'title': 'MainMenu.Calendar.Header',
    'subtitle': 'Calendar.SummaryDescription',
    'image': 'assets/images/calendar_icon.png',
    'hasChild': true,
  },
   
  {
    'key': 'CREATERECORD',
    'context': 'Application',
    'title': 'MainMenu.CreateEntity.Header',
    'subtitle': 'MainMenu.CreateEntity.SummaryDescription',
    'image': 'assets/images/create_record_icon.png',
    'hasChild': true,
  },
  {
    'key': 'SETTINGS',
    'context': 'Application',
    'title': 'MainMenu.Settings.Header',
    'subtitle': 'MainMenu.Settings.SummaryDescription',
    'image': 'assets/images/settings_icon.png',
    'hasChild': true,
  },
  {
    'key': 'EMAILUS',
    'context': 'Application',
    'title': 'MainMenu.Contactus.Text',
    'subtitle': 'MainMenu.Contactus.Text',
    'image': 'assets/images/email_us_icon.png',
    'hasChild': true,
  }
];
