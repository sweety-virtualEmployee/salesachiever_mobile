import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/dynamic_staffzone_view_related_records.dart';
import 'package:salesachiever_mobile/shared/services/data_field_service.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class DynamicStaffZoneEditScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final bool readonly;
  final String id;
  final String relatedEntityType;
  final String tableName;
  final String title;

  const DynamicStaffZoneEditScreen({
    Key? key,
    required this.entity,
    required this.readonly,
    required this.id,
    required this.relatedEntityType,
    required this.tableName,
    required this.title,
  }) : super(key: key);

  @override
  State<DynamicStaffZoneEditScreen> createState() =>
      _DynamicStaffZoneEditScreenState();
}

class _DynamicStaffZoneEditScreenState
    extends State<DynamicStaffZoneEditScreen> {
  late bool _readonly;
  late dynamic _entity;
  late List<dynamic> activeFields;
  late List<dynamic> mandatoryFields;
  bool _isValid = false;

  static final key = GlobalKey<FormState>();

  @override
  void initState() {
    _readonly = widget.readonly;
    _entity = widget.entity;
    activeFields = [];
    mandatoryFields = [];
    if (_entity['ENTITY_ID'] == null) {
      var defaultValues = LookupService().getDefaultValues(widget.tableName);

      defaultValues.forEach((element) {
        _entity[element['FIELD_NAME']] = element['PROPERTY_VALUE'];
      });
    }
    fetchDetails();
    validate();
    super.initState();
  }

  Future<void> fetchDetails() async {
    activeFields = await DynamicProjectService()
        .getStaffZoneActiveFields(widget.tableName);
    mandatoryFields = await LookupService().getMandatoryFields();
    print("mandatoryfields$mandatoryFields");
    if (_entity['ENTITY_ID'] != null) {
      print("yes it is not null");
      if (_entity["ACCT_ID"] != null) {
        var company = await CompanyService().getEntity(_entity["ACCT_ID"]);
        if (company?.data != null) {
          var response1 = company.data;

          setState(() {
            _entity["ACCT_ID"] = response1["ACCT_ID"];
            _entity["ACCTNAME"] = response1["ACCTNAME"];
          });
        }
      } else if (_entity["PROJECT_ID"] != null) {
        var project = await ProjectService().getEntity(_entity["PROJECT_ID"]);
        if (project?.data != null) {
          var response2 = project.data;
          print("Response$response2");

          setState(() {
            _entity["PROJECT_ID"] = response2["PROJECT_ID"];
            _entity["PROJECT_TITLE"] = response2["PROJECT_TITLE"];
          });
        }
      } else if (_entity["CONT_ID"] != null) {
        var contact = await ContactService().getEntity(_entity["CONT_ID"]);

        if (contact?.data != null) {
          var response3 = contact.data;
          print("Response$response3");

          setState(() {
            _entity["CONT_ID"] = response3["CONT_ID"];
            _entity["FIRSTNAME"] = response3["FIRSTNAME"];
          });
        }
      }
    } else {
      if (widget.relatedEntityType == "COMPANY") {
        var response = await CompanyService().getEntity(widget.id);

        if (response?.data != null) {
          var company = response.data;

          setState(() {
            _entity["ACCT_ID"] = company["ACCT_ID"];
            _entity["ACCTNAME"] = company["ACCTNAME"];
          });
        }
      } else if (widget.relatedEntityType == "PROJECT") {
        var project = await ProjectService().getEntity(widget.id);

        if (project?.data != null) {
          var response2 = project.data;
          print("Response$response2");

          setState(() {
            _entity["PROJECT_ID"] = response2["PROJECT_ID"];
            _entity["PROJECT_TITLE"] = response2["PROJECT_TITLE"];
          });
        }
      }
      if (widget.relatedEntityType == "CONTACT") {
        var contact = await ContactService().getEntity(widget.id);

        if (contact?.data != null) {
          var response3 = contact.data;
          print("Response$response3");

          setState(() {
            _entity["CONT_ID"] = response3["CONT_ID"];
            _entity["FIRSTNAME"] = response3["FIRSTNAME"];
          });
        }
      }
    }
  }

  void _onChange(String key, dynamic value, bool? isRequired) {
    setState(() {
      _entity[key] = value;
    });

    print("on change entity$_entity");
    validate();
  }

  @override
  Widget build(BuildContext context) {
    print("ActiveFields$activeFields");
    print("isvalide$_isValid");
    print("_readonly$_readonly");
    var visibleFields = activeFields.where((e) => e['COLVAL']).toList();
    return PsaScaffold(
      action: PsaEditButton(
        text: _readonly ? 'Edit' : 'Save',
        onTap: onTap,
      ),
      title: "Add new ${widget.title}",
      body: Container(
        child: buildBody(visibleFields),
      ),
    );
  }

  Widget buildBody(List<dynamic> visibleFields) {
    return Column(
      children: [
        PsaHeader(
          isVisible: true,
          icon: 'assets/images/create_record_icon.png',
          title: "Add new ${widget.title}",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: DataFieldService().generateFields(
                    key,
                    widget.tableName,
                    _entity,
                    visibleFields,
                    mandatoryFields,
                    _readonly,
                    _onChange,
                  ),
                ),
                DynamicStaffZoneDataViewRelatedRecords(
                  staffZone: _entity,
                  readonly: _readonly,
                  onChange: _onChange,
                  staffZoneId: _entity["${widget.tableName}_ID"] ?? "",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void validate() {
    var isValid = DynamicProjectService().validateStaffZoneEntity(_entity);

    setState(() {
      _isValid = isValid;
    });
  }

  void onTap() async {
    if (_readonly) {
      setState(() => _readonly = !_readonly);
      return;
    }

    await saveProject();
  }

  Future<void> saveProject() async {
    try {
      context.loaderOverlay.show();

      if (_entity['ENTITY_ID'] != null) {
        await DynamicProjectService().updateStaffZoneEntity(
            _entity!['ENTITY_ID'], _entity, widget.tableName);
      } else {
        var newEntity = await DynamicProjectService()
            .addNewStaffZoneEntity(_entity, widget.tableName);
        _entity['ENTITY_ID'] = newEntity['ENTITY_ID'];
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
}
