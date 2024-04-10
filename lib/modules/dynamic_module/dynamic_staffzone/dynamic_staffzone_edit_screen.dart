import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamicPsaLooksUp.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/provider/dynamic_staffzone_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/dynamic_staffzone_pdf_signature.dart';
import 'package:salesachiever_mobile/shared/services/lookup_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_checkbox_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_county_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_datefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_dropdown_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_floatfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_multiselect_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_numberfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_related_value_record.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textareafield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_textfield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/forms/psa_timefield_row.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_header.dart';
import 'package:salesachiever_mobile/utils/decode_base64_util.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:uuid/uuid.dart';

class DynamicStaffZoneEditScreen extends StatefulWidget {
  final Map<String, dynamic> entity;
  final bool readonly;
  final bool isNew;
  final String id;
  final String relatedEntityType;
  final String tableName;
  final String title;
  final String staffZoneType;

  const DynamicStaffZoneEditScreen({
    Key? key,
    required this.entity,
    required this.readonly,
    required this.isNew,
    required this.id,
    required this.relatedEntityType,
    required this.tableName,
    required this.title,
    required this.staffZoneType,
  }) : super(key: key);

  @override
  State<DynamicStaffZoneEditScreen> createState() =>
      _DynamicStaffZoneEditScreenState();
}

