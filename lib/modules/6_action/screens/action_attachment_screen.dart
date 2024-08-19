import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_photo_preview_screen.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class ActionAttachmentScreen extends StatefulWidget {
  const ActionAttachmentScreen({Key? key, required this.action})
      : super(key: key);

  final dynamic action;

  @override
  _ActionAttachmentScreenState createState() => _ActionAttachmentScreenState();
}

class _ActionAttachmentScreenState extends State<ActionAttachmentScreen> {
  List<dynamic> _imageList = [];
  String? _dir;
  int totalCount = 0;
  int downloadedCount = 0;
  bool isLoading = false;

  final picker = ImagePicker();

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
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  Future addImage() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Add Documents'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Choose from Document'),
            onPressed: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.any);
              setState(() {
                if (result != null) {
                  setState(() {
                    isLoading = false;
                    _imageList.insert(0, {
                      'FILE': File(result.files.single.path!),
                      'ISNEW': true,
                      'ISUPDATED': false,
                      'DESCRIPTION': 'new document'
                    });
                  });
                } else {
                  print('No document selected.');
                }
              });
            },
          ),
          CupertinoActionSheetAction(
              child: const Text('Choose Image from Gallery'),
              onPressed: () async {
                final List<XFile>? selectedImages =
                    await imagePicker.pickMultiImage(imageQuality: 50);
                if (selectedImages!.isNotEmpty) {
                  imageFileList!.addAll(selectedImages);
                }
                setState(() {
                  if (imageFileList != null) {
                    for (int i = 0; i < imageFileList!.length; i++) {
                      setState(() {
                        isLoading = false;
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
              }),
          CupertinoActionSheetAction(
            child: const Text('Take Photo'),
            onPressed: () async {
              Navigator.pop(context);

              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);

              setState(() {
                if (pickedFile != null) {
                  setState(() {
                    isLoading = false;
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
            },
          )
        ],
      ),
    );
  }

  Future uploadImages() async {
    context.loaderOverlay.show();

    try {
      _imageList.forEach((image) async {
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
            'FILENAME': '${widget.action['ACCTNAME']}'
                '$uuid'
                '${path.extension(image["FILE"].toString())}',
          };

          await SitePhotoService().uploadBlob(blob);
          File('$_dir/$uuid.zip').deleteSync();
          _fetchImages();
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
      /* setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ActionAttachmentScreen( action: widget.action)));
      });*/

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
      List<dynamic> files = response;
      setState(() {
        _imageList.addAll(files);
      });
      for (var i = 0; i < files.length; i++) {
        SitePhotoService().getBlobById(files[i]['BLOB_ID']).then((blob) async {
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
          if (outFile != null) {
            setState(() {
              _imageList[_imageList.indexOf(_imageList.firstWhere(
                      (element) => element['BLOB_ID'] == files[i]['BLOB_ID']))]
                  ['FILE'] = outFile;
            });
          }
        });
      }
      loadMore = !response['IsLastPage'];
      pageNumber++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: '',
      action: Row(
        children: [
          _imageList.any((element) =>
                  element['ISNEW'] == true || element['ISUPDATED'] == true)
              ? GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.upload,
                      size: 24,
                    ),
                  ),
                  onTap: uploadImages,
                )
              : Container(),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                context.platformIcons.add,
                size: 24,
              ),
            ),
            onTap: addImage,
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: isLoading
                  ? Center(child: PlatformCircularProgressIndicator())
                  : GridView.builder(
                      itemCount: _imageList.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        // mainAxisExtent: 150,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return PhotoTile(
                          file: _imageList[index]['FILE'],
                          fileExtension: _imageList[index]['FILENAME'] != null
                              ? _imageList[index]['FILENAME']
                              : "",
                          description: _imageList[index]['DESCRIPTION'] ?? '',
                          isSelected: _imageList[index]['SELECTED'] ?? false,
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
                                      _imageList[i]['DESCRIPTION'] = text ?? '';
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
                                      if (_imageList[index]['ISNEW'] == null ||
                                          _imageList[index]['ISNEW'] == false)
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoTile extends StatelessWidget {
  const PhotoTile({
    Key? key,
    required this.file,
    required this.fileExtension,
    required this.description,
    required this.onTap,
    required this.onDelete,
    this.isNew = false,
    this.isSelected = false,
    this.isDelete = true,
  }) : super(key: key);

  final File? file;
  final String description;
  final String fileExtension;
  final Function onTap;
  final Function onDelete;
  final bool isNew;
  final bool isSelected;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade400 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade100,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      child: file != null
                          ? (path.extension(fileExtension).contains(".pdf'")) ||
                                  (path
                                      .extension(fileExtension)
                                      .contains(".png'")) ||
                                  (path
                                      .extension(fileExtension)
                                      .contains(".jpeg'"))
                              ? Icon(Icons.file_copy)
                              : Image.file(
                                  file!,
                                  fit: BoxFit.cover,
                                )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 45, right: 45, top: 30, bottom: 30),
                              child: SizedBox(
                                  height: 30,
                                  width: 40,
                                  child: PlatformCircularProgressIndicator()),
                            ),
                    ),
                  ),
                  isNew
                      ? Positioned.fill(
                          child: GestureDetector(
                            child: Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                          ),
                          left: 0,
                          top: 0,
                        )
                      : Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  )),
                  isDelete?GestureDetector(
                    onTap: () => onDelete(),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red.shade500,
                    ),
                  ):SizedBox(),
                  isSelected
                      ? Icon(
                          context.platformIcons.checkMark,
                          size: 16,
                          color: Colors.white,
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
