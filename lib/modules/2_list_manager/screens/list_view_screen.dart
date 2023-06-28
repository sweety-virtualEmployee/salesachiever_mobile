import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/services/list_manager_service.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_list_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_list_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_list_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_list_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/error_view.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_menu_item.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({Key? key, required this.category, required this.title})
      : super(key: key);

  final String category;
  final String title;

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  String searchText = '';
  bool isLoading = false;

  List<Widget> _generateListItems(
      context, List<dynamic> subscribedLists, List<dynamic> defaultLists) {
    return subscribedLists
        .where((element) =>
            element['DESCRIPTION'].toLowerCase().contains(searchText))
        .map(
          (e) => Center(
            child: PsaMenuItem(
                title: e['DESCRIPTION'],
                onTap: () => Navigator.push(
                      context,
                      platformPageRoute(
                          context: context,
                          builder: (BuildContext context) {
                            if (widget.category == 'DI')
                              return ActionListScreen(listName: e['LIST_ID']);
                            if (widget.category == 'AC')
                              return CompanyListScreen(listName: e['LIST_ID']);
                            if (widget.category == 'CN')
                              return ContactListScreen(listName: e['LIST_ID']);
                            if (widget.category == 'PJ')
                              return ProjectListScreen(listName: e['LIST_ID']);
                            if (widget.category == 'QU')
                              return ProjectListScreen(listName: e['LIST_ID']);
                            else
                              return ListViewScreen(
                                category: widget.category,
                                title: widget.title,
                              );
                          }),
                    ),
                hasChild: true,
                showFavoriteIcon: true,
                isFavourite: defaultLists
                    .any((element) => element['VAR_VALUE'] == e['LIST_ID']),
                onTapFavourite: () {
                  setState(() {
                    isLoading = true;
                  });
                  String category = '';
                  if (widget.category == 'DI') category = 'ACTION';
                  if (widget.category == 'AC') category = 'ACCOUNT';
                  if (widget.category == 'CN') category = 'CONTACT';
                  if (widget.category == 'PJ') category = 'PROJECT';
                  if (widget.category == 'QU') category = 'QUOTATION';

                  ListManagerService()
                      .setDefaultLists(category, e['LIST_ID'])
                      .then((value) {
                    setState(() {
                      isLoading = true;
                    });
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            super.widget,
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  });
                }),
          ),
        )
        .toList();
  }

  Future getSubscribedLists(String category) async {
    List<dynamic> list =
        await ListManagerService().getSubscribedLists(category);
    list.sort((a, b) => a['DESCRIPTION'].compareTo(b['DESCRIPTION']));
    return list;
  }

  Future getDefaultLists(WidgetRef watch) async {
    var list = ListManagerService().getDefaultLists();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, WidgetRef watch, __) {
      return PsaScaffold(
        title: widget.title,
        body: FutureBuilder(
            future: Future.wait(
                [getSubscribedLists(widget.category), getDefaultLists(watch)]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasError) return ErrorView();

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: PsaProgressIndicator(),
                );
              }

              return Container(
                child: Column(
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
                      child: (snapshot.hasData)
                          ? ListView(
                              itemExtent: 50,
                              children: ListTile.divideTiles(
                                context: context,
                                tiles: _generateListItems(context,
                                    snapshot.data?[0], snapshot.data?[1]),
                              ).toList(),
                            )
                          : Center(
                              child: PsaProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }
}
