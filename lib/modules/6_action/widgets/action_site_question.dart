import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/modules/6_action/widgets/action_site_question_detail_screen.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_edit_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class ActionSiteQuestion extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String questionTitle;

  ActionSiteQuestion({
    Key? key,
    required this.questions,
    required this.questionTitle,
  }) : super(key: key);

  @override
  State<ActionSiteQuestion> createState() => _ActionSiteQuestionState();
}

class _ActionSiteQuestionState extends State<ActionSiteQuestion> {


  @override
  void initState() {
    super.initState();
  }

  bool isSelected = false;

  void toggleSwitch(bool value){
    setState(() {
      isSelected=!isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {

    return PsaScaffold(
      showHome: false,
      title: widget.questionTitle,
      body: ListView.builder(
          itemCount:widget.questions.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            print(widget.questions[index]["ANSWER_ID"]);
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => ActionSiteQuestionDetailScreen(
                      questions: widget.questions,
                      index: index,
                    ),
                  ),
                );
              },
              child: SwitchItem(
                  question:widget.questions[index]["QUESTION"],
                  isSelected:widget.questions[index]["ANSWER_ID"]!=null?true:false,
              questionId:widget.questions[index]["QUESTION_ID"],
              actionId:widget.questions[index]["ACTION_ID"]),
            );
          })
    );
  }
}

class SwitchItem extends StatefulWidget {
  final String question;
  final bool isSelected;
  final String questionId;
  final String actionId;
   SwitchItem({Key? key,
     required this.question,
     required this.isSelected,
   required this.actionId,
   required this.questionId}) : super(key: key);

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  bool isSelected=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIsSelected(widget.isSelected);
  }

  Future<void> setIsSelected(bool newValue) async {
    setState(() {
      this.isSelected = newValue; // Error: 'isSelected' can't be used as a setter because it's final
    });
    print(this.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.question),
      trailing: PlatformSwitch(
        value: isSelected,
        activeColor: Colors.blue,
        onChanged: (value) async {
         setIsSelected(value);
         final answer = {
           "ACTION_ID": widget.actionId,
           "QUESTION_ID": widget.questionId,
           "QUESTION": widget.question,
           "ANSWER_ID": value ? 2 : 1
         };
         print("answer check $answer");
         final response = await ActionService().updateQuestionAnswer(answer);
         print(response);
        },
      ),
    );
  }
}

