import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/6_action/provider/action_stormsaver_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_site_question.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

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
  late ActionSiteTierValueProvider _actionSiteTierValueProvider;
  Map<String, List<Map<String, dynamic>>> groupedQuestion = {};

  @override
  void initState() {
    super.initState();
    _actionSiteTierValueProvider = Provider.of<ActionSiteTierValueProvider>(context,listen: false);
    _actionSiteTierValueProvider.clearData();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
  }

  Future<void> fetchData() async {
    try {
      context.loaderOverlay.show();
      var result = await ActionService().siteQuestionApi(widget.action["ACTION_ID"], _actionSiteTierValueProvider.getCurrentPage);
      List<dynamic> items = result["Items"];
      print("iyem$items");
      bool lastPage = result["IsLastPage"] ?? false;

      for (var question in items) {
        String tier2 = question['TIER2'];
        if (!groupedQuestion.containsKey(tier2)) {
          groupedQuestion[tier2] = [];
        }
        setState(() {
          groupedQuestion[tier2]!.add(question);
        });
        _actionSiteTierValueProvider.setGroupedQuestions(groupedQuestion);
      }

      _actionSiteTierValueProvider.setIsLastPage(lastPage);
      _actionSiteTierValueProvider.setCurrentPage(_actionSiteTierValueProvider.getCurrentPage+1);

    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _actionSiteTierValueProvider.setIsLoading(false);
      context.loaderOverlay.hide();
    }
  }

  void _loadNextPage() {
    if (!_actionSiteTierValueProvider.getIsLoading && !_actionSiteTierValueProvider.getIsLastPage) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActionSiteTierValueProvider>(
        builder: (context, provider, child) {
        return LoaderOverlay(
          useDefaultLoading: true,
          overlayWidgetBuilder:(_){
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          child: PsaScaffold(
            showHome: false,
            body: ListView.separated(
              controller: _scrollController,
              itemCount: provider.getGroupedQuestions.length + 1,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                if (index == provider.getGroupedQuestions.length) {
                  return provider.getIsLastPage
                      ? Container()
                      : Center(child: CircularProgressIndicator());
                }
                String tier2 = provider.getGroupedQuestions.keys.elementAt(index);
                List<Map<String, dynamic>> questionsForTier2 = provider.getGroupedQuestions[tier2]!;
                int totalQuestions = questionsForTier2.length;
                int answeredQuestions = questionsForTier2
                    .where((q) => q['ANSWER_ID'] != null)
                    .toList()
                    .length;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) => ActionSiteQuestion(
                          questionTitle: tier2,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LangUtil.getString("TBL_TIER1.TIER1_ID", tier2),style: TextStyle(
                          fontSize: 14
                        ),),
                        Text("$answeredQuestions/$totalQuestions")
                      ],
                    ),
                  ),
                );
              },
            ),
            title: '',
          ),
        );
      }
    );
  }
}

