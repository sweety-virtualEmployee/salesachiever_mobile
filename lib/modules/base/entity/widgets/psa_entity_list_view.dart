import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/base/entity/models/entity_list_stream.dart';
import 'package:salesachiever_mobile/shared/screens/filtering/slected_filter_fields_screen.dart';
import 'package:salesachiever_mobile/shared/screens/sorting/slected_sort_fields_screen.dart';
import 'package:salesachiever_mobile/modules/base/entity/services/entity_service.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/error_view.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

typedef Widget DisplayType(
    {required final dynamic entity, required final Function refresh});

class PsaEntityListView extends StatefulWidget {
  final DisplayType display;
  final EntityService service;
  final String type;
  final String list;
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final bool hideSortFilter;

  const PsaEntityListView(
      {Key? key,
      required this.display,
      required this.service,
      required this.type,
      required this.list,
      this.sortBy,
      this.filterBy,
      this.hideSortFilter = false})
      : super(key: key);

  @override
  _PsaEntityListViewState createState() => _PsaEntityListViewState();
}

class _PsaEntityListViewState extends State<PsaEntityListView> {
  final scrollController = ScrollController();
  late EntityListStream entityList;
  String _searchText = '';
  late EntityService entityService;

  @override
  void initState() {
    print("entity service${this.widget.service}");
    _searchText = '%25';
    entityService = this.widget.service;
    entityList = EntityListStream(
        entityService, _searchText, this.widget.sortBy, this.widget.filterBy);
    print("entity service${this.widget.service}");
    print("entity list value${this.widget.sortBy}");
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent <
          scrollController.offset + 5000) {
        entityList.loadMore(
            searchText: _searchText,
            sortBy: this.widget.sortBy,
            filterBy: this.widget.filterBy);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              autocorrect: false,
              placeholder: LangUtil.getString('Entities', 'List.Search'),
              onSubmitted: (value) {
                print("submitted");
                setState(() {
                  _searchText = value;
                });
                entityList.search(_searchText);
              },
              prefix: Icon(context.platformIcons.search),
              onChanged: (value) {
                print("yes");
                if (value.isEmpty) {
                  setState(() {
                    _searchText = value;
                  });
                  entityList.search(_searchText);
                }
                //entityList.filter(value);
                print("entityList$entityList");
              },
              textInputAction: TextInputAction.search,
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          if (!widget.hideSortFilter)
            Container(
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
                            SelectedSortFieldsScreen(
                          title: LangUtil.getString(
                              'List', 'ListFilter.SortBy.Label'),
                          type: widget.type,
                          sortBy: widget.sortBy,
                          list: widget.list,
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
                            SelectedFilterFieldsScreen(
                          title: LangUtil.getString(
                              'List', 'ListFilter.FilterBy.Label'),
                          type: widget.type,
                          filterBy: widget.filterBy,
                          list: widget.list,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: entityList.stream,
              builder: (BuildContext _context, AsyncSnapshot _snapshot) {
                if (_snapshot.hasError) {
                  return ErrorView();
                }

                if (_snapshot.hasData) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    controller: scrollController,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black26,
                      thickness: 1.9,
                    ),
                    itemCount: _snapshot.data.length + 1,
                    itemBuilder: (BuildContext _context, int index) {
                      if (index < _snapshot.data.length) {
                        return this.widget.display(
                              entity: _snapshot.data[index],
                              refresh: () => entityList.refresh(
                                _searchText,
                                this.widget.sortBy,
                                this.widget.filterBy,
                              ),
                            );
                      } else if (entityList.hasMore && entityList.isLoading) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: SizedBox(
                              child: Container(
                                child: PsaProgressIndicator(),
                              ),
                              width: 32,
                              height: 32,
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(),
                        );
                      }
                    },
                  );
                } else {
                  return Center(
                    child: PsaProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class ListAction extends StatelessWidget {
  const ListAction({
    Key? key,
    required this.title,
    required this.onTap,
    required this.selectedCount,
  }) : super(key: key);

  final String title;
  final Function onTap;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Ink(
        color: Colors.white,
       // color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Row(
                children: [
                  selectedCount > 0
                      ? Text(
                          '${LangUtil.getString('List', 'ListFilter.ActiveStatus.Label')} ($selectedCount)')
                      : Container(),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
