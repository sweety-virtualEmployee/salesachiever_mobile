import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionEmailScreen extends StatefulWidget {

  ActionEmailScreen({
    Key? key,
    required this.action,
  }) : super(key: key);

  final Map<String, dynamic> action;

  @override
  State<ActionEmailScreen> createState() => _ActionEmailScreenState();
}

class _ActionEmailScreenState extends State<ActionEmailScreen> {

  String filePath = "";
  String base64EncodedString = "";
  Key _pdfViewKey = UniqueKey(); // Add a unique key for the PDFView
  String email="contact@ouiquit.com";
  _launchEmail() async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }
  @override
  void initState() {
   fetchActionQuestionReportId();
    //launchEmailSubmission();
    super.initState();
  }

  void launchEmailSubmission() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'myOwnEmailAddress@gmail.com',
        queryParameters: {
          'subject': 'Default Subject',
          'body': 'Default body'
        }
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  fetchActionQuestionReportId() async {
    try {
      context.loaderOverlay.show();
      var result = await ActionService().actionQuestionRptApi();
      print(result);
      var response = await ActionService().questionRptApi(result["Items"][0]["VAR_VALUE"], widget.action["ACTION_ID"]);
      print(response["Value"]);
      print("value printed");
      fetchPdfFilePath(response["Value"]);
    }on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(
        context,
        MessageUtil.getMessage('500'),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(title: '',
        showHome: false,
        action:
          IconButton(
            onPressed: _launchEmail,
            icon: Icon(Icons.send),
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
    ));
  }
}
