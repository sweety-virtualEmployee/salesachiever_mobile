import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class CreateRecordScreen extends StatelessWidget {
  const CreateRecordScreen({Key? key}) : super(key: key);

  List<Widget> _generateListItems(BuildContext context) {
    List<String> menuItems = [
      'Account.Description',
      'Project.Description',
      'Action.Description',
    ];
    if (AuthUtil.hasAccess(int.parse(ACCESS_CODES['QUOTATION'].toString()))) {
      menuItems.add('Quotation.Description');
    }

    if (AuthUtil.hasAccess(int.parse(ACCESS_CODES['OPPORTUNTIY'].toString()))) {
      menuItems.add('Opportunity.Description');
    }

    return menuItems
        .map(
          (e) => InkWell(
            child: PsaListItem(
              title: LangUtil.getString('Entities', e),
              widget: Icon(
                context.platformIcons.add,
                color: Colors.blue,
              ),
            ),
            onTap: () {
              _onTap(context, e);
            },
          ),
        )
        .toList();
  }

  void _onTap(BuildContext context, String type) {
    switch (type) {
      case 'Account.Description':
        Navigator.pushNamed(context, '/company/edit');
        break;
      case 'Contact.Description':
        Navigator.pushNamed(context, '/contact/edit');
        break;
      case 'Project.Description':
        Navigator.pushNamed(context, '/project/edit');
        break;
      case 'Action.Description':
        Navigator.pushNamed(context, '/action/type');
        break;
      case 'Quotation.Description':
        Navigator.pushNamed(context, '/quotation/edit');
        break;
      case 'Opportunity.Description':
        Navigator.pushNamed(context, '/oppertunity/edit');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString(
          'Application', 'MainMenu.CreateEntity.SummaryDescription'),
      body: Column(
        children: [
          PsaHeader(
            isVisible: false,
            icon: 'assets/images/create_record_icon.png',
            title: LangUtil.getString(
                'Application', 'MainMenu.CreateEntity.SummaryDescription'),
          ),
          Expanded(
            child: ListView(
              itemExtent: 50,
              children: ListTile.divideTiles(
                context: context,
                tiles: _generateListItems(context),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
