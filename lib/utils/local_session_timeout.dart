import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/1_login/screens/login_screen.dart';
import 'navigation_Services.dart';

checkTimeRemaining() async {
  final  prefs = await SharedPreferences.getInstance();
  int? timestamp = prefs.getInt('myTimestampKey');
    print('check timestamp${timestamp}');
    if(timestamp!=null){
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      print("timestamp date${dateTime}");
      var currentTime = DateTime.now();
      var diff = currentTime.difference(dateTime).inMinutes;
      print("difference${diff}");
      if(diff>=10){
        print("move to login screen");
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
      print("difference${currentTime}");
      print("difference${dateTime}");
    }
  }

