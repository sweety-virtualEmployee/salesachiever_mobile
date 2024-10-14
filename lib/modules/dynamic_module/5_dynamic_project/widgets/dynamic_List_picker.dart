import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicPsaListPicker extends StatefulWidget {
  final String title;
  final String tableName;
  final String fieldName;
  final String returnField;
  final dynamic listValue;
  const DynamicPsaListPicker({Key? key,required this.title,required this.listValue,
    required this.tableName,
    required this.fieldName,
    required this.returnField,}) : super(key: key);

  @override
  State<DynamicPsaListPicker> createState() => _DynamicPsaListPickerState();
}

class _DynamicPsaListPickerState extends State<DynamicPsaListPicker> {

  DynamicProjectService service = DynamicProjectService();
  List<dynamic> listDataValue=[];
  TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
   bool isLastPage=false;
   int pageNumber=1;

  @override
  void initState() {
    listDataValue = widget.listValue["Items"];
    isLastPage = widget.listValue["IsLastPage"];
    pageNumber = widget.listValue["PageNumber"];
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
    super.initState();
  }




  void _loadNextPage() async {
    if(isLastPage==false){
      pageNumber = pageNumber+1;
      var listData = await service.getLookByDDL(widget.tableName,widget.fieldName,widget.returnField,pageNumber);
      setState(() {
        isLastPage =listData["IsLastPage"];
        pageNumber = listData["PageNumber"];
        listDataValue.addAll(listData["Items"]);
      });
    }
  }

  void _onSearchTextChanged(String value) async {
    print(value);

     if (value.isNotEmpty) {
       var listData = await service.getSearchLookByDDL(widget.tableName,widget.fieldName,widget.returnField,value);
       print(listData);
        if(listData.isNotEmpty){
          setState(() {
            listDataValue.clear();
            listDataValue = listData;
          });
       }
     }
   }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: widget.title,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              controller: _controller,
              autocorrect: false,
              placeholder: LangUtil.getString("Entities", 'List.Search'),
              prefix: Icon(context.platformIcons.search),
              onChanged: _onSearchTextChanged,
              textInputAction: TextInputAction.search,
              clearButtonMode: OverlayVisibilityMode.editing,
              suffix: GestureDetector(
                onTap: () async {
                  _controller.clear();
                    context.loaderOverlay.show();
                    var listData = await service.getLookByDDL(widget.tableName,widget.fieldName,widget.returnField,1);
                    print("result$listData");
                    context.loaderOverlay.hide();
                    if(listData.isNotEmpty){
                      setState(() {
                        listDataValue.clear();
                        listDataValue = listData["Items"];
                      });
                    }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    CupertinoIcons.clear,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: PlatformText(
                        listDataValue[index]['RECORD_DESC'],
                      ),
                    ),
                    onTap: () => Navigator.pop(context, {
                      'ID':  listDataValue[index]['RECORD_ID'],
                      'TEXT':  listDataValue[index]['RECORD_DESC']
                    }),
                  );
                },
                itemCount: listDataValue.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black26,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
