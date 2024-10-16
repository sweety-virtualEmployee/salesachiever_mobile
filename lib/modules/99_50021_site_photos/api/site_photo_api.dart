import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:salesachiever_mobile/api/api.dart';

class SitePhotoApi {
  final Api _api;
  final String? listName;

  SitePhotoApi({this.listName}) : _api = Api();

  Future<dynamic> getImagesByActionId(String actionId, int pageNumber) async {
    var filterData;
    var filterBy = [
      {
        'TableName': 'DOCUMENT_ENTITY_MAPPING',
        'FieldName': 'ENTITY_ID',
        'Comparison': '2',
        'ItemValue': actionId
      }
      ,
      {
        'TableName': 'DOCUMENT_ENTITY_MAPPING',
        'FieldName': 'ENTITY_NAME',
        'Comparison': '2',
        'ItemValue': 'ACTION'
      }
    ];
    filterData = jsonEncode(filterBy);
    Response response = await _api
        .get('/Document/$actionId');
    return response.data;
  }

  Future<dynamic> getBlobById(String blobId) async {
    Response response = await _api.get('/BlobStore/$blobId');

    return response.data;
  }

  Future<dynamic> deleteBlob(String blobId) async {
    Response response = await _api.delete('/BlobStore/$blobId');

    return response.data;
  }

  Future<dynamic> uploadBlob(dynamic blob) async {
    Response response = await _api.post('/BlobStore', blob);
    return response.data;
  }

  Future<dynamic> updateBlob(String blobId, dynamic blob) async {
    Response response = await _api.put('/BlobStore/$blobId', blob);

    return response.data;
  }

  Future<dynamic> getGalleryImage(String actionId, int pageNumber) async {
    Response response = await _api
        .get('/Document/Entity.Gallery?id=$actionId&searchText=%25&pageSize=20&pageNumber=$pageNumber');
    return response.data;
  }
}
