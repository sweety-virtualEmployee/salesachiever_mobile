import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';

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
import 'package:salesachiever_mobile/utils/dormant_util.dart';
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
  final bool isSelectable;

  const DynamicStaffZoneListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.staffZoneType,
    required this.id,
    required this.relatedEntityType,
    required this.title,
    required this.tableName,
    this.isSelectable = false,
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
  List<dynamic> _sortBy = [];
  List<dynamic> _filterBy = [];
  String _searchText = '';
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sortBy = widget.sortBy ?? [];
    _filterBy = widget.filterBy ?? [];
    _dynamicStaffZoneProvider =
        Provider.of<DynamicStaffZoneProvider>(context, listen: false);
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
    _dynamicStaffZoneProvider
        .clearData(); // Implement this method in your provider
    super.dispose();
  }

  void _loadNextPage() async {
    if (_dynamicStaffZoneProvider.getIsLastPage == false) {
      _dynamicStaffZoneProvider
          .setPageNumber(_dynamicStaffZoneProvider.getPageNumber + 1);
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
          widget.id,
          _dynamicStaffZoneProvider.getPageNumber,
          _searchText,
          _sortBy,
          _filterBy);
      _dynamicStaffZoneProvider.setStaffZoneEntity(result["Items"]);
      _dynamicStaffZoneProvider.setIsLastPage(result["IsLastPage"]);
      _dynamicStaffZoneProvider.setPageNumber(result["PageNumber"]);
    }
  }

  fetchData() async {
    _dynamicStaffZoneProvider.clearData();
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
          widget.id,
          1,
          _searchText,
          _sortBy,
          _filterBy);
      print(result["Items"]);
      _dynamicStaffZoneProvider.setIsLoading(false);
      _dynamicStaffZoneProvider.setStaffZoneEntity(result["Items"]);
      _dynamicStaffZoneProvider.setIsLastPage(result["IsLastPage"]);
      _dynamicStaffZoneProvider.setPageNumber(result["PageNumber"]);
    } catch (e) {
      setState(() {
        _dynamicStaffZoneProvider.setIsLoading(false);
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: "${capitalizeFirstLetter(widget.title)} - List",
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CupertinoTextField(
                    controller: _textEditingController,
                    autocorrect: false,
                    placeholder: LangUtil.getString('Entities', 'List.Search'),
                    onSubmitted: (value) {
                      setState(() {
                        _searchText = value;
                      });
                      fetchData();
                    },
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: adds rounded corners
                    ),
                    style: TextStyle(
                      color: Colors.black, // Text color
                    ),
                    placeholderStyle: TextStyle(
                      color: Colors.grey, // Placeholder text color (optional)
                    ),
                    prefix: Icon(context.platformIcons.search),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _searchText = value;
                        });
                        fetchData();
                      }
                    },
                    textInputAction: TextInputAction.search,
                    clearButtonMode: OverlayVisibilityMode
                        .never, // Disable default clear button
                  ),
                  if (_textEditingController.text.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _textEditingController.clear();
                          setState(() {
                            _searchText = '';
                          });
                          fetchData();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            CupertinoIcons.clear_thick_circled,
                            color:
                                Colors.blueAccent, // Custom clear button color
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.02),
              ),
              child: Column(
                children: [
                  ListAction(
                    title:
                        LangUtil.getString('List', 'ListFilter.SortBy.Label'),
                    selectedCount: _sortBy.length ?? 0,
                    onTap: () async {
                      final updatedSortBy = await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) =>
                              SelectedStaffZoneSortFieldsScreen(
                            title: LangUtil.getString(
                                'List', 'ListFilter.SortBy.Label'),
                            tableName: widget.tableName,
                            relatedEntityType: widget.relatedEntityType,
                            sortBy: _sortBy,
                            staffZoneType: widget.staffZoneType,
                            staffZoneListTitle: widget.title,
                            id: widget.id,
                          ),
                        ),
                      );
                      setState(() {
                        _sortBy = updatedSortBy ?? _sortBy;
                      });
                      fetchData();
                    },
                  ),
                  Divider(
                    color: Colors.white,
                    height: 2,
                  ),
                  ListAction(
                    title:
                        LangUtil.getString('List', 'ListFilter.FilterBy.Label'),
                    selectedCount: _filterBy.length ?? 0,
                    onTap: () async {
                      final updatedFilterKey = await Navigator.push(
                        context,
                        platformPageRoute(
                          context: context,
                          builder: (BuildContext context) =>
                              SelectedStaffZoneFilterFieldsScreen(
                            title: LangUtil.getString(
                                'List', 'ListFilter.FilterBy.Label'),
                            tableName: widget.tableName,
                            relatedEntityType: widget.relatedEntityType,
                            sortBy: _sortBy,
                            staffZoneType: widget.staffZoneType,
                            staffZoneListTitle: widget.title,
                            id: widget.id,
                            filterBy: _filterBy,
                          ),
                        ),
                      );
                      setState(() {
                        _filterBy = updatedFilterKey ?? _filterBy;
                      });
                      fetchData();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<DynamicStaffZoneProvider>(
                builder: (context, provider, child) {
                  if (provider.getIsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (provider.getStaffZoneEntity.isEmpty) {
                    return Center(child: Text("No data available"));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: provider.getStaffZoneEntity.length,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      itemBuilder: (context, index) {
                        var item = provider.getStaffZoneEntity[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onLongPress: () {
                                      print("yes on long press");
                                      DormantUtil.showDormantMessage(context,
                                              () => onDormant(item["ENTITY_ID"],"Y"));
                                    },
                                    onTap: () async {
                                      if (widget.isSelectable) {
                                        Navigator.pop(context, {
                                          'ID': item['ENTITY_ID'],
                                          'TEXT': item['DESCRIPTION'],
                                          'DATA': item,
                                        });
                                        return;
                                      }
                                      if (item['HAS_LINK_DOCUMENT'] == "Y") {
                                        CopyUtil.showCopyMessage(context,
                                            () => onCopy(item["ENTITY_ID"]));
                                      } else {
                                        var result =
                                            await DynamicProjectService()
                                                .getStaffZoneEntity(
                                                    widget.tableName,
                                                    "ENTITY_ID",
                                                    widget.staffZoneType,
                                                    provider.getStaffZoneEntity[
                                                        index]["ENTITY_ID"],
                                                    1,
                                                    _searchText,
                                                    _sortBy,
                                                    _filterBy);
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
                                              relatedEntityType:
                                                  widget.relatedEntityType,
                                              tableName: widget.tableName,
                                              title: widget.title,
                                              staffZoneType:
                                                  widget.staffZoneType,
                                              sortBy: _sortBy,
                                              filterBy: _filterBy,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                '${item['ACCTNAME'] ?? item['ACCT_NAME'] ?? ''}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${item['PROJECT_TITLE'] ?? ''}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                "Submitted By: ${item['SUBMITTED_BY'] ?? ''}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Submitted On: ${DateUtil.getFormattedDate(item['SUBMITTED_ON'] ?? '')}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                item['HAS_LINK_DOCUMENT'] == "Y"
                                    ? SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: InkWell(
                                          onTap: () async {
                                            context.loaderOverlay.show();
                                            SitePhotoService()
                                                .getBlobById(item[
                                                    'LINK_DOCUMENT_BLOB_ID'])
                                                .then((blob) async {
                                              try {
                                                var decodedBytes = base64
                                                    .decode(blob.replaceAll(
                                                        '\r\n', ''));
                                                final archive = ZipDecoder()
                                                    .decodeBytes(decodedBytes);
                                                File? outFile;

                                                for (var file in archive) {
                                                  final directory =
                                                      await getApplicationDocumentsDirectory();
                                                  final filePath =
                                                      '${directory.path}/file.pdf';
                                                  var fileName =
                                                      '${directory.path}/${item['LINK_DOCUMENT_BLOB_ID']}';

                                                  final pdfFile =
                                                      File(filePath);
                                                  await pdfFile.writeAsBytes(
                                                      file.content);
                                                  if (_imageList.isEmpty) {
                                                    _imageList.add({});
                                                  }
                                                  setState(() {
                                                    _imageList[0]['FILEPATH'] =
                                                        filePath;
                                                    _imageList[0]['FILENAME'] =
                                                        archive.toString();
                                                  });
                                                  if (file.isFile) {
                                                    outFile = File(fileName);
                                                    outFile =
                                                        await outFile.create(
                                                            recursive: true);
                                                    await outFile.writeAsBytes(
                                                        file.content);
                                                  }
                                                }

                                                if (outFile != null) {
                                                  setState(() {
                                                    _imageList[0]['FILE'] =
                                                        outFile;
                                                    _imageList[0]['FILENAME'] =
                                                        archive.toString();
                                                  });

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DynamicPhotoPreview(
                                                              photo: _imageList[
                                                                  0]),
                                                    ),
                                                  );
                                                }
                                              } catch (error) {
                                                ErrorUtil.showErrorMessage(
                                                    context,
                                                    MessageUtil.getMessage(
                                                        '500'));
                                              } finally {
                                                context.loaderOverlay.hide();
                                              }
                                            });
                                          },
                                          child: Image.asset(
                                            "assets/images/pdf_icon.png",
                                          ),
                                        ),
                                      )
                                    : SizedBox(width: 5),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(color: Colors.black26),
                            SizedBox(height: 15),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        action: widget.isSelectable
            ? SizedBox()
            : PsaAddButton(onTap: () async {
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) =>
                        DynamicStaffZoneEditScreen(
                      entity: {},
                      readonly: false,
                      id: widget.id,
                      isNew: true,
                      relatedEntityType: widget.relatedEntityType,
                      tableName: widget.tableName,
                      title: widget.title,
                      staffZoneType: widget.staffZoneType,
                      sortBy: _sortBy,
                      filterBy: _filterBy,
                    ),
                  ),
                );
              }));
  }

  Future<void> onCopy(String entityId) async {
    var newEntity = await DynamicProjectService()
        .copyNewStaffZoneEntity(widget.tableName, entityId);
    print("newEntity$newEntity");
    fetchData();
  }


  Future<void> onDormant(String entityId,String dormant) async {
    print("entity$entityId");
    var dormantEntity =  await DynamicProjectService().toggleDormantEntity(
        widget.tableName,entityId);
    print("newEntity$dormantEntity");
    fetchData();
  }
}
