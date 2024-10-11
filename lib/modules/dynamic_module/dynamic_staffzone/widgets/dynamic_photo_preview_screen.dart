import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/widgets/buttons/psa_Share_button.dart';

class DynamicPhotoPreview extends StatefulWidget {
  DynamicPhotoPreview({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final dynamic photo;

  @override
  _DynamicPhotoPreviewState createState() => _DynamicPhotoPreviewState();
}

class _DynamicPhotoPreviewState extends State<DynamicPhotoPreview> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    print("widget.${widget.photo["FILE"]}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: "Preview",
        action: PsaShareButton(
        onTap:(){
         sharePDFFile( widget.photo["FILEPATH"]);
        },
    ),
    body:Column(
      children: [buildImage()],
    ));
  }

  void sharePDFFile(String filePath) {
    final file = File(filePath);

    if (file.existsSync()) {
      final xFile = XFile(filePath);
      Share.shareXFiles(
          [xFile], // Path to the file wrapped in XFile
          text: 'share pdf',
          subject: 'pdf document'// Optional subject
      );
    } else {
      print('PDF file does not exist at the specified path');
    }
  }

  Widget buildImage() {
    if ((path.extension(widget.photo["FILENAME"]).contains(".jpg")) ||
        (path.extension(widget.photo["FILENAME"]).contains(".png")) ||
        (path.extension(widget.photo["FILENAME"]).contains(".jpeg"))) {
      return Center(
        child: Container(
          height: 500,
          child: Image.file(
            widget.photo["FILE"],
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Expanded(
        child: PDFView(filePath: widget.photo['FILEPATH']),
      );
    }
  }
}
