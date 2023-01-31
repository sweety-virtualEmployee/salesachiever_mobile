import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _selected = StorageUtil.getBool('classicSearch', defValue: true);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: 'User',
      body: PsaListItem(
        title: LangUtil.getString('iPadUserSetting', 'ClassicSearch.Label'),
        icon: 'assets/images/settings_icon.png',
        widget: PlatformSwitch(
          onChanged: (bool value) {
            setState(() {
              _selected = !_selected;
              StorageUtil.putBool('classicSearch', _selected);
            });
          },
          value: _selected,
        ),
      ),
    );
  }
}
