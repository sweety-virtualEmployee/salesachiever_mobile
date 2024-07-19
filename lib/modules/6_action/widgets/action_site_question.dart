import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/6_action/provider/action_stormsaver_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_site_question_detail_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class ActionSiteQuestion extends StatefulWidget {
  final String questionTitle;

  ActionSiteQuestion({
    Key? key,
    required this.questionTitle,
  }) : super(key: key);

  @override
  State<ActionSiteQuestion> createState() => _ActionSiteQuestionState();
}

class _ActionSiteQuestionState extends State<ActionSiteQuestion> {
  late ActionSiteTierValueProvider _actionSiteTierValueProvider;
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _actionSiteTierValueProvider =
        Provider.of<ActionSiteTierValueProvider>(context, listen: false);
    questions = _actionSiteTierValueProvider
            .getGroupedQuestions[widget.questionTitle] ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActionSiteTierValueProvider>(
        builder: (context, provider, child) {
      return PsaScaffold(
          showHome: false,
          title: LangUtil.getString("TBL_TIER1.TIER1_ID", widget.questionTitle),
          body: ListView.builder(
              itemCount: questions.length,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            ActionSiteQuestionDetailScreen(
                                index: index, tier2: widget.questionTitle),
                      ),
                    );
                  },
                  child: ListTile(
                      title: Text(questions[index]["QUESTION"]),
                      trailing:CupertinoSwitch(
                        activeColor: Colors.blue,
                        value: questions[index]["ANSWER_ID"] != null,
                        onChanged: (bool value) {
                          print("value");
                        },
                      ),
                  ),
                );
              }));
    });
  }
}

