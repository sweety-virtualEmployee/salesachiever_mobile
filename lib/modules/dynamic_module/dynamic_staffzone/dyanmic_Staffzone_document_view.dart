import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_Share_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:share/share.dart';

class DynamicStaffzoneDocumentView extends StatefulWidget {
  final String filePath;

  DynamicStaffzoneDocumentView({required this.filePath});
  @override
  State<DynamicStaffzoneDocumentView> createState() => _DynamicStaffzoneDocumentViewState();
}

class _DynamicStaffzoneDocumentViewState extends State<DynamicStaffzoneDocumentView> {
  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: "",
      action: PsaShareButton(
        onTap:(){
          sharePDFFile(widget.filePath);
        },
      ),
      body: PDFView(
        filePath: widget.filePath,
      ),
    );
  }

  void sharePDFFile(String filePath) {
    final file = File(filePath);

    if (file.existsSync()) {
      Share.shareFiles(
        [file.path],
        text: 'Sharing PDF file',
      );
    } else {
      print('PDF file does not exist at the specified path');
    }
  }

}
