
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomUrlLauncher{
  static callNumber(String numberOfUser,) async{
    String number = numberOfUser;//set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  static launchPhoneURL(String phoneNumber) async {
    String url = 'tel://' + phoneNumber.replaceAll(" ","");
    print("url ----"+url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    }
}