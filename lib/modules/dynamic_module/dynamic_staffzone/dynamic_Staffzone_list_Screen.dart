import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/99_50021_site_photos/services/site_photo_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view_no_filter.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/dynamic_staffzone_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/provider/dynamic_staffzone_provider.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/selected_staffzone_filter_fields_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/selected_staffzone_sort_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/dynamic_staffzone/widgets/dynamic_photo_preview_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/copy_util.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicStaffZoneListScreen extends StatefulWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String staffZoneType;
  final String id;
  final String relatedEntityType;
  final String title;
  final String tableName;

  const DynamicStaffZoneListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.staffZoneType,
    required this.id,
    required this.relatedEntityType,
    required this.title,
    required this.tableName,
  }) : super(key: key);

  @override
  _DynamicStaffZoneListScreenState createState() =>
      _DynamicStaffZoneListScreenState();
}

class _DynamicStaffZoneListScreenState
    extends State<DynamicStaffZoneListScreen> {
  List<dynamic> _imageList = [];
  late DynamicStaffZoneProvider _dynamicStaffZoneProvider;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    _dynamicStaffZoneProvider = Provider.of<DynamicStaffZoneProvider>(context, listen: false);
    _dynamicStaffZoneProvider.clearData();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _dynamicStaffZoneProvider.clearData(); // Implement this method in your provider
    super.dispose();
  }

  void _loadNextPage() async {
    if (_dynamicStaffZoneProvider.getIsLastPage == false) {
      _dynamicStaffZoneProvider.setPageNumber(_dynamicStaffZoneProvider.getPageNumber + 1);
      String fieldName = "";
      if (widget.relatedEntityType == "COMPANY") {
        fieldName = "ACCT_ID";
      } else if (widget.relatedEntityType == "PROJECT") {
        fieldName = "PROJECT_ID";
      } else if (widget.relatedEntityType == "CONTACT") {
        fieldName = "CONT_ID";
      }
      var result = await DynamicProjectService().getStaffZoneEntity(
          widget.tableName,
          fieldName,
          widget.staffZoneType,
          widget.id,_dynamicStaffZoneProvider.getPageNumber,
          widget.sortBy);
      print("result$result");
      print("_dynamic${_dynamicStaffZoneProvider.getStaffZoneEntity!.length}");
      _dynamicStaffZoneProvider.setStaffZoneEntity(result["Items"]);
      _dynamicStaffZoneProvider.setIsLastPage(result["IsLastPage"]);
      _dynamicStaffZoneProvider.setPageNumber(result["PageNumber"]);
      print("_dynamic${_dynamicStaffZoneProvider.getStaffZoneEntity!.length}");
    }
  }

  fetchData() async {
    _dynamicStaffZoneProvider.setIsLoading(true);
    try {
      String fieldName = "";
      if (widget.relatedEntityType == "COMPANY") {
        fieldName = "ACCT_ID";
      } else if (widget.relatedEntityType == "PROJECT") {
        fieldName = "PROJECT_ID";
      } else if (widget.relatedEntityType == "CONTACT") {
        fieldName = "CONT_ID";
      }
      var result = await DynamicProjectService().getStaffZoneEntity(
          widget.tableName,
          fieldName,
          widget.staffZoneType,
          widget.id,1,
          widget.sortBy);
      print("result$result");
      print("_dynamic${_dynamicStaffZoneProvider.getStaffZoneEntity!.length}");
      _dynamicStaffZoneProvider.setIsLoading(false);
      _dynamicStaffZoneProvider.setStaffZoneEntity(result["Items"]);
      _dynamicStaffZoneProvider.setIsLastPage(result["IsLastPage"]);
      _dynamicStaffZoneProvider.setPageNumber(result["PageNumber"]);
      print("_dynamic${_dynamicStaffZoneProvider.getStaffZoneEntity!.length}");
    } catch (e) {
      setState(() {
        _dynamicStaffZoneProvider.setIsLoading(false);
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicStaffZoneProvider>(builder: (context, provider, child) {
        return PsaScaffold(
            title: "${capitalizeFirstLetter(widget.title)} - List",
            body: provider.getIsLoading
                ? Center(child: CircularProgressIndicator())
                : provider.getStaffZoneEntity.isEmpty
                    ? Center(child: Text("No data available"))
                    : Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListAction(
                                title:
                                LangUtil.getString('List', 'ListFilter.SortBy.Label'),
                                selectedCount: widget.sortBy?.length ?? 0,
                                onTap: () => Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SelectedStaffZoneSortFieldsScreen(
                                          title: LangUtil.getString(
                                              'List', 'ListFilter.SortBy.Label'),
                                          tableName: widget.tableName,
                                          relatedEntityType:widget.relatedEntityType,
                                          sortBy: widget.sortBy,
                                          staffZoneType: widget.staffZoneType,
                                          staffZoneListTitle:widget.title,
                                          id: widget.id,
                                        ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                height: 2,
                              ),
                              ListAction(
                                title:
                                LangUtil.getString('List', 'ListFilter.FilterBy.Label'),
                                selectedCount: widget.filterBy?.length ?? 0,
                                onTap: () => Navigator.push(
                                  context,
                                  platformPageRoute(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        SelectedStaffZoneFilterFieldsScreen(
                                          title: LangUtil.getString(
                                              'List', 'ListFilter.FilterBy.Label'),
                                          tableName: widget.tableName,
                                          relatedEntityType:widget.relatedEntityType,
                                          sortBy: widget.sortBy,
                                          staffZoneType: widget.staffZoneType,
                                          staffZoneListTitle:widget.title,
                                          id: widget.id,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: provider.getStaffZoneEntity.length,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              itemBuilder: (context, index) {
                                var item = provider.getStaffZoneEntity[index];
                                return GestureDetector(
                                  onTap: () async {
                                    if(item['HAS_LINK_DOCUMENT'] == "Y"){
                                      CopyUtil.showCopyMessage(context, () => onCopy(item["ENTITY_ID"]));
                                    }
                                    else{
                                    var result = await DynamicProjectService()
                                        .getStaffZoneEntity(
                                            widget.tableName,
                                            "ENTITY_ID",
                                            widget.staffZoneType,
                                            provider.getStaffZoneEntity[index]["ENTITY_ID"],_dynamicStaffZoneProvider.getPageNumber,
                                            widget.sortBy);
                                    Navigator.push(
                                      context,
                                      platformPageRoute(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            DynamicStaffZoneEditScreen(
                                          entity: result["Items"][0],
                                          isNew: false,
                                          readonly: true,
                                          id: widget.id,
                                          relatedEntityType: widget.relatedEntityType,
                                          tableName: widget.tableName,
                                          title: widget.title,
                                              staffZoneType:widget.staffZoneType,
                                        ),
                                      ),
                                    );
                                  }},
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                PlatformText(
                                                  '${item['DESCRIPTION'] ?? ''}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                                PlatformText(
                                                  "Submitted By: ${item['SUBMITTED_BY'] ?? ''}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                                PlatformText(
                                                  "Submitted On: ${DateUtil.getFormattedDate(item['SUBMITTED_ON'] ?? '')}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          if (item['HAS_LINK_DOCUMENT'] == "Y")
                                            InkWell(
                                              onTap: () async {
                                                context.loaderOverlay.show();
                          
                                                SitePhotoService()
                                                    .getBlobById(
                                                        item['LINK_DOCUMENT_BLOB_ID'])
                                                    .then((blob) async {
                                                  try {
                                                    print("blob chekcing$blob");
                                                    var decodedBytes = base64.decode(
                                                        blob.replaceAll('\r\n', ''));
                                                    print("decode bytes$decodedBytes");
                                                    final archive = ZipDecoder()
                                                        .decodeBytes(decodedBytes);
                                                    print("archive$archive");
                                                    File? outFile;
                          
                          
                                                    for (var file in archive) {
                                                      final directory =
                                                          await getApplicationDocumentsDirectory();
                                                      final filePath =
                                                          '${directory.path}/file.pdf';
                                                      var fileName =
                                                          '${directory.path}/${item['LINK_DOCUMENT_BLOB_ID']}';
                          
                                                      final pdfFile = File(filePath);
                                                      await pdfFile
                                                          .writeAsBytes(file.content);
                                                      if (_imageList.length == 0) {
                                                        _imageList.add({});
                                                      }
                                                      print("filepath$filePath");
                                                      setState(() {
                                                        _imageList[0]['FILEPATH'] =
                                                            filePath;
                                                        _imageList[0]['FILENAME'] =
                                                            archive.toString();
                                                      });
                                                      if (file.isFile) {
                                                        outFile = File(fileName);
                                                        outFile = await outFile.create(
                                                            recursive: true);
                                                        await outFile
                                                            .writeAsBytes(file.content);
                                                      }
                                                    }
                                                    print("check the output file");
                                                    print(outFile);
                          
                                                    if (outFile != null) {
                                                      setState(() {
                                                        _imageList[0]['FILE'] = outFile;
                                                        _imageList[0]['FILENAME'] =
                                                            archive.toString();
                                                      });
                          
                                                      print("ImageList$_imageList");
                          
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DynamicPhotoPreview(
                                                                  photo: _imageList[0]),
                                                        ),
                                                      );
                                                    }
                                                  } catch (error) {
                                                    ErrorUtil.showErrorMessage(context,
                                                        MessageUtil.getMessage('500'));
                                                  } finally {
                                                    context.loaderOverlay.hide();
                                                  }
                                                });
                                              },
                                              child: SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Image.asset(
                                                  "assets/images/pdf_icon.png",
                                                ),
                                              ),
                                            )
                                          else
                                            SizedBox(width: 40,),
                                          SizedBox(width: 5)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        color: Colors.black26,
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ),
                      ],
                    ),
            action: PsaAddButton(onTap: () async {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (BuildContext context) => DynamicStaffZoneEditScreen(
                    entity: {},
                    readonly: false,
                    id: widget.id,
                    isNew: true,
                    relatedEntityType: widget.relatedEntityType,
                    tableName: widget.tableName,
                    title: widget.title,
                    staffZoneType: widget.staffZoneType,
                  ),
                ),
              );
            }));
      }
    );
  }

  Future<void> onCopy(String entityId) async {
     var newEntity = await DynamicProjectService()
         .copyNewStaffZoneEntity(widget.tableName, entityId);
     print("newEntity$newEntity");
     _dynamicStaffZoneProvider.clearData();
     fetchData();
   }
}
