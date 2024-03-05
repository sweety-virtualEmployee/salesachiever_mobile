import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/1_login/screens/login_screen.dart';
import 'navigation_Services.dart';

checkTimeRemaining() async {
  final  prefs = await SharedPreferences.getInstance();
  int? timestamp = prefs.getInt('myTimestampKey');
    if(timestamp!=null){
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      var currentTime = DateTime.now();
      var diff = currentTime.difference(dateTime).inMinutes;
      if(diff>=30){
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('myTimestampKey');
        Navigator.push(
          NavigationService.navigatorKey.currentContext!,
          platformPageRoute(
            context: NavigationService.navigatorKey.currentContext!,
            builder: (BuildContext context) => LoginScreen(),
          ),
        );

      }
    }
  }

