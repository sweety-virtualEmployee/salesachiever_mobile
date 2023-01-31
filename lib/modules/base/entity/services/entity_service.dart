abstract class EntityService {
  final String? listName = '';

  Future<dynamic> getEntity(String entityId) async {}

  Future<void> addNewEntity(dynamic entity) async {}

  Future<void> updateEntity(String id, dynamic entity) async {}

  Future<dynamic> searchEntity({
    required String searchText,
    required int pageNumber,
    required int pageSize,
    required List<dynamic>? sortBy,
    required List<dynamic>? filterBy,
  }) async {}
}
