
import 'dart:async';
import  'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:hive_flutter/hive_flutter.dart';
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
  await Hive.openBox<dynamic>('accessRights');
  await Hive.openBox<dynamic>('county');
  await Hive.openBox<dynamic>('userFieldVisibility');

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

  @override
  Widget build(BuildContext context) {
    const oneSec = Duration(seconds:120);
    Timer.periodic(oneSec, (Timer t) => checkTimeRemaining());
    return PlatformApp(
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
