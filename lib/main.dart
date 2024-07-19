/**/
import 'dart:async';
import  'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/6_action/provider/action_stormsaver_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/provider/dynamic_tab_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/provider/dynamic_staffzone_provider.dart';
import 'package:salesachiever_mobile/shared/models/locale.dart';
import 'package:salesachiever_mobile/utils/local_session_timeout.dart';
import 'package:salesachiever_mobile/utils/navigation_Services.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

import 'routes/routes.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();

  await Hive.initFlutter();
  Hive.registerAdapter(LocaleAdapter());
  await Hive.openBox<Locale>('locales');
  await Hive.openBox<dynamic>('features');
  await Hive.openBox<dynamic>('homeModule');
  await Hive.openBox<dynamic>('projectForm');
  await Hive.openBox<dynamic>('defaultLists');
  await Hive.openBox<dynamic>('dataDictionary');
  await Hive.openBox<dynamic>('dataDictionaryLookups');
  await Hive.openBox<dynamic>('activeFeatureEntity');
  await Hive.openBox<dynamic>('userFieldProperties');
  await Hive.openBox<dynamic>('activeFields_account');
  await Hive.openBox<dynamic>('activeFields_contact');
  await Hive.openBox<dynamic>('activeFields_project');
  await Hive.openBox<dynamic>('activeFields_quotation');
  await Hive.openBox<dynamic>('activeFields_rate_agreement');
  await Hive.openBox<dynamic>('activeFields_job_order');
  await Hive.openBox<dynamic>('activeFields_isv');
  await Hive.openBox<dynamic>('activeFields_initial_order');
  await Hive.openBox<dynamic>('activeFields_accident_record');
  await Hive.openBox<dynamic>('activeFields_action');
  await Hive.openBox<dynamic>('activeFields_deal');
  await Hive.openBox<dynamic>('activeFields_deal_potential');
  await Hive.openBox<dynamic>('userFields_account');
  await Hive.openBox<dynamic>('userFields_contact');
  await Hive.openBox<dynamic>('userFields_project');
  await Hive.openBox<dynamic>('userFields_action');
  await Hive.openBox<dynamic>('userFields_deal');
  await Hive.openBox<dynamic>('userFields_quotation');
  await Hive.openBox<dynamic>('userFields_deal_potential');
  await Hive.openBox<dynamic>('userFields_rate_agreement');
  await Hive.openBox<dynamic>('userFields_job_order');
  await Hive.openBox<dynamic>('userFields_isv');
  await Hive.openBox<dynamic>('userFields_initial_order');
  await Hive.openBox<dynamic>('userFields_accident_record');
  await Hive.openBox<dynamic>('accessRights');
  await Hive.openBox<dynamic>('county');
  await Hive.openBox<dynamic>('userFieldVisibility');
  await Hive.openBox<dynamic>('currencyValue');
  await Hive.openBox<dynamic>('dynamicFormFields_P001');
  await Hive.openBox<dynamic>('dynamicFormFields_C001');
  await Hive.openBox<dynamic>('dynamicFormFields_A001');
  await Hive.openBox<dynamic>('dynamicFormFields_Q001');
  await Hive.openBox<dynamic>('dynamicFormFields_O001');
  await Hive.openBox<dynamic>('dynamicFormFields_D001');

  HttpOverrides.global = new MyHttpOverrides();

  runApp(ProviderScope(child: AppRoot()));
}

class AppRoot extends StatefulWidget {
  @override
  AppRootState createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    const oneSec = Duration(seconds:120);
    Timer.periodic(oneSec, (Timer t) => checkTimeRemaining());
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (context) => DynamicTabProvide()),
       ChangeNotifierProvider(create: (context) => DynamicStaffZoneProvider()),
       ChangeNotifierProvider(create: (context) => ActionSiteTierValueProvider()),
      ],
      child: PlatformApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      routes: routes,
      cupertino: (_, __) => CupertinoAppData(
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
