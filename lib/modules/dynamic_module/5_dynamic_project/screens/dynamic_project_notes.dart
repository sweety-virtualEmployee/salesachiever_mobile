import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_project_notes_edit.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_psa_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import '../../../../shared/widgets/buttons/psa_edit_button.dart';
import '../../../../utils/lang_util.dart';

class DynamicProjectNotes extends StatefulWidget {
  String description;
  String notes;
  String notesId;
  final Map<String, dynamic> project;

  DynamicProjectNotes(
      {Key? key,
      required this.description,
      required this.notes,
      required this.project,required this.notesId})
      : super(key: key);

  @override
  _DynamicProjectNotesState createState() => _DynamicProjectNotesState();
}

class _DynamicProjectNotesState extends State<DynamicProjectNotes> {
  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: "Project Notes",
        action:PsaEditButton(
          text: 'Edit',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicProjectEditNotes(
                    description: widget.description,
                    project: widget.project,
                    notes: widget.notes,
                    notesId: widget.notesId,
                  );
                },
              ),
            );
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicPsaHeader(
              isVisible: true,
              icon: 'assets/images/projects_icon.png',
              title: widget.project['PROJECT_TITLE'] ??
                  LangUtil.getString('Entities', 'Project.Create.Text'),
              projectID: widget.project['PROJECT_ID'],
              status: widget.project['SELLINGSTATUS_ID'],
              siteTown: widget.project['SITE_TOWN'],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PlatformText(
                        "Description : ",
                        //widget.entity['ACCTNAME'] ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w700),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      PlatformText(
                        " ${widget.description}",
                        //widget.entity['ACCTNAME'] ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Divider(
                    color: Colors.black26,
                    thickness: 2,
                  ),
                  SizedBox(height: 5,),
                  PlatformText(
                    widget.notes,
                    style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

          ],
        ));
  }
}
