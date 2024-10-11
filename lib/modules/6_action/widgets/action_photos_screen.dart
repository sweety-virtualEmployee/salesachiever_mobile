import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_attachment_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_photo_preview_screen.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      showHome: false,
      action: Row(
        children: [
          PsaAddButton(onTap: () async {
            final List<XFile>? selectedImages =
                await imagePicker.pickMultiImage(imageQuality: 50);
            if (selectedImages!.isNotEmpty) {
              imageFileList!.addAll(selectedImages);
            }
            setState(() {
              if (imageFileList != null) {
                for (int i = 0; i < imageFileList!.length; i++) {
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
          SizedBox(
            width: 20,
          ),
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
            uploadImages();
          })
        ],
      ),
      title: '',
      body: Container(
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        itemCount: _imageList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return PhotoTile(
                            file: _imageList[index]['FILE'],
                            fileExtension:
                                _imageList[index]['FILENAME'] != null
                                    ? _imageList[index]['FILENAME']
                                    : "",
                            description:
                                _imageList[index]['DESCRIPTION'] ?? '',
                            isSelected:
                                _imageList[index]['SELECTED'] ?? false,
                            isDelete:false,
                            onTap: () {
                              Navigator.push(
                                context,
                                platformPageRoute(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ActionPhotoPreviewScreen(
                                    photos: _imageList,
                                    selectedIndex: index,
                                    onDescriptionChanged: (i, text) {
                                      setState(() {
                                        _imageList[i]['DESCRIPTION'] =
                                            text ?? '';
                                        _imageList[i]['ISUPDATED'] = true;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            isNew: (_imageList[index]['ISNEW'] == true ||
                                _imageList[index]['ISUPDATED'] == true),
                            onDelete: () {
                              showPlatformDialog(
                                context: context,
                                builder: (_) => PlatformAlertDialog(
                                  title: Text('Delete File'),
                                  content: Text(
                                      'Do you want to delete selected file?'),
                                  actions: <Widget>[
                                    PlatformDialogAction(
                                      child: PlatformText('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    PlatformDialogAction(
                                      child: PlatformText('Delete'),
                                      onPressed: () async {
                                        if (_imageList[index]['ISNEW'] ==
                                                null ||
                                            _imageList[index]['ISNEW'] ==
                                                false)
                                          await SitePhotoService().deleteBlob(
                                              _imageList[index]['BLOB_ID']);

                                        setState(() {
                                          _imageList.removeAt(index);
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )),
          ],
        ),
      ),
    );
  }

  Future uploadImages() async {
    context.loaderOverlay.show();

    try {
      for (var image in _imageList) {
        if (image['ISNEW'] == true) {
          var uuid = Uuid().v1().toUpperCase();
          var encoder = ZipFileEncoder();
          encoder.create('$_dir/$uuid.zip');
          encoder.addFile(image['FILE']);
          encoder.close();
          var bytes = File('$_dir/$uuid.zip').readAsBytesSync();
          String base64Image = base64Encode(bytes);
          var blob = {
            'DESCRIPTION': image['DESCRIPTION'],
            'BLOB_DATA': base64Image,
            'ENTITY_ID': widget.action['ACTION_ID'],
            'ENTITY_NAME': 'ACTION',
            'FILENAME': '${widget.action['ACCTNAME']}$uuid${path.extension(image["FILE"].toString())}',
          };

          await SitePhotoService().uploadBlob(blob);
          File('$_dir/$uuid.zip').deleteSync();
        } else if (image['ISUPDATED'] == true) {
          var blob = {
            'ENTITY_ID': widget.action['ACTION_ID'],
            'ENTITY_NAME': 'ACTION',
            'FILENAME': image['FILENAME'],
            'DESCRIPTION': image['DESCRIPTION'],
          };

          await SitePhotoService().updateBlob(image['BLOB_ID'], blob);
        }
      }

      // Ensure the images are fetched only after all uploads/updates are done
      await _fetchImages();
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
    print("isloading$isLoading");
    _imageList.clear();

    int pageNumber = 1;
    bool loadMore = true;

    while (loadMore) {
      var response = await SitePhotoService()
          .galleryImage(widget.action['ACTION_ID'], pageNumber);

      List<dynamic> files = response;
      if (files.isEmpty) {
        setState(() {
          isLoading = false;
          _imageList = []; // Initialize _imageList to an empty array
        });
      } else {
        List<dynamic> imageFiles = files.where((file) {
          String filename = file['FILENAME'] ?? '';
          return filename.isNotEmpty &&
              !filename.endsWith('.pdf') && (filename.endsWith('.jpg') ||
              filename.endsWith('.jpeg') ||
              filename.endsWith('.png'));
        }).toList();
        setState(() {
          isLoading = false;
          _imageList.addAll(imageFiles);
        });
        print("after loading$isLoading");


        for (var i = 0; i < _imageList.length; i++) {
          if (_imageList[i]['BLOB_TYPE'] == "1") {
            SitePhotoService()
                .getBlobById(_imageList[i]['BLOB_ID'])
                .then((blob) async {
              var decodedBytes = base64.decode(blob.replaceAll('\r\n', ''));
              final archive = ZipDecoder().decodeBytes(decodedBytes);
              File? outFile;

              for (var file in archive) {
                var fileName = '$_dir/${files[i]['BLOB_ID']}';
                final directory = await getApplicationDocumentsDirectory();
                final filePath = '${directory.path}/file.pdf';

                final pdfFile = File(filePath);
                await pdfFile.writeAsBytes(file.content);
                setState(() {
                  int index = _imageList.indexWhere(
                          (element) =>
                      element['BLOB_ID'] == files[i]['BLOB_ID']);
                  if (index != -1) {
                    _imageList[index]['FILEPATH'] = filePath;
                  }
                });

                if (file.isFile) {
                  outFile = File(fileName);
                  outFile = await outFile.create(recursive: true);
                  await outFile.writeAsBytes(file.content);
                }
              }
              if (outFile != null) {
                setState(() {
                  int index = _imageList.indexWhere(
                          (element) =>
                      element['BLOB_ID'] == files[i]['BLOB_ID']);
                  if (index != -1) {
                    _imageList[index]['FILE'] = outFile;
                  }
                });
              }
            });
          } else if (_imageList[i]['BLOB_TYPE'] == "2") {
            print("blob_id");
            print(_imageList[i]['BLOB_ID']);
            var decodedBytes =
            base64.decode(_imageList[i]['BLOB_DATA'].replaceAll('\r\n', ''));
            final archive = ZipDecoder().decodeBytes(decodedBytes);
            final directory = await getApplicationDocumentsDirectory();
            final uniqueFileName =
                '${DateTime
                .now()
                .millisecondsSinceEpoch}image.png';
            final filePath = '${directory.path}/$uniqueFileName';
            File? outFile;

            for (var file in archive) {
              if (file.isFile) {
                outFile = File(filePath);
                outFile = await outFile.create(recursive: true);
                await outFile.writeAsBytes(file.content);
              }
            }
            if (outFile != null) {
              setState(() {
                _imageList[i]['FILE'] = outFile;
                _imageList[i]['FILEPATH'] = outFile?.path;
              });
            }
          }
        }
      }
      print(_imageList);
      loadMore = false;
      pageNumber++;
    }
  }
}
