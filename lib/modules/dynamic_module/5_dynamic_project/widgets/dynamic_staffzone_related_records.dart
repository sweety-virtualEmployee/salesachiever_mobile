import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/associated_entity_widget.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/dynamic_staffzone_list_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_button_row.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicStaffZoneViewRelatedRecords extends StatefulWidget {
  const DynamicStaffZoneViewRelatedRecords({
    Key? key,
    required this.entity,
    required this.id,
    required this.relatedEntityType,
    required this.isEditable,
  }) : super(key: key);

  final dynamic entity;
  final String id;
  final String relatedEntityType;
  final bool isEditable;
  @override
  State<DynamicStaffZoneViewRelatedRecords> createState() => _DynamicStaffZoneViewRelatedRecordsState();
}

class _DynamicStaffZoneViewRelatedRecordsState extends State<DynamicStaffZoneViewRelatedRecords> {
  
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      backgroundColor: const Color(0xFFFAFAFA),
      header: Text(''),
      children: [
        PsaButtonRow(
            isVisible: false,
            title: LangUtil.getString(
              'Entities',
              'RateAgreement.Description',
            ),
            icon: Icon(context.platformIcons.rightChevron),
            onTap: () async {
              print("yes${widget.id}");
              if (widget.id == '' || isLoading) return;
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneListScreen(
                    relatedEntityType: widget.relatedEntityType,
                    staffZoneType: "RATE_AGREEMENT",
                    id: widget.id,
                  ),
                ),
              );
            }),
       /* AssociatedEntityWidget(
            isRequired: false,
            title: LangUtil.getString(
              'Entities',
              'RateAgreement.Label',
            ),
            entity: {},
            onTap: () async {
              var rateAgreement = await DynamicProjectService()
                  .getStaffZoneEntity(widget.relatedEntityType, "RateAgreements", "id");
              print("rateAgreement $rateAgreement");

              await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneListScreen(
                    relatedEntityType: widget.relatedEntityType,
                    staffZoneType: "RentAgreement",
                    id: widget.id,
                  ),
                ),
              );
            }),
        AssociatedEntityWidget(
            isRequired: false,
            title: LangUtil.getString(
              'Entities',
              'JobOrder.Description',
            ),
            entity: {},
            onTap: () async {
              var jobOrders = await DynamicProjectService()
                  .getStaffZoneEntity(widget.relatedEntityType, "JobOrders", "id");
              print("Job Orders $jobOrders");

              await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneListScreen(
                    relatedEntityType: widget.relatedEntityType,
                    staffZoneType: "RentAgreement",
                    id: widget.id,
                  ),
                ),
              );
            }),
        AssociatedEntityWidget(
            isRequired: false,
            title: LangUtil.getString(
              'Entities',
              'ISV.Description',
            ),
            entity: {},
            onTap: () async {
              var isv = await DynamicProjectService()
                  .getStaffZoneEntity(widget.relatedEntityType, "ISV", "id");
              print("isv $isv");

              await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneListScreen(
                    relatedEntityType: widget.relatedEntityType,
                    staffZoneType: "RentAgreement",
                    id: widget.id,
                  ),
                ),
              );
            }),
        AssociatedEntityWidget(
            isRequired: false,
            title: LangUtil.getString(
              'Entities',
              'InitialOrderPhoneCall.Description',
            ),
            entity: {},
            onTap: () async {
              var initialOrder = await DynamicProjectService()
                  .getStaffZoneEntity(widget.relatedEntityType, "InitialOrder", "id");
              print("InitialOrder $initialOrder");

              await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneListScreen(
                    relatedEntityType: widget.relatedEntityType,
                    staffZoneType: "RentAgreement",
                    id: widget.id,
                  ),
                ),
              );
            }),
        AssociatedEntityWidget(
            isRequired: false,
            title: LangUtil.getString(
              'Entities',
              'AccidentRecord.Description',
            ),
            entity: {},
            onTap: () async {
              var accidentRecords = await DynamicProjectService()
                  .getStaffZoneEntity(widget.relatedEntityType, "AccidentRecords", "id");
              print("AccidentRecords $accidentRecords");

              await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneListScreen(
                      relatedEntityType: widget.relatedEntityType,
                      staffZoneType: "RentAgreement",
                      id: widget.id,
                  ),
                ),
              );
            }),*/
      ],
    );
  }
}
