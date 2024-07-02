import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_site_question.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class ActionSiteTierValue extends StatefulWidget {
  ActionSiteTierValue({
    Key? key,
    required this.action,
  }) : super(key: key);

  final Map<String, dynamic> action;

  @override
  State<ActionSiteTierValue> createState() => _ActionSiteTierValueState();
}

class _ActionSiteTierValueState extends State<ActionSiteTierValue> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool isLastPage = false;
  Map<String, List<Map<String, dynamic>>> groupedQuestions = {};

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //_loadNextPage();
      }
    });
    super.initState();
  }

  fetchData() async {
    try {
      var result =
          await ActionService().siteQuestionApi(widget.action["ACTION_ID"], 1);
      print(result["Items"]);
      List<dynamic> items = result["Items"];
      for (var question in items) {
        String tier2 = question['TIER2'];
        if (!groupedQuestions.containsKey(tier2)) {
          groupedQuestions[tier2] = [];
        }
        setState(() {
          groupedQuestions[tier2]!.add(question);
        });
      }
      print("grouped question $groupedQuestions");
      groupedQuestions.keys.forEach((key) => print(key));
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      showHome: false,
      body: ListView.separated(
        itemCount: groupedQuestions.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          String tier2 = groupedQuestions.keys.elementAt(index);
          List<Map<String, dynamic>> questionsForTier2 =
              groupedQuestions[tier2]!;
          int totalQuestions = questionsForTier2.length;
          int answeredQuestions = questionsForTier2
              .where((q) => q['ANSWER_ID'] != null)
              .toList()
              .length;
          return InkWell(
            onTap: (){
             Navigator.push(context, platformPageRoute(context: context,
               builder: (BuildContext context) => ActionSiteQuestion(
               questions:questionsForTier2,
                 questionTitle:tier2
             ),));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tier2),
                  Text("$answeredQuestions/$totalQuestions")
                ],
              ),
            ),
          );
        },
      ),
      title: '',
    );
  }
}
