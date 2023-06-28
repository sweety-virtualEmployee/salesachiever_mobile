import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_list_screen.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/screens/list_view_screen.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/services/list_manager_service.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/quotation_list_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_menu_item.dart';

class ListManagerListScreen extends StatefulWidget {
  ListManagerListScreen(
      {Key? key, required this.title, required this.categoryCode})
      : super(key: key);

  final String title;
  final String categoryCode;

  @override
  _ListManagerListScreenState createState() => _ListManagerListScreenState();
}

class _ListManagerListScreenState extends State<ListManagerListScreen> {
  String searchText = '';
  List<dynamic>? lists;
  String? defaultListId;
  bool isLoading = false;
  String category = '';

  @override
  void initState() {
    switch (widget.categoryCode) {
      case "AC":
        category = 'ACCOUNT';
        break;
      case "CN":
        category = 'CONTACT';
        break;
      case "PJ":
        category = 'PROJECT';
        break;
      case "DI":
        category = 'ACTION';
        break;
      case "DE":
        category = 'DEAL';
        break;
      case "QU":
        category = 'QUOTATION';
        break;
      default:
        break;
    }
    _getSubscribedLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PsaScaffold(
        title: widget.title,
        body: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  onChanged: (String value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  placeholder: '',
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: PsaProgressIndicator())
                  : ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: _generateListItems(context),
                      ).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _getSubscribedLists() async {
    setState(() {
      isLoading = true;
    });

    var subscribedLists =
        await ListManagerService().getSubscribedLists(widget.categoryCode);
    var defaultLists = await ListManagerService().getDefaultLists();

    subscribedLists
        .sort((a, b) => a['DESCRIPTION'].compareTo(b['DESCRIPTION']));

    setState(() {
      defaultListId = defaultLists.firstWhere((e) => e['SECTION'] == category,
          orElse: () => null)?['VAR_VALUE'];
      lists = subscribedLists;

      isLoading = false;
    });
  }

  _generateListItems(BuildContext context) {
    var filteredList = lists
        ?.where((e) =>
            e['DESCRIPTION'].toLowerCase().contains(searchText.toLowerCase()))
        .map(
          (e) => Center(
            child: PsaMenuItem(
              title: e['DESCRIPTION'],
              onTap: () {
                _onTap(e);
              },
              hasChild: true,
              showFavoriteIcon: true,
              isFavourite: defaultListId == e['LIST_ID'],
              onTapFavourite: () {
                _onTapFavourite(e);
              },
            ),
          ),
        );

    return filteredList != null && filteredList.length > 0
        ? filteredList
        : [Text('')];
  }

  void _onTap(e) {
    Navigator.push(
      context,
      platformPageRoute(
          context: context,
          builder: (BuildContext context) {
            if (widget.categoryCode == 'DI')
              return ActionListScreen(listName: e['LIST_ID']);
            else if (widget.categoryCode == 'AC')
              return CompanyListScreen(listName: e['LIST_ID']);
            else if (widget.categoryCode == 'CN')
              return ContactListScreen(listName: e['LIST_ID']);
            else if (widget.categoryCode == 'PJ')
              return ProjectListScreen(listName: e['LIST_ID']);
            else if (widget.categoryCode == 'DE')
              return OpportunityListScreen(listName: e['LIST_ID']);
            else if (widget.categoryCode == 'QU')
              return QuotationListScreen(listName: e['LIST_ID']);
            return ListViewScreen(
              category: widget.categoryCode,
              title: widget.title,
            );
          }),
    );
  }

  void _onTapFavourite(e) async {
    context.loaderOverlay.show();

    setState(() {
      if (defaultListId == e['LIST_ID'])
        defaultListId = '';
      else
        defaultListId = e['LIST_ID'];
    });

    await ListManagerService().setDefaultLists(category, defaultListId!);

    context.loaderOverlay.hide();
  }
}
