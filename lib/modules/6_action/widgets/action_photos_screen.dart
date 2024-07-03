import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_camera_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:uuid/uuid.dart';

class ActionPhotosScreen extends StatefulWidget {

  ActionPhotosScreen({
    Key? key,
    required this.action,
  }) : super(key: key);

  final Map<String, dynamic> action;
  @override
  State<ActionPhotosScreen> createState() => _ActionPhotosScreenState();
}

class _ActionPhotosScreenState extends State<ActionPhotosScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<dynamic> _imageList = [];
  String? _dir;
  bool isLoading = false;

  void initState() {
    super.initState();
    _initDir();
    _fetchImages();
  }

  _initDir() async {
    if (null == _dir) {
      _dir = '${(await getApplicationDocumentsDirectory()).path}/blobs';
    }

    var file = await Directory("$_dir").list().toList();
    print(file);
  }
  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      showHome: false,
      action: Row(
        children: [
          PsaAddButton(onTap: () async {
            final List<XFile>? selectedImages = await imagePicker.pickMultiImage(imageQuality: 50);
            print(selectedImages);
            if (selectedImages!.isNotEmpty) {
              imageFileList!.addAll(selectedImages);
            }
            print("Image List Length:" + imageFileList!.length.toString());
            setState(() {
              if (imageFileList != null) {
                for(int i = 0;i<imageFileList!.length;i++){
                  setState(() {
                    _imageList.insert(i, {
                      'FILE': File(imageFileList![i].path),
                      'ISNEW': true,
                      'ISUPDATED': false,
                      'DESCRIPTION': 'new img'
                    });

                  });
                }
              }
            });
            uploadImages();
          }),
          SizedBox(width: 20,),
          PsaCameraButton(onTap: () async {
            final pickedFile =
                await imagePicker.pickImage(source: ImageSource.camera);
            setState(() {
              if (pickedFile != null) {
                setState(() {
                  _imageList.insert(0, {
                    'FILE': File(pickedFile.path),
                    'ISNEW': true,
                    'ISUPDATED': false,
                    'DESCRIPTION': 'new img'
                  });
                });
              } else {
                print('No image selected.');
              }
            });
          })
        ],
      ),
        title: '',
        body: Column(
          children: [

      ],
    ));
  }

  Future uploadImages() async {
    context.loaderOverlay.show();

    try {
      _imageList.forEach((image) async {
        print(path.extension(image["FILE"].toString()));
        print(image['ISNEW']);

        if (image['ISNEW'] == true) {
          var uuid = Uuid().v1().toUpperCase();
          print("dir$_dir");
          var encoder = ZipFileEncoder();
          encoder.create('$_dir/$uuid.zip');
          encoder.addFile(image['FILE']);
          encoder.close();
          print(encoder);

          var bytes = File('$_dir/$uuid.zip').readAsBytesSync();
          print("bytes");
          String base64Image = base64Encode(bytes);
          print("base64iamge$base64Image");

          var blob = {
            'DESCRIPTION': image['DESCRIPTION'],
            'BLOB_DATA': base64Image,
            'ENTITY_ID': widget.action['ACTION_ID'],
            'ENTITY_NAME': 'ACTION',
            'FILENAME': '${widget.action['ACCTNAME']}' '$uuid' '${path.extension(image["FILE"].toString())}',
          };

          await SitePhotoService().uploadBlob(blob);
          File('$_dir/$uuid.zip').deleteSync();

          //_fetchImages();
        } else if (image['ISUPDATED'] == true) {
          var blob = {
            'ENTITY_ID': widget.action['ACTION_ID'],
            'ENTITY_NAME': 'ACTION',
            'FILENAME': image['FILENAME'],
            'DESCRIPTION': image['DESCRIPTION'],
          };

          await SitePhotoService().updateBlob(image['BLOB_ID'], blob);
        }
      });
      _fetchImages();
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
      imageFileList!.clear();
    }
  }

  _fetchImages() async {
    setState(() {
      isLoading = true;
    });
    _imageList.clear();

    int pageNumber = 1;
    bool loadMore = true;

    while (loadMore) {
      var response = await SitePhotoService()
          .getImagesByActionId(widget.action['ACTION_ID'], pageNumber);

      setState(() {
        isLoading = false;
      });
      print("data----${response}");

      List<dynamic> files = response;

      setState(() {
        _imageList.addAll(files);
      });

      for (var i = 0; i < files.length; i++) {
        SitePhotoService().getBlobById(files[i]['BLOB_ID']).then((blob) async {
          var decodedBytes = base64.decode(blob.replaceAll('\r\n', ''));
          print("decodeBytes$decodedBytes");
          final archive = ZipDecoder().decodeBytes(decodedBytes);
          print("archive$archive");
          File? outFile;

          for (var file in archive) {
            var fileName = '$_dir/${files[i]['BLOB_ID']}';
            final directory = await getApplicationDocumentsDirectory();
            final filePath = '${directory.path}/file.pdf';

            final pdfFile = File(filePath);
            await pdfFile.writeAsBytes(file.content);

            print("filepath$filePath");
            setState(() {
              _imageList[_imageList.indexOf(_imageList.firstWhere(
                      (element) => element['BLOB_ID'] == files[i]['BLOB_ID']))]
              ['FILEPATH'] = filePath;
            });
            if (file.isFile) {
              outFile = File(fileName);
              outFile = await outFile.create(recursive: true);
              await outFile.writeAsBytes(file.content);
            }
          }
          print("check the output file");
          print(outFile);

          if (outFile != null) {
            setState(() {
              _imageList[_imageList.indexOf(_imageList.firstWhere(
                      (element) => element['BLOB_ID'] == files[i]['BLOB_ID']))]
              ['FILE'] = outFile;
            });
          }
        });
      }
      print("image list $_imageList");
      loadMore = !response['IsLastPage'];
      pageNumber++;
    }
  }
}
