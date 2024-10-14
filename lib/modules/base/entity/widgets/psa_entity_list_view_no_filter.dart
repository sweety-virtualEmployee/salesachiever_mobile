import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/11_Potentials/services/potential_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/models/entity.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';
import 'package:salesachiever_mobile/shared/widgets/error_view.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

typedef Widget DisplayType(
    {required final dynamic entity, required final Function refresh});

class PsaEntityListViewNofilter extends StatefulWidget {
  final DisplayType display;
  final PotentialService service;
  final String type;
  final String id;

  const PsaEntityListViewNofilter(
      {Key? key,
      required this.display,
      required this.service,
      required this.type,
      required this.id})
      : super(key: key);

  @override
  _PsaEntityListViewNofilterState createState() =>
      _PsaEntityListViewNofilterState();
}

class _PsaEntityListViewNofilterState extends State<PsaEntityListViewNofilter> {
  final scrollController = ScrollController();
  String _searchText = '';
  late PotentialService entityService;
  late Stream<List<dynamic>> stream = new Stream.empty();
  StreamController<List<dynamic>> _controller =
      StreamController<List<dynamic>>.broadcast();
  bool isLoading = false;
  List<dynamic> _data = [];

  _PsaEntityListViewNofilterState(){
     stream = _controller.stream.map((List<dynamic> entityList) {
      return entityList.map((dynamic entity) {
        return entity;
      }).toList();
    });
  }

  @override
  void initState() {
    entityService = this.widget.service;
    entityService.getPotentials(this.widget.id).then((response) {
      EntityList entityList = EntityList.fromJson(response);
      isLoading = false;
      _data.addAll(entityList.data!);
      _controller.add(_data);
      // stream = _controller.stream.map((List<dynamic> entityList) {
      //   return entityList.map((dynamic entity) {
      //     return entity;
      //   }).toList();
      // });
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
                setState(() {
                  _searchText = value;
                });
                // entityList.search(_searchText);
              },
              prefix: Icon(context.platformIcons.search),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _searchText = value;
                  });
                  // entityList.search(_searchText);
                }

                // entityList.filter(value);
              },
              textInputAction: TextInputAction.search,
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: stream,
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
                    ),
                    itemCount: _snapshot.data.length,
                    itemBuilder: (BuildContext _context, int index) {
                      return this.widget.display(
                              entity: _snapshot.data[index],
                              refresh: () => {},
                            );
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
        color: Colors.grey[200],
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
                    color: Colors.red,
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