class _DynamicStaffZoneEditScreenState
    extends State<DynamicStaffZoneEditScreen> {
  late bool _readonly;
  late dynamic _entity;
  String? _dir;
  late List<dynamic> activeFields;
  late List<dynamic> mandatoryFields;
  bool _isValid = false;
  List<dynamic> _imageList = [];
  bool isLoading = false;
  static final key = GlobalKey<FormState>();
  final picker = ImagePicker();
  late DynamicStaffZoneProvider _dynamicStaffZoneProvider;

  @override
  void initState() {
    super.initState();
    _dynamicStaffZoneProvider =
        Provider.of<DynamicStaffZoneProvider>(context, listen: false);
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
    _initDir();
    validate();
    super.initState();
  }

  _initDir() async {
    if (null == _dir) {
      _dir = '${(await getApplicationDocumentsDirectory()).path}/blobs';
    }

    var file = await Directory("$_dir").list().toList();
    print(file);
  }

  Future<void> fetchDetails() async {
    activeFields = await DynamicProjectService()
        .getStaffZoneActiveFields(widget.tableName);
    mandatoryFields = await LookupService().getMandatoryFields();
    if (_entity['ENTITY_ID'] != null) {
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
    validate();
  }

  onRelatedValueSave(List<dynamic> entity) {
    entity.forEach((prop) {
      setState(() {
        _entity[prop['KEY']] = prop['VALUE'];
      });
    });
    print("Efgerugvjrwi${_entity}");
  }

  Widget generateFields(
      Key key,
      String type,
      dynamic entity,
      List<dynamic> filedList,
      List<dynamic> mandatoryFields,
      bool readonly,
      Function onChange,
      [String? updatedFieldKey]) {
    List<Widget> widgets = [];
    for (dynamic field in filedList) {
      print("field of entity${field}");
      var isRequired = mandatoryFields.any((e) =>
          e['TABLE_NAME'] == field['TABLE_NAME'] &&
          e['FIELD_NAME'] == field['FIELD_NAME']);
      switch (field['FIELD_TYPE']) {
        case 'L':
          if (field['TABLE_NAME'] == 'ACCOUNT' &&
              field['FIELD_NAME'] == 'COUNTY') {
            widgets.add(
              PsaCountyDropdownRow(
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
                country: entity?['COUNTRY']?.toString() ?? '',
              ),
            );
          } else if (field['TABLE_NAME'] == 'PROJECT' &&
              field['FIELD_NAME'] == 'SITE_COUNTY') {
            print("thia");
            widgets.add(
              PsaCountyDropdownRow(
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
                country: entity?['SITE_COUNTRY']?.toString() ?? '',
              ),
            );
          } else {
            print("no");
            widgets.add(
              PsaDropdownRow(
                type: type,
                isRequired: isRequired,
                tableName: field['TABLE_NAME'],
                fieldName: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString() ?? '',
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
              ),
            );
          }
          break;
        case 'C':
          if (field["FIELD_NAME"].contains("_ID")) {
            print("field['Data${field['FIELD_NAME']}");
            widgets.add(PsaRelatedValueRow(
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              type: field['FIELD_NAME'],
              entity: _entity,
              onChange: onRelatedValueSave,
              onTap: () {},
              isVisible: true,
              isRequired: isRequired,
            ));
          } else {
            widgets.add(
              PsaTextFieldRow(
                isRequired: isRequired,
                fieldKey: field['FIELD_NAME'],
                title: LangUtil.getString(
                    field['TABLE_NAME'], field['FIELD_NAME']),
                value: entity?[field['FIELD_NAME']]?.toString(),
                keyboardType: TextInputType.text,
                readOnly: readonly ||
                    (field['DISABLED'] != null && field['DISABLED']),
                onChange: (_, __) => onChange(_, __, isRequired),
                updatedFieldKey: updatedFieldKey,
              ),
            );
          }
          break;
        case 'I':
          if (field['FIELD_TYPE'] == "I") {
            print("field name checking ${entity?[field['FIELD_NAME']]}");
            print("field name checking ${[field['FIELD_NAME']]}");
          }
          widgets.add(
            PsaNumberFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']],
              keyboardType: TextInputType.number,
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'F':
          widgets.add(
            PsaFloatFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'D':
          widgets.add(
            PsaDateFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'B':
          bool isChecked = entity?[field['FIELD_NAME']] == 'Y';
          print(
              "LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME'])${LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME'])}");
          widgets.add(
            PsaCheckBoxRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: isChecked,
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'T':
          widgets.add(
            PsaTimeFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'M':
          widgets.add(
            PsaTextAreaFieldRow(
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'U':
          widgets.add(
            DynamicPsaDropdownRow(
              type: type,
              isRequired: isRequired,
              fieldKey: field['FIELD_NAME'],
              tableName: field['LKTable'],
              fieldName: field['LKField'],
              returnField: field['LKReturn'],
              lkApi: field['LKAPI'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['FIELD_NAME']]?.toString() ?? '',
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'V':
          widgets.add(
            PsaMultiSelectRow(
              type: type,
              isRequired: isRequired,
              tableName: field['TABLE_NAME'],
              fieldName: field['FIELD_NAME'],
              selectedValue: field['Data_Value'],
              title:
                  LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
              value: entity?[field['Data_Value']]?.toString() ?? '',
              readOnly:
                  readonly || (field['DISABLED'] != null && field['DISABLED']),
              onChange: (_, __) => onChange(_, __, isRequired),
            ),
          );
          break;
        case 'Z':
          widgets.add(PsaRelatedValueRow(
            title: LangUtil.getString(field['TABLE_NAME'], field['FIELD_NAME']),
            value: field['Data_Value'],
            type: field['FIELD_NAME'],
            entity: field,
            onChange: onRelatedValueSave,
            onTap: () {},
            isVisible: true,
          ));
      }
    }
    return CupertinoFormSection(
      key: key,
      children: widgets.length > 0 ? widgets : [Container()],
    );
  }

  @override
  Widget build(BuildContext context) {
    var visibleFields = activeFields.where((e) => e['COLVAL']).toList();
    return PsaScaffold(
      action: widget.isNew
          ? Row(
              children: [
                _entity['ENTITY_ID'] != null
                    ? GestureDetector(
                        child: PsaEditButton(
                          text: 'Upload',
                          onTap: addImage,
                        ),
                      )
                    : SizedBox(),
                _entity['ENTITY_ID'] != null
                    ? GestureDetector(
                        child: PsaEditButton(
                          text: 'Print',
                          onTap: () async {
                            try {
                              print("staffzonetype${widget.staffZoneType.split('/List/')[1].substring(0, 2)}");
                              context.loaderOverlay.show();
                              dynamic value = await DynamicProjectService()
                                  .getStaffZoneSubScribedReports(
                                  widget.staffZoneType.split('/List/')[1].substring(0, 2));
                              dynamic encodedString =
                                  await DynamicProjectService()
                                      .getStaffZoneGeneratedReports(
                                          value[0]["ID"],
                                          value[0]["Title"],
                                          _entity['ENTITY_ID']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DynamicSignatureViewerPage(
                                    base64String: encodedString,
                                    entityId:  _entity['ENTITY_ID'],
                                  tableName: widget.tableName,relatedEntityType: widget.relatedEntityType,id: widget.id,staffZoneType: widget.staffZoneType,),
                                ),
                              );
                            } on DioError catch (e) {
                              ErrorUtil.showErrorMessage(context, e.message);
                            } catch (e) {
                              ErrorUtil.showErrorMessage(
                                  context, MessageUtil.getMessage('500'));
                            } finally {
                              context.loaderOverlay.hide();
                            }
                          },
                        ),
                      )
                    : SizedBox(),
                PsaEditButton(
                  text: _readonly ? 'Edit' : 'Save',
                  onTap: onTap,
                ),
              ],
            )
          : SizedBox(),
      title: _entity['ENTITY_ID'] != null
          ? "${widget.title}"
          : "Add new ${widget.title}",
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
          title: _entity['ENTITY_ID'] != null
              ? "${widget.title}"
              : "Add new ${widget.title}",
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: generateFields(
                    key,
                    widget.tableName,
                    _entity,
                    visibleFields,
                    mandatoryFields,
                    _readonly,
                    _onChange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future addImage() async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Add Documents'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Choose from Document'),
            onPressed: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.any);
              setState(() {
                if (result != null) {
                  setState(() {
                    isLoading = false;
                    _imageList.insert(0, {
                      'FILE': File(result.files.single.path!),
                      'ISNEW': true,
                      'ISUPDATED': false,
                      'DESCRIPTION': 'new document'
                    });
                  });
                  uploadImages();
                } else {
                  print('No document selected.');
                }
              });
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Choose Image from Gallery'),
            onPressed: () async {
              Navigator.pop(context);

              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

              setState(() {
                if (pickedFile != null) {
                  setState(() {
                    isLoading = false;
                    _imageList.insert(0, {
                      'FILE': File(pickedFile.path),
                      'ISNEW': true,
                      'ISUPDATED': false,
                      'DESCRIPTION': 'new img'
                    });
                  });
                  uploadImages();
                } else {
                  print('No image selected.');
                }
              });
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Take Photo'),
            onPressed: () async {
              Navigator.pop(context);

              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);

              setState(() {
                if (pickedFile != null) {
                  setState(() {
                    isLoading = false;
                    _imageList.insert(0, {
                      'FILE': File(pickedFile.path),
                      'ISNEW': true,
                      'ISUPDATED': false,
                      'DESCRIPTION': 'new img'
                    });
                  });
                } else {
                  print('No image selected.');
                }
              });
            },
          )
        ],
      ),
    );
  }

  Future uploadImages() async {
    try {
      String fieldName = "";
      await Future.forEach(_imageList, (dynamic image) async {
        print(image?["FILE"]);
        var uuid = Uuid().v1().toUpperCase();
        print("dir$_dir");
        var encoder = ZipFileEncoder();
        encoder.create('$_dir/$uuid.zip');
        encoder.addFile((image as Map<String, dynamic>)['FILE']!);
        encoder.close();
        print(encoder);
        var bytes = File('$_dir/$uuid.zip').readAsBytesSync();
        print("bytes");
        String base64Image = base64Encode(bytes);
        print("base64image$base64Image");
        var blob = {
          'DESCRIPTION': (image as Map<String, dynamic>)['DESCRIPTION'],
          'ENTITY_ID': _entity['ENTITY_ID'],
          'ENTITY_NAME': widget.tableName,
          'FILENAME': '${_entity['ENTITY_ID']}' '$uuid' '',
          'BLOB_DATA': base64Image,
        };
        print("Blob data: ${blob.toString()}");
        await SitePhotoService().uploadBlob(blob);
        File('$_dir/$uuid.zip').deleteSync();
      });

      if (widget.relatedEntityType == "COMPANY") {
        fieldName = "ACCT_ID";
      } else if (widget.relatedEntityType == "PROJECT") {
        fieldName = "PROJECT_ID";
      } else if (widget.relatedEntityType == "CONTACT") {
        fieldName = "CONT_ID";
      }

      var result = await DynamicProjectService().getStaffZoneEntity(
          widget.tableName, fieldName, widget.staffZoneType, widget.id,1,
      );

      await _dynamicStaffZoneProvider.setStaffZoneEntity(result);
      Navigator.pop(context);
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }

    void validate() {
    var isValid = DynamicProjectService().validateStaffZoneEntity(_entity);

    setState(() {
      _isValid = isValid;
    });
  }

  void onTap() async {
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
        setState(() {
          _entity['ENTITY_ID'] = newEntity['ENTITY_ID'];
        });
      }
      print("_entity$_entity");
    } on DioError catch (e) {
      ErrorUtil.showErrorMessage(context, e.message);
    } catch (e) {
      ErrorUtil.showErrorMessage(context, MessageUtil.getMessage('500'));
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
