import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:salesachiever_mobile/utils/success_util.dart';
import 'package:signature/signature.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ActionSignature extends StatefulWidget {
  ActionSignature({
    Key? key,
    required this.action,
  }) : super(key: key);

  final Map<String, dynamic> action;
  @override
  State<ActionSignature> createState() => _ActionSignatureState();
}

class _ActionSignatureState extends State<ActionSignature> {
  Map<String, dynamic> signatureField = {};
  bool isButtonEnabled = false;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      var response = await SitePhotoService()
          .getImagesByActionId(widget.action['ACTION_ID'], 1);

      for (var item in response) {
        if (item['ENTITY_NAME'] == 'ACTION_SIGN') {
          setState(() {
            signatureField['CLIENT_NAME'] = item['CLIENT_NAME'];
            signatureField['JOB_DESG'] = item['JOB_DESG'];
            signatureField['COMPANY_NAME'] = item['COMPANY_NAME'];
            isButtonEnabled = false;
          });
          break; // Assuming there's only one entry for ACTION_SIGN
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
    onDrawStart: () => print("on draw started"),
    onDrawEnd: () => print("on draw end"),
  );

  Widget signaturePad() {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Color(0xff057e9a),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlatformTextButton(
                  onPressed: uploadSignatureFromGallery,
                  child: Text(
                    'Upload from Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PlatformTextButton(
                  onPressed: _controller.clear,
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Signature(
            backgroundColor: Colors.white,
            controller: _controller,
            height: MediaQuery.of(context).size.height / 2,
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "I confirm that the work carried out today has been completed to my satisfaction and meets the requirements set out in work order.",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            color: Color(0xff057e9a),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlatformTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PlatformTextButton(
                  onPressed: convertSignatureToImage,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> convertAndUploadImage(Uint8List byteList, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature_image.png';
      final pdfFile = File(filePath);
      await pdfFile.writeAsBytes(byteList);

      Archive archive = Archive()
        ..addFile(
          ArchiveFile(
            'signature_image.png',
            pdfFile.lengthSync(),
            pdfFile.readAsBytesSync(),
          ),
        );

      final zipFilePath = '${directory.path}/signature_image.zip';
      final zipFile = File(zipFilePath);
      await zipFile.writeAsBytes(Uint8List.fromList(ZipEncoder().encode(archive)!));

      var bytes = zipFile.readAsBytesSync();
      String base64Image = base64Encode(bytes);
      print("base64image $base64Image");
      await saveImageToGallery(byteList);
      var blob = {
        "DESCRIPTION": "signature_image.png",
        "ENTITY_ID": widget.action["ACTION_ID"],
        "ENTITY_NAME": "ACTION_SIGN",
        "DATE_SIGNED": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "JOB_DESG": signatureField['JOB_DESG'],
        "COMPANY_NAME": signatureField['COMPANY_NAME'],
        "CLIENT_NAME": signatureField['CLIENT_NAME'],
        "BLOB_DATA": base64Image
      };
      print("blob $blob");

      await SitePhotoService().uploadBlob(blob);

      // Show success message after successful upload
      SuccessUtil.showSuccessMessage(
          context, 'Signature uploaded successfully!!'
      );

    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(
        context,
        MessageUtil.getMessage('500'),
      );
    }
  }

  Future<void> convertSignatureToImage() async {
    try {
      context.loaderOverlay.show();
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.pop(context);
      ui.Image? image = await _controller.toImage();
      ByteData? byteData = await image!.toByteData(format: ui.ImageByteFormat.png);
      Uint8List byteList = byteData!.buffer.asUint8List();
      img.Image imgImage = img.decodeImage(byteList)!;

      await convertAndUploadImage(byteList, context);

    } finally {
      context.loaderOverlay.hide();
    }
  }


  Future<void> uploadSignatureFromGallery() async {
    try {
      context.loaderOverlay.show();
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.pop(context);
      final pickedFile =
      await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final uploadBytes = await pickedFile.readAsBytes();
        await convertAndUploadImage(uploadBytes, context);
      }
    } finally {
      context.loaderOverlay.hide();
    }
  }

  void onChange(String key, dynamic value, dynamic isRequired) {
    setState(() {
      signatureField[key] = value;
      _validateFields();
    });
  }

  void _validateFields() {
    setState(() {
      isButtonEnabled = signatureField['CLIENT_NAME']?.isNotEmpty == true &&
          signatureField['JOB_DESG']?.isNotEmpty == true &&
          signatureField['COMPANY_NAME']?.isNotEmpty == true;
    });
  }

  Future<void> saveImageToGallery(Uint8List byteList) async {
    if (await Permission.storage.request().isGranted) {
      final result = await ImageGallerySaver.saveImage(byteList);
      if (result['isSuccess']) {
        print("Image saved to gallery successfully!");
      } else {
        print("Failed to save image to gallery.");
      }
    } else {
      print("Storage permission not granted.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayWidget: Center(
        child: CircularProgressIndicator(),
      ),
      overlayColor: Colors.black.withOpacity(0.5),
      overlayOpacity: 0.7,
      child: PsaScaffold(
        action: PsaEditButton(
          text: "Sign",
          onTap: isButtonEnabled
              ? () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return signaturePad();
              },
            );
          }
              : null,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            PsaTextFieldRow(
              isRequired: false,
              fieldKey: "CLIENT_NAME",
              title: LangUtil.getString("ACCOUNT", "ACCTNAME"),
              value: signatureField["CLIENT_NAME"],
              readOnly:false, // Disable editing if value is from API
              onChange: (key, value) => onChange(key, value, true),
            ),
            PsaTextFieldRow(
              isRequired: false,
              fieldKey: "JOB_DESG",
              title: LangUtil.getString("CONTACT", "JOB_TITLE"),
              value: signatureField["JOB_DESG"],
              keyboardType: TextInputType.text,
              readOnly: false, // Disable editing if value is from API
              onChange: (key, value) => onChange(key, value, true),
            ),
            PsaTextFieldRow(
              isRequired: false,
              fieldKey: "COMPANY_NAME",
              title: LangUtil.getString(
                  "SignatureEditWindow", "CompanyName.Title"),
              value: signatureField["COMPANY_NAME"],
              keyboardType: TextInputType.text,
              readOnly: false, // Disable editing if value is from API
              onChange: (key, value) => onChange(key, value, true),
            ),
            SizedBox(height: 20),
          ],
        ),
        title: '',
        showHome: false,
      ),
    );
  }
}
