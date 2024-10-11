import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_Share_button.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/decode_base64_util.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:archive/archive_io.dart';


class PDFViewerPage extends StatefulWidget {
  final String filePath;
  final bool showSignature;
  final String entityId;

  PDFViewerPage({required this.filePath,required this.showSignature,required this.entityId});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {

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
                    _controller.clear();
                  },
                  child: Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
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
      Archive archive = Archive()
        ..addFile(ArchiveFile('signature_image.png', pdfFile.lengthSync(), pdfFile.readAsBytesSync()));
      final zipFilePath = '${directory.path}/signature_image.zip';
      final zipFile = File(zipFilePath);
      await zipFile.writeAsBytes(Uint8List.fromList(ZipEncoder().encode(archive)!));
      var bytes = File(zipFilePath).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      var blob = {
        'ENTITY_ID': widget.entityId,
        "ENTITY_NAME": "AUTH_SIG",
        "FILENAME": "Signature.png",
        'BLOB_DATA': base64Image,
      };
      await SitePhotoService().uploadBlob(blob);
      dynamic value = await DynamicProjectService().getStaffZoneSubScribedReports("RA");
      dynamic encodedString = await DynamicProjectService().getStaffZoneGeneratedReports(value[0]["ID"],value[0]["Title"], widget.entityId);
      saveBase64AsPdf(encodedString,context,value[0]["Title"],false,widget.entityId);
    } catch (e) {
      print("Error during conversion: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: "Pdf Viewer",
      action: Row(
        children: [
          if (widget.showSignature) PsaEditButton(
        text: 'Sign',
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return signaturePad();
            },
          );
        }) else SizedBox(),
          PsaShareButton(
            onTap:(){
              sharePDFFile(widget.filePath);
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.filePath,
      ),
    );
  }

  void sharePDFFile(String filePath) {
    final file = File(filePath);

    if (file.existsSync()) {
      final xFile = XFile(filePath);
      Share.shareXFiles(
          [xFile], // Path to the file wrapped in XFile
          text: 'sharing pdf file',
          subject: 'sharing pdf file'// Optional subject
      );
    } else {
      print('PDF file does not exist at the specified path');
    }
  }

}
