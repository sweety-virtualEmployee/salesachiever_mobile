import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import '../../../../shared/widgets/buttons/psa_edit_button.dart';
import '../../../../shared/widgets/forms/psa_textfield_row.dart';
import '../../../../utils/error_util.dart';
import '../../../../utils/message_util.dart';
import '../services/dynamic_project_service.dart';

class DynamicProjectNotes extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<String, dynamic> notesData;
  final bool isNewNote;
  final String entityType;
  final String typeNote;

   DynamicProjectNotes(
      {Key? key,
        required this.typeNote,
      required this.project,required this.notesData,required this.isNewNote,required this.entityType})
      : super(key: key);

  @override
  _DynamicProjectNotesState createState() => _DynamicProjectNotesState();
}

class _DynamicProjectNotesState extends State<DynamicProjectNotes> {
  bool _readonly = true;
  dynamic _notesData;
  String _updateNotes='';
  String _updateDescription='';
  bool? _isNewNote;
  @override
  void initState() {
    _notesData = this.widget.notesData;
    super.initState();
  }


  onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }
    print(_readonly);
    await saveProject();
  }

  Future<void> saveProject() async {
    try {
      context.loaderOverlay.show();
      if (widget.isNewNote==true) {
        if(widget.entityType =="COMPANY"){
          await DynamicProjectService().addProjectNote(widget.typeNote,
              widget.project["ACCT_ID"], _updateNotes, _updateDescription);
        } else if(widget.entityType =="CONTACT"){
          await DynamicProjectService().addProjectNote(widget.typeNote,
              widget.project["CONT_ID"], _updateNotes, _updateDescription);
        } else if(widget.entityType =="ACTION"){
          await ActionService().updateEntity(widget.typeNote, {"NOTES":_updateNotes});
        }else {
          await DynamicProjectService().addProjectNote(widget.typeNote,
              widget.project["PROJECT_ID"], _updateNotes, _updateDescription);
        }
      } else {
        await DynamicProjectService()
            .updateProjectNote(widget.typeNote,_notesData['NOTE_ID'], _updateNotes);
      }
      setState(() => _readonly = !_readonly);
    }
    on DioException catch (e) {
      print("error value$e");
      ErrorUtil.showErrorMessage(context, e.message!);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: _readonly ? 'Edit Notes' : 'Add Notes',
        action: PsaEditButton(
          text: _readonly ? 'Edit' : 'Save',
          onTap: onTap,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height:70,
                child: CommonHeader(entityType: widget.entityType, entity: widget.project)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PsaTextFieldRow(
                  isRequired: false,
                  fieldKey:_notesData['DESCRIPTION']!=null? _notesData['DESCRIPTION']:"",
                  title:"Description",
                  value:_notesData['DESCRIPTION']!=null? _notesData['DESCRIPTION']:"",
                  keyboardType: TextInputType.text,
                  readOnly:!widget.isNewNote,
                  onChange: (_, __) =>_onDescriptionChange(__,_notesData["DESCRIPTION"].toString().length),
                ),
                PsaTextFieldRow(
                  isRequired: false,
                  maxLines: 30 ,
                  fieldKey: _notesData['NOTES']!=null?_notesData["NOTES"]:"",
                  title: "Notes",
                  value: _notesData['NOTES']!=null?_notesData["NOTES"]:"",
                  keyboardType: TextInputType.text,
                  readOnly: _readonly,
                  onChange: (_, __) => _onNoteChange(__,_notesData["NOTES"].toString().length),
                ),
              ],
            ),

          ],
        ));
  }

  void _onNoteChange(String value,int? state) {
    setState(() {
      _updateNotes = value;
      _isNewNote = state == null || state == 0;
    });
  }

  void _onDescriptionChange(String value,int? state) {
    print("state$state");
    print(value);
    setState(() {
      _updateDescription = value;
    });
  }
}
