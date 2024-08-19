import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/flutter_email.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:share/share.dart';
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

  @override
  void initState() {
    super.initState();
    fetchActionQuestionReportId();
  }

  void launchEmailSubmission() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'myOwnEmailAddress@gmail.com',
      queryParameters: {
        'subject': 'Default Subject',
        'body': 'Default body',
      },
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  fetchActionQuestionReportId() async {
    context.loaderOverlay.show(); // Show loader
    try {
      var result = await ActionService().actionQuestionRptApi();
      var response = await ActionService().questionRptApi(
          result["Items"][0]["VAR_VALUE"], widget.action["ACTION_ID"]);
      await fetchPdfFilePath(response["Value"]);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(
        context,
        MessageUtil.getMessage('500'),
      );
    } finally {
      context.loaderOverlay.hide(); // Hide loader
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
    } catch (e) {
      print("Error in fetchPdfFilePath: $e");
    }
  }


  Future<void> send() async {
      final file = File(filePath);
      if (file.existsSync()) {
        Share.shareFiles(
          [file.path],
          text: '${widget.action["PROJECT_ID"]} ${widget.action["PROJECT_TITLE"]}',
          subject: '${widget.action["PROJECT_ID"]} ${widget.action["PROJECT_TITLE"]}'
        );
      } else {
        print('PDF file does not exist at the specified path');
      }
    }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: true,
      overlayWidget: Center(
        child: CircularProgressIndicator(),
      ),
      child: PsaScaffold(
        title: '',
        showHome: false,
        action: IconButton(
          onPressed: send,
          icon: Icon(Icons.send),
        ),
        body: Column(
          children: [
            Expanded(
              child: filePath.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : PDFView(
                      key: _pdfViewKey, // Set the key for PDFView
                      filePath: filePath,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
