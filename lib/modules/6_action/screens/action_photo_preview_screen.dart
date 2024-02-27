import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:path/path.dart' as path;


class ActionPhotoPreviewScreen extends StatefulWidget {
  const ActionPhotoPreviewScreen({
    Key? key,
    required this.photos,
    this.selectedIndex = 0,
    required this.onDescriptionChanged,
  }) : super(key: key);

  final List<dynamic> photos;
  final int selectedIndex;
  final Function onDescriptionChanged;

  @override
  _ActionPhotoPreviewScreenState createState() =>
      _ActionPhotoPreviewScreenState();
}

class _ActionPhotoPreviewScreenState extends State<ActionPhotoPreviewScreen> {
  List<dynamic> photos = [];

  PageController _controller = PageController();

  @override
  void initState() {
    photos = widget.photos;

    _controller = PageController(
      initialPage: widget.selectedIndex,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _generateView() {
    return photos
        .map((photo) => PhotoPreview(
              photo: photo,
              index: photos.indexOf(photo),
              onDescriptionChanged: (index, text) {
                widget.onDescriptionChanged(index, text);

                setState(() {
                  photos[photos.indexOf(photo)]['DESCRIPTION'] = text;
                });
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: '',
      body: PageView(
        controller: _controller,
        children: _generateView(),
      ),
    );
  }
}

class PhotoPreview extends StatefulWidget {
  PhotoPreview({
    Key? key,
    required this.photo,
    required this.index,
    required this.onDescriptionChanged,
  }) : super(key: key);

  final dynamic photo;
  final int index;
  final Function onDescriptionChanged;

  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.photo["FILE"]);
    print(widget.photo["FILENAME"]);
    print(widget.photo["FILEPATH"]);
    textController.text = widget.photo['DESCRIPTION'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          path.extension(widget.photo["FILENAME"].toString()).contains(".jpg'")?Expanded(
            child: Container(
              color: Colors.black,
              child: Image.file(
               File('/Users/charul/Library/Developer/CoreSimulator/Devices/313E0F9D-3627-4040-9415-62FD660255EB/data/Containers/Data/Application/2A680AEB-DD63-42EC-AAFB-4F7B1E94EEA4/Documents/000004985748'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ):Expanded(
            child: PDFView(
              filePath: widget.photo['FILEPATH']),
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: CupertinoTextField(
                controller: textController,
                placeholder: 'Description',
                onChanged: (text) {
                  setState(() {
                    this.widget.onDescriptionChanged(widget.index, text);
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
