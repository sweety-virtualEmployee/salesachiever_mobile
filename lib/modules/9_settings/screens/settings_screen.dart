import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/1_login/screens/login_screen.dart';
import 'package:salesachiever_mobile/modules/9_settings/screens/about/about_screen.dart';
import 'package:salesachiever_mobile/modules/9_settings/screens/user/user_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_menu_item.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: 'Settings',
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            AuthUtil.hasAccess(50018)
                ? PsaMenuItem(
                    title: LangUtil.getString('EditFieldWindow',
                        'AddUserFieldPropertyCommand.FilterLabel'),
                    image: 'assets/images/settings_icon.png',
                    onTap: () => {
                      Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) => UserScreen(),
                        ),
                      )
                    },
                  )
                : Container(),
            PsaMenuItem(
              title: LangUtil.getString(
                  'Application', 'Settings.AboutButton.Text'),
              image: 'assets/images/about_icon.png',
              onTap: () => {
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => AboutScreen(),
                  ),
                )
              },
            ),
            PsaMenuItem(
              title: LangUtil.getString('Application', 'LogoutButton.Content'),
              image: 'assets/images/logout_icon.png',
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => LoginScreen(),
                  transitionDuration: Duration(seconds: 0),
                ),
                (route) => false,
              ),
              hasChild: false,
            )
          ],
        ).toList(),
      ),
    );
  }
}
