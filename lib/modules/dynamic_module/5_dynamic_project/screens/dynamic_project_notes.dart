import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import '../../../../shared/widgets/buttons/psa_edit_button.dart';
import '../../../../shared/widgets/forms/psa_textfield_row.dart';
import '../../../../utils/error_util.dart';
import '../../../../utils/lang_util.dart';
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
    print("readonly");
    print(_readonly);
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }
    print("readonlyafter");
    print(_readonly);
    await saveProject();
  }

  Future<void> saveProject() async {
   // try {
      print("UdateNotes${_updateNotes}");
      print("isNotes${_isNewNote}");
      context.loaderOverlay.show();
      if (widget.isNewNote==true) {
        if(widget.entityType =="COMPANY"){
          await DynamicProjectService().addProjectNote(widget.typeNote,
              widget.project["ACCT_ID"], _updateNotes, _updateDescription);
        }else {
          await DynamicProjectService().addProjectNote(widget.typeNote,
              widget.project["PROJECT_ID"], _updateNotes, _updateDescription);
        }
      } else {
        await DynamicProjectService()
            .updateProjectNote(widget.typeNote,_notesData['NOTE_ID'], _updateNotes);
      }

      setState(() => _readonly = !_readonly);
    //}
 /*   on DioError catch (e) {
      print("error value$e");
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {*/
      context.loaderOverlay.hide();
    //}
  }

  @override
  Widget build(BuildContext context) {
    print("fieldData12${_notesData["NOTES"]}");
    print("fieldData12${ _notesData['DESCRIPTION']}");
    print("fieldData12${widget.isNewNote}");
    return PsaScaffold(
        title: "Project Notes",
        action: PsaEditButton(
          text: _readonly ? 'Edit' : 'Save',
          onTap: onTap,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.entityType=="COMPANY"?DynamicPsaHeader(
              isVisible: true,
              icon: 'assets/images/company_icon.png',
              title:  widget.project?['ACCTNAME'],
              projectID:  widget.project?['ACCT_ID'],
              status:  widget.project?['ACCT_TYPE_ID'],
              siteTown:  widget.project?['ADDR1'],
              backgroundColor: Color(0xff3cab4f),
            ):DynamicPsaHeader(
              isVisible: true,
              icon: 'assets/images/projects_icon.png',
              title: widget.project?['PROJECT_TITLE'] ??
                  LangUtil.getString('Entities', 'Project.Create.Text'),
              projectID:  widget.project?['PROJECT_ID'],
              status:  widget.project?['SELLINGSTATUS_ID'],
              siteTown:  widget.project?['OWNER_ID'],
              backgroundColor: Color(0xffE67E6B),
            ),
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
    print("state$state");
    print(value);
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