import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/CustomWidgets/pdf_screen.dart';

 saveBase64AsPdf(String base64String,BuildContext context,String title) async {
  final fileBytes = base64Decode(base64String);

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/file.pdf';

  final pdfFile = File(filePath);
  await pdfFile.writeAsBytes(fileBytes);

  print('PDF file saved successfully at: $filePath');
  Navigator.push(
   context,
   MaterialPageRoute(
    builder: (context) => PDFViewerPage(filePath: filePath),
   ),
  );
}

String encodeFileToBase64(File file) {
 List<int> fileBytes = file.readAsBytesSync();
 String base64File = base64Encode(fileBytes);
 print("base64fileString $base64File");
 return base64File;
}
