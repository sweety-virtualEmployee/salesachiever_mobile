import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';

class ListItemApi {
  Future<dynamic> getSubscribedLists() async {
    Response response =
        await Api().get('/User/User.SubscribedLists?searchText=%25');
    return response.data;
  }

  Future<dynamic> getDefaultLists(String user) async {
    Response response = await Api().get('/User/User.DefaultLists?userid=$user');
    print("default list${response.data}");
    return response.data;
  }

  Future<void> setDefaultLists(
      String user, String category, String listId) async {
    if (listId.isEmpty)
      await Api().post(
        '/User/User.SetDefaultList?userid=$user&entity=$category',
        {},
      );
    else
      await Api().post(
        '/User/User.SetDefaultList?userid=$user&entity=$category&id=$listId',
        {},
      );
  }
}
