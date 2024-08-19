import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  int retryAttempts = 0; // Track retry attempts

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
            signatureField['BLOB_ID'] = item['BLOB_ID'];
            signatureField['BLOB_TYPE'] = item['BLOB_TYPE'];
            signatureField['FILENAME'] = item['FILENAME'];
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

  Future<void> fetchSignatureImage(BuildContext context) async {
    // Show loader dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      if (signatureField['BLOB_TYPE'] == '1') {
        final base64String =
            await SitePhotoService().getBlobById(signatureField['BLOB_ID']);


        var decodedBytes = base64.decode(base64String.replaceAll('\r\n', ''));

        final archive = ZipDecoder().decodeBytes(decodedBytes);
        final directory = await getApplicationDocumentsDirectory();
        final uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}_decoded_signature_image.png';
        final filePath = '${directory.path}/$uniqueFileName';
        File? outFile;

        for (var file in archive) {
          if (file.isFile) {
            outFile = File(filePath);
            outFile = await outFile.create(recursive: true);
            await outFile.writeAsBytes(file.content);
          }
        }
        Navigator.of(context).pop();

        await precacheImage(FileImage(outFile!), context);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: double.infinity, // Set your desired height
                      child: Image.file(outFile!, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      } else if (signatureField['BLOB_TYPE'] == '2') {
        // Handle URL for BLOB_TYPE 2
        final url = signatureField['FILENAME'];

        String cleanedUrl = url.replaceAll(r'\\', '//').replaceAll(r'\', '/');

        final encodedUrl = Uri.encodeFull(cleanedUrl);
        if (await canLaunch(encodedUrl)) {
          Navigator.of(context).pop(); // Close the loader dialog
          await launch(encodedUrl);
        } else {
          // Handle URL launch error
          Navigator.of(context).pop(); // Close the loader dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Could not launch the URL.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loader dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while processing the image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> convertAndUploadImage(
      Uint8List byteList, BuildContext context) async {
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
      await zipFile
          .writeAsBytes(Uint8List.fromList(ZipEncoder().encode(archive)!));

      var bytes = zipFile.readAsBytesSync();
      String base64Image = base64Encode(bytes);

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
      await SitePhotoService().uploadBlob(blob);
      SuccessUtil.showSuccessMessage(
          context, 'Signature uploaded successfully!!');
    } catch (e) {
      handleUploadFailure(byteList, context);
    }
  }

  void handleUploadFailure(Uint8List byteList, BuildContext context) {
    if (retryAttempts < 1) {
      retryAttempts++;
      showRetryDialog(byteList, context);
    } else {
      retryAttempts = 0;
      ErrorUtil.showErrorMessage(context,
          "The signature upload was unsuccessful. This has been saved to your Photo Gallery. Please try again later.");
    }
  }

  void showRetryDialog(Uint8List byteList, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload Failed"),
          content: Text("Would you like to retry the upload?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Retry"),
              onPressed: () {
                Navigator.of(context).pop();
                convertAndUploadImage(byteList, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> convertSignatureToImage() async {
    try {
      context.loaderOverlay.show();
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.pop(context);
      ui.Image? image = await _controller.toImage();
      ByteData? byteData =
          await image!.toByteData(format: ui.ImageByteFormat.png);
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
        action: signatureField['BLOB_ID'] != null
            ? PsaEditButton(
                text: "View Signature",
                onTap: () {
                  fetchSignatureImage(context);
                })
            : PsaEditButton(
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
                    readOnly: false,
                    // Disable editing if value is from API
                    onChange: (key, value) => onChange(key, value, true),
                  ),
                  PsaTextFieldRow(
                    isRequired: false,
                    fieldKey: "JOB_DESG",
                    title: LangUtil.getString("CONTACT", "JOB_TITLE"),
                    value: signatureField["JOB_DESG"],
                    keyboardType: TextInputType.text,
                    readOnly: false,
                    // Disable editing if value is from API
                    onChange: (key, value) => onChange(key, value, true),
                  ),
                  PsaTextFieldRow(
                    isRequired: false,
                    fieldKey: "COMPANY_NAME",
                    title: LangUtil.getString(
                        "SignatureEditWindow", "CompanyName.Title"),
                    value: signatureField["COMPANY_NAME"],
                    keyboardType: TextInputType.text,
                    readOnly: false,
                    // Disable editing if value is from API
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
