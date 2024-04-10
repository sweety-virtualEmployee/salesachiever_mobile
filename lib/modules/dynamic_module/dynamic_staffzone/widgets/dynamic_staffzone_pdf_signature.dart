import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/provider/dynamic_staffzone_provider.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:archive/archive_io.dart';

class DynamicSignatureViewerPage extends StatefulWidget {
  final String base64String;
  final String entityId;
  final String tableName;
  final String staffZoneType;
  final String id;
  final String relatedEntityType;

  DynamicSignatureViewerPage({
    required this.base64String,
    required this.entityId,
    required this.tableName,
    required this.staffZoneType,
    required this.id,
    required this.relatedEntityType,
  });

  @override
  _DynamicSignatureViewerPageState createState() =>
      _DynamicSignatureViewerPageState();
}

class _DynamicSignatureViewerPageState
    extends State<DynamicSignatureViewerPage> {
  String filePath = "";
  String base64EncodedString = "";
  Key _pdfViewKey = UniqueKey(); // Add a unique key for the PDFView

  late DynamicStaffZoneProvider _dynamicStaffZoneProvider;

  @override
  void initState() {
    super.initState();
    _dynamicStaffZoneProvider =
        Provider.of<DynamicStaffZoneProvider>(context, listen: false);
    fetchPdfFilePath(widget.base64String);
  }

  Future<void> fetchPdfFilePath(String base64String) async {
    try {
      final fileBytes = base64Decode(base64String);
      final directory = await getApplicationDocumentsDirectory();
      final fileValue = '${directory.path}/file.pdf';

      final pdfFile = File(fileValue);
      await pdfFile.writeAsBytes(fileBytes);

      setState(() {
        filePath = fileValue;
        base64EncodedString = base64String;
        _pdfViewKey = UniqueKey(); // Change the key to trigger a rebuild

      });
      print("filePath: $fileValue");
    } catch (e) {
      print("Error in fetchPdfFilePath: $e");
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
      insetPadding: EdgeInsets.symmetric(horizontal: 5),
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
                  onPressed: () => _controller.clear(),
                  child: Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: convertSignatureToImage,
                  child: Text('Upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> convertSignatureToImage() async {
    try {
      context.loaderOverlay.show();

      ui.Image? image = await _controller.toImage();
      ByteData? byteData =
          await image!.toByteData(format: ui.ImageByteFormat.png);
      Uint8List byteList = byteData!.buffer.asUint8List();
      img.Image imgImage = img.decodeImage(byteList)!;

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature_image.png';
      final pdfFile = File(filePath);
      await pdfFile.writeAsBytes(img.encodePng(imgImage));

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

      var blob = {
        'ENTITY_ID': widget.entityId,
        "ENTITY_NAME": "AUTH_SIG",
        "FILENAME": "Signature.png",
        'BLOB_DATA': base64Image,
      };

      await SitePhotoService().uploadBlob(blob);

      dynamic value =
          await DynamicProjectService().getStaffZoneSubScribedReports(widget.staffZoneType.split('/List/')[1].substring(0, 2));
      dynamic encodedString =
          await DynamicProjectService().getStaffZoneGeneratedReports(
        value[0]["ID"],
        value[0]["Title"],
        widget.entityId,
      );

      await fetchPdfFilePath(encodedString);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(
        context,
        MessageUtil.getMessage('500'),
      );
    } finally {
      context.loaderOverlay.hide();
      Navigator.pop(context); // Hide the dialog
    }
  }

  Future<void> onSaveReport() async {
    try {
      context.loaderOverlay.show();
      String fieldName = "";

      final fileBytes = base64Decode(base64EncodedString);
      final directory = await getApplicationDocumentsDirectory();
      final fileValue = '${directory.path}/file.pdf';
      final pdfFile = File(fileValue);
      await pdfFile.writeAsBytes(fileBytes);

      Archive archive = Archive()
        ..addFile(
          ArchiveFile(
            'file.pdf',
            pdfFile.lengthSync(),
            pdfFile.readAsBytesSync(),
          ),
        );

      final zipFilePath = '${directory.path}/file.zip';
      final zipFile = File(zipFilePath);
      await zipFile
          .writeAsBytes(Uint8List.fromList(ZipEncoder().encode(archive)!));

      var bytes = zipFile.readAsBytesSync();
      String base64Image = base64Encode(bytes);

      var generatedReport = {
        'ENTITY_ID': widget.entityId,
        "ENTITY_NAME": widget.tableName,
        "FILENAME": "RA-PSA Test 01-PSA Test 1-2458180-1.pdf",
        'BLOB_DATA': base64Image,
      };

      await SitePhotoService().uploadBlob(generatedReport);
      if (widget.relatedEntityType == "COMPANY") {
        fieldName = "ACCT_ID";
      } else if (widget.relatedEntityType == "PROJECT") {
        fieldName = "PROJECT_ID";
      } else if (widget.relatedEntityType == "CONTACT") {
        fieldName = "CONT_ID";
      }

      var result = await DynamicProjectService().getStaffZoneEntity(
          widget.tableName, fieldName, widget.staffZoneType, widget.id,1,
      );

      await _dynamicStaffZoneProvider.setStaffZoneEntity(result);

      Navigator.pop(context);
      Navigator.pop(context);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(
        context,
        MessageUtil.getMessage('500'),
      );
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: "Pdf Viewer",
      action: Row(
        children: [
          (widget.staffZoneType.split('/List/')[1].substring(0, 2)=="RA"||widget.staffZoneType.split('/List/')[1].substring(0, 2)=="AR")?PsaEditButton(
            text: 'Sign',
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return signaturePad();
                },
              );
            },
          ):SizedBox(),
          PsaEditButton(
            text: 'Save',
            onTap: onSaveReport,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PDFView(
              key: _pdfViewKey, // Set the key for PDFView
              filePath: filePath,
            ),
          ),
        ],
      ),
    );
  }
}
