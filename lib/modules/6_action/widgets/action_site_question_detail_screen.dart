import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class ActionSiteQuestionDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int index;

  ActionSiteQuestionDetailScreen({
    Key? key,
    required this.questions,
    required this.index,
  }) : super(key: key);

  @override
  State<ActionSiteQuestionDetailScreen> createState() =>
      _ActionSiteQuestionDetailScreenState();
}

class _ActionSiteQuestionDetailScreenState
    extends State<ActionSiteQuestionDetailScreen> {
  late int _currentIndex;
  late String _selectedOption;
  final TextEditingController _internalCommentsController =
      TextEditingController();
  final TextEditingController _publicCommentsController =
      TextEditingController();
  Map<String, dynamic> answers = {};

  @override
  void initState() {
    _currentIndex = widget.index;
    _selectedOption =  widget.questions[_currentIndex]["ANSWER_ID"] == "1"? "no" : widget.questions[_currentIndex]["ANSWER_ID"] == "2"? "yes": widget.questions[_currentIndex]["ANSWER_ID"] == "3"? "na": widget.questions[_currentIndex]["ANSWER_ID"] == "4"? "unknown":"";
    print(widget.questions[_currentIndex]["ANSWER_ID"]);
    print(_currentIndex);
    super.initState();
  }

  void _handlePrevious() {
    _saveCurrentQuestionData();
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  void _handleNext() {
    _saveCurrentQuestionData();
    setState(() {
      if (_currentIndex < widget.questions.length - 1) {
        _currentIndex++;
      }

    });
  }

  Future<void> _saveCurrentQuestionData() async {
    setState(() {
      answers={
        "ACTION_ID":  widget.questions[_currentIndex]["ACTION_ID"],
        "QUESTION_ID": widget.questions[_currentIndex]["QUESTION_ID"],
        "QUESTION": widget.questions[_currentIndex]["QUESTION"],
        "ANSWER_ID": _selectedOption == "no"? "1" :_selectedOption == "yes"? "2":_selectedOption == "na"?
        "3":_selectedOption == "unknown"? "4":null,
        "INTERNAL_COMMENTS":_internalCommentsController.text,
        "PUBLIC_COMMENTS":_publicCommentsController.text
      };
    });
    print(answers);
    final response = await ActionService().updateQuestionAnswer(answers);
    print(response);
  }

  Future<void> _handleSave() async {
    await _saveCurrentQuestionData();
    await  fetchData();
    Navigator.pop(context);
  }
  fetchData() async {
    try {
      context.loaderOverlay.show(); // Show loader overlay
      var result =
      await ActionService().siteQuestionApi(widget.questions[_currentIndex]["ACTION_ID"], 1);
      print(result["Items"]);
      List<dynamic> items = result["Items"];
      print("items");
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      context.loaderOverlay.hide(); // Hide loader overlay
    }
  }
  Widget _buildOptionButton(String value, String text) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedOption = value;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor:
              _selectedOption == value ? Colors.white : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: '',
      showHome: false,
      body: Column(
        children: [
          Container(
              height: 50,
              color: Color(0xff076385),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Question ${_currentIndex+1}/${widget.questions.length}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffabdbfb),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.questions[_currentIndex]["QUESTION"],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffececec),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  _buildOptionButton('yes', 'Yes'),
                  SizedBox(width: 8),
                  _buildOptionButton('no', 'No'),
                  SizedBox(width: 8),
                  _buildOptionButton('unknown', 'Unknown'),
                  SizedBox(width: 8),
                  _buildOptionButton('na', 'N/A'),
                  SizedBox(width: 8),
                  _buildOptionButton('none', 'None'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfffff2d1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  maxLines: 5,
                  controller: _internalCommentsController,
                  decoration: InputDecoration(
                    hintText: 'Internal Comments',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfffff2d1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextField(
                  maxLines: 5,
                  controller: _publicCommentsController,
                  decoration: InputDecoration(
                    hintText: 'Public Comments',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffececec),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _handlePrevious,
                    child: Text(
                      'Previous',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: _handleNext,
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xff076385),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _handleSave,
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
