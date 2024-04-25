import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class CommonNoteEditScreen extends StatefulWidget {
  final Map<String, dynamic> notes;
  final bool readonly;
  final String entityType;
  final String entityId;

  const CommonNoteEditScreen({
    Key? key,
    required this.notes,
    required this.readonly,
    required this.entityType,
    required this.entityId,
  }) : super(key: key);

  @override
  State<CommonNoteEditScreen> createState() => _CommonNoteEditScreenState();
}

class _CommonNoteEditScreenState extends State<CommonNoteEditScreen> {
  bool _readonly = true;
  dynamic _notes;

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = this.widget.readonly;
    _notes = this.widget.notes;
    super.initState();
  }

  onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveNotes();
  }

  void _onNoteChange(String fieldKey, dynamic value) {
    setState(() {
      _notes[fieldKey] = value; // Update the notes with the new value
    });
    print("_note${_notes["NOTES"]}");
  }

  Future<void> saveNotes() async {
    try {
      context.loaderOverlay.show();

      if (_notes['NOTE_ID'] != null) {
        await DynamicProjectService().updateEntityNote(widget.entityType,_notes['NOTE_ID'], _notes["NOTES"]);
      } else {
        var newEntity = await DynamicProjectService().addEntityNote(widget.entityType,widget.entityId, _notes["NOTES"]);
        _notes['NOTE_ID'] = newEntity['NOTE_ID'];
      }


      setState(() => _readonly = !_readonly);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: "${widget.entityType} Notes",
        action: PsaEditButton(
          text: _readonly ? 'Edit' : 'Save',
          onTap:  onTap ,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformText(
                "Created On: ${DateUtil.getFormattedDate(_notes['CREATED_ON'] ?? '')}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformText(
                "Created By: ${_notes['SAUSER_ID']}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformText(
                "Last Edited: ${DateUtil.getFormattedDate(_notes['LAST_EDITED'] ?? '')}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            PsaTextAreaFieldRow(
              key: Key('placehoder'),
              fieldKey: 'NOTES',
              title: LangUtil.getString('AccountEditWindow', 'NotesTab.Header'),
              value: _notes['NOTES'],
              onChange: (_,__) => _onNoteChange(_,__),
            )
          ],
        ));
  }
}
