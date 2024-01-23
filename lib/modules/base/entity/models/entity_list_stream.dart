import 'dart:async';
import 'dart:convert';

import 'package:salesachiever_mobile/modules/base/entity/models/entity.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';

class EntityListStream {
  int _pageNumber = 0;
  int _pageSize = 15;
  bool hasMore = false;
  late EntityService entityService;

  late Stream<List<dynamic>> stream;
  StreamController<List<dynamic>> _controller =
      StreamController<List<dynamic>>.broadcast();

  bool isLoading = false;
  List<dynamic> _data = [];

  EntityListStream(
    EntityService entityService,
    String searchText, [
    List<dynamic>? sortBy,
    List<dynamic>? filterBy,
  ]) {
    this.entityService = entityService;
    stream = _controller.stream.map((List<dynamic> entityList) {
      return entityList.map((dynamic entity) {
        return entity;
      }).toList();
    });

    refresh(searchText, sortBy, filterBy);
  }

  Future<void> refresh(
    String searchText,
    List<dynamic>? sortBy,
    List<dynamic>? filterBy,
  ) {
    _pageNumber = 0;
    return loadMore(
        clearCachedData: true,
        searchText: searchText,
        sortBy: sortBy,
        filterBy: filterBy);
  }

  void filter(String text) {
    List<dynamic> _filteredList = _data
        .where((element) =>
            jsonEncode(element).toLowerCase().contains(text.toLowerCase()))
        .toList();
    _controller.add(_filteredList);
  }

  Future<void> search(String text) {
    _pageNumber = 0;
    return loadMore(clearCachedData: true, searchText: text);
  }

  Future<void> searchFromCache(String text) {
    _pageNumber = 0;
    return loadMore(clearCachedData: false, searchText: text);
  }

  Future<void> loadMore({
    bool clearCachedData = false,
    String searchText = '%25',
    List<dynamic>? sortBy,
    List<dynamic>? filterBy,
  }) {
    if (clearCachedData) {
      _data = [];
      hasMore = true;
    }

    if (isLoading || !hasMore) {
      return Future.value();
    }

    isLoading = true;
    searchText = searchText != '' ? searchText : '%25';

    return entityService
        .searchEntity(
            searchText: searchText,
            pageSize: _pageSize,
            pageNumber: _pageNumber + 1,
            sortBy: sortBy,
            filterBy: filterBy)
        . then(
      (response) {
        print("response $response");
        EntityList entityList = EntityList.fromJson(response.data);
        isLoading = false;
        _data.addAll(entityList.data!);
        hasMore = !entityList.isLastPage;
        _pageNumber = entityList.pageNumber;
        _controller.add(_data);
        print("dat check $_data");
      },
    ).catchError(
      (error) {
        print(error);
      },
    );
  }
}
