import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/access_codes.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_info_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_email_Screen.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_photos_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_signature.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_site_tier_value.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/utils/auth_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionInfoSection extends StatefulWidget {
  const ActionInfoSection({
    Key? key,
    required action,
    required bool readonly,
    required Function onChange,
    required Function onSave,
    required Function onBack,
  })  : _action = action,
        _readonly = readonly,
        _onChange = onChange,
        _onSave = onSave,
        _onBack = onBack,
        super(key: key);

  final dynamic _action;
  final bool _readonly;
  final Function _onChange;
  final Function _onSave;
  final Function _onBack;

  @override
  _ActionInfoSectionState createState() => _ActionInfoSectionState();
}

class _ActionInfoSectionState extends State<ActionInfoSection> {
  @override
  void initState() {
    // futureNote = _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaDropdownRow(
          type: 'Action',
          tableName: 'ACTION',
          fieldName: 'ACTION_TYPE_ID',
          title: LangUtil.getString('ACTION', 'ACTION_TYPE_ID'),
          value: widget._action['ACTION_TYPE_ID'] ?? '',
          readOnly: widget._readonly,
          isRequired: true,
          onChange: (_, __) => widget._onChange(_, __, true),
        ),
        PsaTextAreaFieldRow(
          fieldKey: 'NOTES',
          title: LangUtil.getString('AccountEditWindow', 'NotesTab.Header'),
          value: widget._action['NOTES'] ?? '',
          readOnly: widget._readonly,
          onChange: (_, __) => widget._onChange(_, __, true),
        ),
        PsaButtonRow(
          isVisible: false,
          title:
              LangUtil.getString('AccountEditWindow', 'InformationTab.Header'),
          color: ActionService().validateUserFields(widget._action)
              ? null
              : Colors.red,
          icon: Icon(context.platformIcons.rightChevron),
          onTap: () {
            if (widget._action['ACTION_TYPE_ID'] == null ||
                widget._action['ACTION_TYPE_ID'] == '') return false;
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionInfoScreen(
                  action: widget._action,
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
        if (AuthUtil.hasAccess(
            int.parse(ACCESS_CODES['Stormsaver'].toString()))) ...[
          if (widget._action["TIER1"] != null)
            PsaButtonRow(
              isVisible: false,
              title: LangUtil.getString(
                  'ActionEditWindow', 'SiteQuestion.Description'),
              color: ActionService().validateUserFields(widget._action)
                  ? null
                  : Colors.red,
              icon: Icon(context.platformIcons.rightChevron),
              onTap: () {
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => ActionSiteTierValue(
                      action: widget._action,
                    ),
                  ),
                );
              },
            ),
          if (widget._action["ACTION_ID"] != null)
            PsaButtonRow(
              isVisible: false,
              title:
                  LangUtil.getString('AccountEditWindow', 'Photo.Description'),
              color: ActionService().validateUserFields(widget._action)
                  ? null
                  : Colors.red,
              icon: Icon(context.platformIcons.rightChevron),
              onTap: () async {
                var response = await ActionService().getTableTierCategory();
                print(response);
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => ActionPhotosScreen(
                      action: widget._action,
                      category: response["Items"],
                    ),
                  ),
                );
              },
            ),
          if (widget._action["ACTION_ID"] != null)
            PsaButtonRow(
              isVisible: false,
              title:
                  LangUtil.getString('Entities', 'ClientSignature.Description'),
              color: ActionService().validateUserFields(widget._action)
                  ? null
                  : Colors.red,
              icon: Icon(context.platformIcons.rightChevron),
              onTap: () {
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => ActionSignature(
                      action: widget._action,
                    ),
                  ),
                );
              },
            ),
          if (widget._action["ACTION_ID"] != null)
            PsaButtonRow(
              isVisible: false,
              title: LangUtil.getString('Entities', 'Email.Description'),
              color: ActionService().validateUserFields(widget._action)
                  ? null
                  : Colors.red,
              icon: Icon(context.platformIcons.rightChevron),
              onTap: () {
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => ActionEmailScreen(
                      action: widget._action,
                    ),
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}
