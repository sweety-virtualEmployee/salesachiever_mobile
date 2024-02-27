import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/decode_base64_util.dart';

class DynamicReportScreen extends StatefulWidget {
  final List<dynamic> reports;
  final String id;
   DynamicReportScreen({Key? key,required this.reports,required this.id}) : super(key: key);

  @override
  State<DynamicReportScreen> createState() => _DynamicReportScreenState();
}

class _DynamicReportScreenState extends State<DynamicReportScreen> {
  DynamicProjectService service = DynamicProjectService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("next page reports");
    print(widget.reports);
  }
  @override
  Widget build(BuildContext context) {
    return  PsaScaffold(
      title: "Profile Reports",
      body: Column(
        children: [
          if (widget.reports.isNotEmpty) ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.reports.length,
              itemBuilder: (context,index){
            return InkWell(
              onTap: () async {
                final String encodedString = await service.getGeneratedReports(widget.reports[index]["ID"],widget.reports[index]["Title"],widget.id);
                print("encode string $encodedString");
                saveBase64AsPdf(encodedString,context,widget.reports[index]["Title"],false,"");
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey
                  ),
                ),
                  child: Text(widget.reports[index]["Title"])),
            );
          }) else Text("No Report Available")
        ],
      ),
    );
  }
}
