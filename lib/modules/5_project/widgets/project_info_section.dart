import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_info_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/utils/common_list_notes.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ProjectInfoSection extends StatefulWidget {
  const ProjectInfoSection({
    Key? key,
    required project,
    required bool readonly,
    required Function onChange,
    required Function onNoteChange,
    required Function onSave,
    required Function onBack,
  })  : _project = project,
        _readonly = readonly,
        _onChange = onChange,
        _onNoteChange = onNoteChange,
        _onSave = onSave,
        _onBack = onBack,
        super(key: key);

  final dynamic _project;
  final bool _readonly;
  final Function _onChange;
  final Function _onNoteChange;
  final Function _onSave;
  final Function _onBack;

  @override
  _ProjectInfoSectionState createState() => _ProjectInfoSectionState();
}

class _ProjectInfoSectionState extends State<ProjectInfoSection> {
  late Future futureNote;

  Future<dynamic> _fetchData() async {
    return await ProjectService()
        .getProjectNote(widget._project!['PROJECT_ID']);
  }

  @override
  void initState() {
    futureNote = _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaDropdownRow(
          type: 'Project',
          tableName: 'PROJECT',
          fieldName: 'PROJECT_TYPE_ID',
          title: LangUtil.getString('PROJECT', 'PROJECT_TYPE_ID'),
          value: widget._project['PROJECT_TYPE_ID'] ?? '',
          readOnly: widget._readonly,
          onChange: (_, __) => widget._onChange(_, __, true),
        ),
        widget._project['PROJECT_ID']!=null? PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
              'AccountEditWindow', 'NotesTab.Header'),
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => CommonListNotes(
                  entityId: widget._project['PROJECT_ID'],
                  entityType: "Project",
                ),
              ),
            );
          },
        ):SizedBox(),
       /* FutureBuilder<dynamic>(
            future: futureNote,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return PsaTextAreaFieldRow(
                  key: Key('placehoder'),
                  fieldKey: 'NOTES',
                  title: LangUtil.getString(
                      'ProjectEditWindow', 'NotesTab.Header'),
                  value: '',
                );

              return PsaTextAreaFieldRow(
                key: Key('control'),
                fieldKey: 'NOTES',
                title:
                    LangUtil.getString('ProjectEditWindow', 'NotesTab.Header'),
                value: (snapshot.data != null && snapshot.data!.length > 0)
                    ? snapshot.data![0]['NOTES']
                    : '',
                onChange: (_, __) =>
                    widget._onNoteChange(_, __, snapshot.data?.length),
                readOnly: widget._readonly,
              );
            }),*/
        PsaButtonRow(
          isVisible: false,
          title: LangUtil.getString(
            'ProjectEditWindow',
            'InformationTab.Header',
          ),
          color: ProjectService().validateUserFields(widget._project)
              ? null
              : Colors.red,
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            if (widget._project['PROJECT_TYPE_ID'] == null ||
                widget._project['PROJECT_TYPE_ID'] == '') return false;

            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ProjectInfoScreen(
                  project: widget._project,
                  readonly: widget._readonly,
                  onSave: widget._onSave,
                  onBack: widget._onBack,
                ),
              ),
            ).then((value) {
              setState(() {});
            });
          },
        ),
      ],
    );
  }
}
