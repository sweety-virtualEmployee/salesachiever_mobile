import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/shared/screens/related_entity_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';

class RelatedEntityWidget extends StatefulWidget {
  const RelatedEntityWidget({
    Key? key,
    required this.entity,
    required this.entityType,
    required this.title,
    required this.id,
    required this.relatedEntityType,
    required this.isEditable,
  }) : super(key: key);

  final dynamic entity;
  final String entityType;
  final String title;
  final String id;
  final String relatedEntityType;
  final bool isEditable;

  @override
  _RelatedEntityWidgetState createState() => _RelatedEntityWidgetState();
}

class _RelatedEntityWidgetState extends State<RelatedEntityWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PsaButtonRow(
      isVisible: true,
      title: widget.title,
      onTap: () async {
        if (widget.id == '' || isLoading) return;

        setState(() {
          isLoading = true;
        });

        var result = await CompanyService().getRelatedEntity(
          widget.entityType,
          widget.id,
          widget.relatedEntityType,
        );

        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (BuildContext context) => RelatedEntityScreen(
              entity: widget.entity,
              type: widget.relatedEntityType,
              title: widget.title,
              list: result,
              isSelectable: false,
              isEditable: widget.isEditable,
            ),
          ),
        );
      },
      icon: isLoading
          ? PsaProgressIndicator()
          : Icon(context.platformIcons.rightChevron),
    );
  }
}
