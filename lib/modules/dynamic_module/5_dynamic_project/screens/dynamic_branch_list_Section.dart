import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_menu_item.dart';

class DynamicBranchListSection extends StatefulWidget {
  @override
  State<DynamicBranchListSection> createState() =>
      _DynamicBranchListSectionState();
}

class _DynamicBranchListSectionState extends State<DynamicBranchListSection> {
  DynamicProjectService service = DynamicProjectService();
  bool isLoading = false;
  String? defaultListId;
  List<dynamic>? lists;


  @override
  void initState() {
    getBranchLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: 'Branches',
      body: Column(
        children: [
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
    );
  }

  getBranchLists() async {
    setState(() {
      isLoading = true;
    });

    var userBranchList = await service.getUserBranch();
    var defaultBranchLists = await service.getDefaultUserBranch();


    setState(() {
      defaultListId = defaultBranchLists['VAR_VALUE'];
      lists = userBranchList;

      isLoading = false;
    });
  }

  _generateListItems(BuildContext context) {
    var filteredList = lists?.map(
          (e) => Center(
        child: PsaMenuItem(
          title: e['BRANCH_NAME'],
          onTap: () {
          },
          hasChild: true,
          showFavoriteIcon: true,
          isFavourite: defaultListId == e['BRANCH_ID'],
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


  void _onTapFavourite(e) async {
    context.loaderOverlay.show();

    setState(() {
      if (defaultListId == e['BRANCH_ID'])
        defaultListId = '';
      else
        defaultListId = e['BRANCH_ID'];
    });

    print("default list id $defaultListId");

    await service.setDefaultLists(defaultListId!);

    context.loaderOverlay.hide();
  }
}
