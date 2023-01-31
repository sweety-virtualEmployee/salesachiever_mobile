import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_attachment_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';

class ActionAttachmentManager extends StatefulWidget {
  ActionAttachmentManager({
    Key? key,
    required this.action,
  }) : super(key: key);

  final dynamic action;

  @override
  _ActionAttachmentManagerState createState() => _ActionAttachmentManagerState();
}

class _ActionAttachmentManagerState extends State<ActionAttachmentManager> {
  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
          isVisible: false,
          title: 'Photos',
          onTap: () => Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (BuildContext context) => ActionAttachmentScreen(
                action: widget.action,
              ),
            ),
          ),
          icon: Icon(context.platformIcons.rightChevron),
        ),
      ]
    );
  }
}
