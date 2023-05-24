import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:salesachiever_mobile/modules/2_list_manager/api/list_item_api.dart';
import 'package:salesachiever_mobile/utils/storage_util.dart';

class ListManagerService {
  final ListItemApi _listItemApi;

  ListManagerService() : _listItemApi = new ListItemApi();

  Future<List<dynamic>> getSubscribedLists(String category) async {
    var data = await _listItemApi.getSubscribedLists();
    print("data$data");
    List<dynamic> items = data['Items'];

    return items
        .where((element) => element['CATEGORY_ID'] == category)
        .toList();
  }

  Future<List<dynamic>> getDefaultLists() async {
    String user = StorageUtil.getString('loginName');

    var data = await _listItemApi.getDefaultLists(user);
    List<dynamic> items = data['Items'];
    log("project1 *********$items");

    await Hive.box<dynamic>('defaultLists').clear();
    await Hive.box<dynamic>('defaultLists').addAll(items);

    return items;
  }

  Future<void> setDefaultLists(String category, String listId) async {
    String user = StorageUtil.getString('loginName');
    await _listItemApi.setDefaultLists(user, category, listId);
  }
}
