import 'package:salesachiever_mobile/modules/99_50021_site_photos/api/site_photo_api.dart';

class SitePhotoService {
  final SitePhotoApi _sitePhotoApi = new SitePhotoApi();

  Future<dynamic> getImagesByActionId(String actionId, int pageNumber) async {
    return await _sitePhotoApi.getImagesByActionId(actionId, pageNumber,);
  }

  Future<String> getBlobById(String blobId) async {
    var data = await _sitePhotoApi.getBlobById(blobId);

    return data['BLOB_DATA'];
  }

  Future<void> deleteBlob(String blobId) async {
    await _sitePhotoApi.deleteBlob(blobId);
  }

  Future<dynamic> uploadBlob(dynamic blob) async {
    try{
      await _sitePhotoApi.uploadBlob(blob);
    }catch(e){
      print("Error Message${e.toString()}",);
    }
  }

  Future<dynamic> updateBlob(String blobId, dynamic blob) async {
    await _sitePhotoApi.updateBlob(blobId, blob);
  }
}
