import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_text_field.dart';

class DynamicProjectEditNotes extends StatefulWidget {
  String description;
  String notes;
  String notesId;
  final Map<String, dynamic> project;

  DynamicProjectEditNotes(
      {Key? key,
      required this.description,
      required this.notes,
      required this.project,required this.notesId})
      : super(key: key);

  @override
  _DynamicProjectEditNotesState createState() =>
      _DynamicProjectEditNotesState();
}

class _DynamicProjectEditNotesState extends State<DynamicProjectEditNotes> {
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    notesController.text = widget.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: "Edit Project Notes",
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15.0),
          child: Column(
            children: [
              TextField(
                controller: notesController,
                minLines: 6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PsaEditButton(
                text: 'Update',
                onTap: () async {
                  await  DynamicProjectService()
                      .updateProjectNote(widget.project['PROJECT_ID'], notesController.text,widget.notesId);
                },
              )
            ],
          ),
        ));
  }
}
