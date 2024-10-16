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
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_camera_button.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:uuid/uuid.dart';

class ActionPhotosScreen extends StatefulWidget {
  ActionPhotosScreen({
    Key? key,
    required this.action,
    required this.category,
  }) : super(key: key);

  final Map<String, dynamic> action;
  List<dynamic> category;

  @override
  State<ActionPhotosScreen> createState() => _ActionPhotosScreenState();
}

class _ActionPhotosScreenState extends State<ActionPhotosScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<dynamic> _imageList = [];
  String? _dir;
  bool isLoading = false;
  List<Map<String, dynamic>> _selectedImages = [];
  bool _isSelectionMode = false;

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
          PsaEditButton(
            onTap: () {
              setState(() {
                _isSelectionMode = !_isSelectionMode; // Toggle selection mode
                if (!_isSelectionMode) {
                  _selectedImages
                      .clear(); // Clear selections if exiting selection mode
                }
              });
            },
            text: _isSelectionMode ? 'Cancel' : 'Select',
          ),
          if (_isSelectionMode)
            TextButton(
              onPressed: _selectedImages.isNotEmpty
                  ? () {
                      _showBottomSheet(context, _selectedImages);
                    }
                  : null, // Disable button if no images are selected
              child: Text(
                'Done',
                style: TextStyle(
                  color: _selectedImages.isNotEmpty
                      ? Colors.blue
                      : Colors.grey, // Grey out if no selections
                ),
              ),
            ),
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
                        bool isSelected =
                            _selectedImages.contains(_imageList[index]);
                        print(isSelected);
                        print("isSelected");
                        return Stack(
                          children: [
                            PhotoTile(
                              file: _imageList[index]['FILE'],
                              fileExtension:
                                  _imageList[index]['FILENAME'] != null
                                      ? _imageList[index]['FILENAME']
                                      : "",
                              description:
                                  _imageList[index]['DESCRIPTION'] ?? '',
                              isSelected: isSelected,
                              isDelete: true,
                              onTap: () {
                                if (_isSelectionMode) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedImages.remove(_imageList[index]);
                                    } else {
                                      _selectedImages.add(_imageList[index]);
                                    }
                                  });
                                } else {
                                  // Normal tap behavior (if not in selection mode)
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
                                }
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
                            ),
                            if (_isSelectionMode && isSelected)
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<Map<String, dynamic>> selectedImages) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        bool showPhoto = false;
        bool abort = false;
        String? selectedCategoryId; // Store the selected TIER2_ID

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetSetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.00),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Category"),
                      Spacer(),
                      DropdownButton<String>(
                        value: selectedCategoryId,
                        hint: Text('Select Category'),
                        items: widget.category.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['TIER2_ID'],  // Store TIER2_ID as the value
                            child: Text(category['DESCRIPTION']),  // Display DESCRIPTION
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          bottomSheetSetState(() {
                            selectedCategoryId = newValue;  // Update the selected TIER2_ID
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Show Photo'),
                      Spacer(),
                      Checkbox(
                        value: showPhoto,
                        onChanged: (bool? value) {
                          bottomSheetSetState(() {
                            showPhoto = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Abort'),
                      Spacer(),
                      Checkbox(
                        value: abort,
                        onChanged: (bool? value) {
                          bottomSheetSetState(() {
                            abort = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        for (var image in selectedImages) {
                          image['CATEGORY_ID'] = selectedCategoryId;
                          image['SHOW_PHOTO'] = showPhoto;
                          image['ABORT'] = abort;
                          updateAction(widget.action["ACTION_ID"], image);
                        }
                      });
                      Navigator.pop(context);
                      setState(() {
                        _isSelectionMode = false; // Turn off selection mode
                        _selectedImages.clear();  // Clear selected images
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Button takes full width
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  Future updateAction(String actionId, dynamic image) async {
    await ActionService().updateAction(actionId, image);
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
            'FILENAME':
                '${widget.action['ACCTNAME']}$uuid${path.extension(image["FILE"].toString())}',
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
      await _fetchImages();
    } on DioException catch (e) {
      ErrorUtil.showErrorMessage(context, e.message!);
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
    _imageList.clear(); // Clear previous images

    int pageNumber = 1;
    bool loadMore = true;
    Map<String, List<Map<String, dynamic>>> groupedImages = {};

    while (loadMore) {
      var response = await SitePhotoService()
          .galleryImage(widget.action['ACTION_ID'], pageNumber);
      try {
        List<dynamic> files = response;
        if (files.isEmpty) {
          setState(() {
            isLoading = false;
            _imageList = []; // Initialize _imageList to an empty array
          });
        } else {
          // Filter images (only jpg, jpeg, png)
          List<dynamic> imageFiles = files.where((file) {
            String filename = file['FILENAME'] ?? '';
            return filename.isNotEmpty &&
                !filename.endsWith('.pdf') &&
                (filename.endsWith('.jpg') ||
                    filename.endsWith('.jpeg') ||
                    filename.endsWith('.png'));
          }).toList();

          for (var i = 0; i < imageFiles.length; i++) {
            if (imageFiles[i]['BLOB_TYPE'] == "1") {
              // Handle BLOB_TYPE 1 (e.g., downloading PDF)
              SitePhotoService()
                  .getBlobById(imageFiles[i]['BLOB_ID'])
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
                            (element) => element['BLOB_ID'] == files[i]['BLOB_ID']);
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
                            (element) => element['BLOB_ID'] == files[i]['BLOB_ID']);
                    if (index != -1) {
                      _imageList[index]['FILE'] = outFile;
                    }
                  });
                }
              });
            } else if (imageFiles[i]['BLOB_TYPE'] == "2") {
              var decodedBytes = base64
                  .decode(imageFiles[i]['BLOB_DATA'].replaceAll('\r\n', ''));
              final archive = ZipDecoder().decodeBytes(decodedBytes);
              final directory = await getApplicationDocumentsDirectory();
              final uniqueFileName =
                  '${DateTime.now().millisecondsSinceEpoch}image.png';
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
                  imageFiles[i]['FILE'] = outFile;
                  imageFiles[i]['FILEPATH'] = outFile?.path;
                });
              }
            }
          }

          // Group images by CATEGORY_ID
          for (var file in imageFiles) {
            String categoryId = file['CATEGORY_ID'] ?? 'undefined'; // Default to 'undefined' if no CATEGORY_ID
            if (!groupedImages.containsKey(categoryId)) {
              groupedImages[categoryId] = [];
            }
            groupedImages[categoryId]!.add(file);
          }

          setState(() {
            isLoading = false;
            _imageList = imageFiles; // Update _imageList with the new images
          });

          print("after loading$isLoading");
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          _imageList = []; // Initialize _imageList to an empty array
        });
      }
      print("CATEGORY_ID Keys:");
      groupedImages.keys.forEach((categoryId) {
        print(categoryId); // This will print each CATEGORY_ID
      }); // Output grouped images for debugging
      loadMore = false;
      pageNumber++;
    }
  }

}
