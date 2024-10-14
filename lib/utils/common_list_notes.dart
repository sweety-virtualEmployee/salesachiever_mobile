import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/common_notes_edit_screen.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';

class CommonListNotes extends StatefulWidget {
  final String entityType;
  final String entityId;

  const CommonListNotes({
    Key? key,
    required this.entityType,
    required this.entityId,
  }) : super(key: key);

  @override
  State<CommonListNotes> createState() => _CommonListNotesState();
}

class _CommonListNotesState extends State<CommonListNotes> {
  final _scrollController = ScrollController();
  List<dynamic> listDataValue = [];
  bool isLastPage = false;
  int pageNumber = 1;

  late Future<List<dynamic>> futureNote;

  Future<List<dynamic>> _fetchData() async {
    return await DynamicProjectService().getEntityNote(widget.entityType,widget.entityId);
  }

  @override
  void initState() {
    futureNote = _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: "Notes",
      action: PsaAddButton(
        onTap: () async {
          var updatedNote = await Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (BuildContext context) => CommonNoteEditScreen(
                entityType: widget.entityType,
                entityId: widget.entityId, notes: {},
                readonly: false,
              ),
            ),
          );
          if (updatedNote != null) {
            setState(() {
              int updateIndex = listDataValue.indexWhere((note) => note['NOTE_ID'] == updatedNote['NOTE_ID']);
              if (updateIndex != -1) {
                listDataValue[updateIndex] = updatedNote; // Update the note if it already exists
              } else {
                listDataValue.add(updatedNote); // Add the new note if it doesn't exist
              }
            });
          }
        },
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: futureNote,
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else if (snapshot.hasData) {
                listDataValue = snapshot.data!;
                listDataValue.sort((a, b) {
                  // Parse the dates and times
                  DateTime dateTimeA = DateTime.parse(a['CREATED_ON'] ?? '');
                  DateTime dateTimeB = DateTime.parse(b['CREATED_ON'] ?? '');
                  // Compare the dates
                  int dateComparison = dateTimeB.year.compareTo(dateTimeA.year);
                  if (dateComparison == 0) {
                    dateComparison = dateTimeB.month.compareTo(dateTimeA.month);
                    if (dateComparison == 0) {
                      dateComparison = dateTimeB.day.compareTo(dateTimeA.day);
                      if (dateComparison == 0) {
                        // If dates are equal, compare the times
                        dateComparison = dateTimeB.hour.compareTo(dateTimeA.hour);
                        if (dateComparison == 0) {
                          dateComparison = dateTimeB.minute.compareTo(dateTimeA.minute);
                          if (dateComparison == 0) {
                            dateComparison = dateTimeB.second.compareTo(dateTimeA.second);
                          }
                        }
                      }
                    }
                  }
                  return dateComparison;
                });
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            var updatedNote = await Navigator.push(
                              context,
                              platformPageRoute(
                                context: context,
                                builder: (BuildContext context) => CommonNoteEditScreen(
                                  notes: listDataValue[index],
                                  readonly: true,
                                  entityType: widget.entityType,
                                  entityId: widget.entityId,
                                ),
                              ),
                            );
                            if (updatedNote != null) {
                              setState(() {
                                int updateIndex = listDataValue.indexWhere((note) => note['NOTE_ID'] == updatedNote['NOTE_ID']);
                                if (updateIndex != -1) {
                                  listDataValue[updateIndex] = updatedNote; // Update the note if it already exists
                                } else {
                                  listDataValue.add(updatedNote); // Add the new note if it doesn't exist
                                }
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: PlatformText(
                                  "Description: ${listDataValue[index]['DESCRIPTION']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: PlatformText(
                                  "Created On: ${DateUtil.getFormattedDate(listDataValue[index]['CREATED_ON'] ?? '')} ${DateUtil.getFormattedTime(listDataValue[index]['CREATED_ON'] ?? '')}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: PlatformText(
                                  "Notes Creator: ${listDataValue[index]['SAUSER_ID']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: listDataValue.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black26,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                );
              } else {
                // Show a message when no data is available
                return Expanded(
                  child: Center(
                    child: Text('No data available'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
