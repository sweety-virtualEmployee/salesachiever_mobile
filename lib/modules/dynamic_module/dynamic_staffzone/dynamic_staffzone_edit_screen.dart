import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/dynamic_staffzone_view_related_records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/decode_base64_util.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class DynamicStaffZoneEditScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final bool readonly;
  final String id;
  final String relatedEntityType;
  final String tableName;
  final String title;

  const DynamicStaffZoneEditScreen({
    Key? key,
    required this.entity,
    required this.readonly,
    required this.id,
    required this.relatedEntityType,
    required this.tableName,
    required this.title,
  }) : super(key: key);

  @override
  State<DynamicStaffZoneEditScreen> createState() =>
      _DynamicStaffZoneEditScreenState();
}

class _DynamicStaffZoneEditScreenState
    extends State<DynamicStaffZoneEditScreen> {
  late bool _readonly;
  late dynamic _entity;
  String? _dir;
  late List<dynamic> activeFields;
  late List<dynamic> mandatoryFields;
  bool _isValid = false;
  List<dynamic> _imageList = [];
  bool isLoading = false;
  static final key = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  void initState() {
    _readonly = widget.readonly;
    _entity = widget.entity;
    activeFields = [];
    mandatoryFields = [];
    print("id${widget.id}");
    print("tablename${widget.tableName}");
    print("title${widget.title}");
    print("id${widget.entity}");
    if (_entity['ENTITY_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues(widget.tableName);

      defaultValues.forEach((element) {
        _entity[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });
    }
    fetchDetails();
    _initDir();
    validate();
    super.initState();
  }

  _initDir() async {
    if (null == _dir) {
      _dir = '${(await getApplicationDocumentsDirectory()).path}/blobs';
    }

    var file = await Directory("$_dir").list().toList();
    print(file);
  }

  Future<void> fetchDetails() async {
    activeFields = await DynamicProjectService()
        .getStaffZoneActiveFields(widget.tableName);
    mandatoryFields = await LookupService().getMandatoryFields();
    print("mandatoryfields$mandatoryFields");
    if (_entity['ENTITY_ID'] != null) {
      print("yes it is not null");
      if (_entity["ACCT_ID"] != null) {
        var company = await CompanyService().getEntity(_entity["ACCT_ID"]);
        if (company?.data != null) {
          var response1 = company.data;

          setState(() {
            _entity["ACCT_ID"] = response1["ACCT_ID"];
            _entity["ACCTNAME"] = response1["ACCTNAME"];
          });
        }
      } else if (_entity["PROJECT_ID"] != null) {
        var project = await ProjectService().getEntity(_entity["PROJECT_ID"]);
        if (project?.data != null) {
          var response2 = project.data;
          print("Response$response2");

          setState(() {
            _entity["PROJECT_ID"] = response2["PROJECT_ID"];
            _entity["PROJECT_TITLE"] = response2["PROJECT_TITLE"];
          });
        }
      } else if (_entity["CONT_ID"] != null) {
        var contact = await ContactService().getEntity(_entity["CONT_ID"]);

        if (contact?.data != null) {
          var response3 = contact.data;
          print("Response$response3");

          setState(() {
            _entity["CONT_ID"] = response3["CONT_ID"];
            _entity["FIRSTNAME"] = response3["FIRSTNAME"];
          });
        }
      }
    } else {
      if (widget.relatedEntityType == "COMPANY") {
        var response = await CompanyService().getEntity(widget.id);

        if (response?.data != null) {
          var company = response.data;

          setState(() {
            _entity["ACCT_ID"] = company["ACCT_ID"];
            _entity["ACCTNAME"] = company["ACCTNAME"];
          });
        }
      } else if (widget.relatedEntityType == "PROJECT") {
        var project = await ProjectService().getEntity(widget.id);

        if (project?.data != null) {
          var response2 = project.data;
          print("Response$response2");

          setState(() {
            _entity["PROJECT_ID"] = response2["PROJECT_ID"];
            _entity["PROJECT_TITLE"] = response2["PROJECT_TITLE"];
          });
        }
      }
      if (widget.relatedEntityType == "CONTACT") {
        var contact = await ContactService().getEntity(widget.id);

        if (contact?.data != null) {
          var response3 = contact.data;
          print("Response$response3");

          setState(() {
            _entity["CONT_ID"] = response3["CONT_ID"];
            _entity["FIRSTNAME"] = response3["FIRSTNAME"];
          });
        }
      }
    }
  }

  void _onChange(String key, dynamic value, bool? isRequired) {
    setState(() {
      _entity[key] = value;
    });

    print("on change entity$_entity");
    validate();
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
    onDrawStart: () {
      print("on draw started");
    },
    onDrawEnd: () {
      print("on draw end");
    },
  );

  @override
  Widget build(BuildContext context) {
    print("ActiveFields$activeFields");
    print("isvalide$_isValid");
    print("_readonly$_readonly");
    var visibleFields = activeFields.where((e) => e['COLVAL']).toList();
    return PsaScaffold(
      action: Row(
        children: [
          _entity['ENTITY_ID']!=null
              ? GestureDetector(
                  child: PsaEditButton(
                    text: 'Upload',
                    onTap: addImage,
                  ),
                )
              : SizedBox(),
          _entity['ENTITY_ID']!=null
              ? GestureDetector(
                  child: PsaEditButton(
                    text: 'Print',
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return signaturePad();
                        },
                      );
                    },
                  ),
                )
              : SizedBox(),
          PsaEditButton(
            text: _readonly ? 'Edit' : 'Save',
            onTap: onTap,
          ),
        ],
      ),
      title: "Add new ${widget.title}",
      body: Container(
        child: buildBody(visibleFields),
      ),
    );
  }

  Widget signaturePad() {
   return Dialog(
     insetPadding: EdgeInsets.only(left: 5,right: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sign Here',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Signature(
              controller: _controller,
              height: 250,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Clear the signature
                    _controller.clear();
                  },
                  child: Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Save or process the signature
                    convertSignatureToImage();
                  },
                  child: Text('Upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void>convertSignatureToImage() async {
    try {
      ui.Image? image = await _controller.toImage();
      ByteData? byteData = await image!.toByteData(format: ui.ImageByteFormat.png);
      Uint8List byteList = byteData!.buffer.asUint8List();
      img.Image imgImage = img.decodeImage(byteList)!;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature_image.png';
      final pdfFile = File(filePath);
      await pdfFile.writeAsBytes(img.encodePng(imgImage));
      print("File written to: $filePath");
      Archive archive = Archive()
        ..addFile(ArchiveFile('signature_image.png', pdfFile.lengthSync(), pdfFile.readAsBytesSync()));
      final zipFilePath = '${directory.path}/signature_image.zip';
      final zipFile = File(zipFilePath);
      await zipFile.writeAsBytes(Uint8List.fromList(ZipEncoder().encode(archive)!));
      print("Zip file written to: $zipFilePath");
      var bytes = File(zipFilePath).readAsBytesSync();
      print("Zip file read as bytes");
      String base64Image = base64Encode(bytes);
      print("Base64 encoded image: $base64Image");
      var blob = {
        'ENTITY_ID': widget.id,
        "ENTITY_NAME": "AUTH_SIG",
        "FILENAME": "Signature.png",
        'BLOB_DATA': base64Image,
      };

      print("Blob data: ${blob.toString()}");
      await SitePhotoService().uploadBlob(blob);
      final String encodedString = await DynamicProjectService().getStaffZoneGeneratedReports(_entity["ENTITY_ID"],"",widget.id);
      print("encode string $encodedString");
      saveBase64AsPdf(encodedString,context,widget.title);
    } catch (e) {
      print("Error during conversion: $e");
    }
  }



  Widget buildBody(List<dynamic> visibleFields) {
    return Column(
      children: [
        PsaHeader(
          isVisible: true,
          icon: 'assets/images/create_record_icon.png',
          title: "Add new ${widget.title}",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: DataFieldService().generateFields(
                    key,
                    widget.tableName,
                    _entity,
                    visibleFields,
                    mandatoryFields,
                    _readonly,
                    _onChange,
                  ),
                ),
                DynamicStaffZoneDataViewRelatedRecords(
                  staffZone: _entity,
                  readonly: _readonly,
                  onChange: _onChange,
                  staffZoneId: _entity["${widget.tableName}_ID"] ?? "",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                  uploadImages();
                } else {
                  print('No document selected.');
                }
              });
            },
          ),
       /*   CupertinoActionSheetAction(
            child: const Text('Choose Image from Gallery'),
            onPressed: () async {
              Navigator.pop(context);

              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

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
                  uploadImages();
                } else {
                  print('No image selected.');
                }
              });
            },
          ),
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
          )*/
        ],
      ),
    );
  }

  Future uploadImages() async {
    context.loaderOverlay.show();

    try {
      _imageList.forEach((image) async {
        print(image["FILE"]);
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
            'ENTITY_ID':  _entity['ENTITY_ID'],
            'ENTITY_NAME': widget.tableName,
            'FILENAME': '${ _entity['ENTITY_ID']}' '$uuid' '',
            'BLOB_DATA': base64Image,
          };

        print("Blob data: ${blob.toString()}");
        await SitePhotoService().uploadBlob(blob);
          File('$_dir/$uuid.zip').deleteSync();

      });

    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
   }


  }

  void validate() {
    var isValid = DynamicProjectService().validateStaffZoneEntity(_entity);

    setState(() {
      _isValid = isValid;
    });
  }

  void onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveProject();
  }

  Future<void> saveProject() async {
    try {
      context.loaderOverlay.show();

      if (_entity['ENTITY_ID'] != null) {
        await DynamicProjectService().updateStaffZoneEntity(
            _entity!['ENTITY_ID'], _entity, widget.tableName);
      } else {
        var newEntity = await DynamicProjectService()
            .addNewStaffZoneEntity(_entity, widget.tableName);
        _entity['ENTITY_ID'] = newEntity['ENTITY_ID'];
      }

      setState(() => _readonly = !_readonly);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
