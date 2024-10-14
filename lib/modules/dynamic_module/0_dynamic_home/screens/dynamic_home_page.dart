import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/CustomWidgets/customactivefeature.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/screens/list_category_screen.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/services/list_manager_service.dart';
import 'package:salesachiever_mobile/modules/7_calendar/screens/calendar_screen.dart';
import 'package:salesachiever_mobile/modules/8_create_record/screens/create_record_screen.dart';
import 'package:salesachiever_mobile/modules/9_settings/screens/settings_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/0_dynamic_home/widgets/home_menu.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_branch_list_Section.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_list_screen.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:url_launcher/url_launcher.dart';

class DyanmicHomeScreen extends StatefulWidget {
  const DyanmicHomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DyanmicHomeScreen> {
  String _selectedItem = 'HOME';
  CustomActiveFeature feature = CustomActiveFeature();
  List<dynamic> defaultLists = [];

  @override
  void initState() {
    callApi();
    print("Check role");
    super.initState();
  }

  callApi() async{
    print(AuthUtil.hasAccess(
        int.parse(ACCESS_CODES['ROLE'].toString())));
    defaultLists = await ListManagerService().getDefaultLists();
  }

  Future<void> _navigate(String item) async {
    bool isContainActiveFeature = await feature.activeFeatures();
    try {
      print("item value$item");
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (BuildContext context) {
            if (item == 'LISTMANAGER') {
              return ListCategoryScreen();
            }
            if (item == 'COMPANY'){
              return DynamicProjectListScreen(
                listType:item,
                listName: defaultLists.firstWhere(
                        (element) => element['SECTION'] == 'ACCOUNT',
                    orElse: () => null)?['VAR_VALUE'] ??
                    'acsrch_api',
              );
            }
            if (item == 'CONTACT')
              return DynamicProjectListScreen(
                listType:item,
                listName: defaultLists.firstWhere(
                        (element) => element['SECTION'] == 'CONTACT',
                        orElse: () => null)?['VAR_VALUE'] ??
                    'cont_api',
              );
             if (isContainActiveFeature && item == 'PROJECT') {
              return DynamicProjectListScreen(
                listType:item,
                listName: defaultLists.firstWhere(
                        (element) => element['SECTION'] == 'PROJECT',
                        orElse: () => null)?['VAR_VALUE'] ??
                    'pjfilt_api',
              );
            }
            if (item == 'OPPORTUNITY'|| item =='Opportunities')
              return DynamicProjectListScreen(
              listType: item,
                listName: defaultLists.firstWhere(
                        (element) => element['SECTION'] == 'DEAL',
                        orElse: () => null)?['VAR_VALUE'] ??
                    'ALLDE', //acsrch_api
              );
            if (item == 'QUOTATION') {
              return DynamicProjectListScreen(
                listType: item,
                listName: defaultLists.firstWhere(
                        (element) => element['SECTION'] == 'QUOTATION',
                    orElse: () => null)?['VAR_VALUE'] ??
                    'quote_api',
              );
               }
            if (item == 'ACTION')
              return DynamicProjectListScreen(
                listType:item,
                listName: defaultLists.firstWhere(
                        (element) => element['SECTION'] == 'ACTION',
                        orElse: () => null)?['VAR_VALUE'] ??
                    'action_api',
              );
            if (item == 'CALENDAR') return CalendarScreen();
            if (item == 'CREATERECORD') return CreateRecordScreen();
            if (item == 'SETTINGS') return SettingsScreen();
            if(item =='API')  return DynamicBranchListSection();

            return DyanmicHomeScreen();
          },
        ),
      );
    } catch (e) {
      context.loaderOverlay.hide();
    }
  }

  void _launchURL() async {
    final String url = await LookupService().getContactusEmail();
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString('Application', 'Application.Title'),
      showHome: false,
      showBack: false,
      body: DynamicHomeMenu(
        itemSelectedCallback: (item) async {
          print("vadkjwhsufcikdehv$item");
          setState(() {
            _selectedItem = item;
          });
          print("item shfv$item");

          if (item == 'HOME') {
            print("api is called");
          } else if (item == 'EMAILUS') {
            // _launchURL();
          } else {
            _navigate(item);
          }
        },
        selectedItem: _selectedItem,
      ),
    );
  }
}
