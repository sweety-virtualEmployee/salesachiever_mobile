import 'package:url_launcher/url_launcher.dart';

class CustomUrlLauncher{

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