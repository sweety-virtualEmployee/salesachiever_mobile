import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:salesachiever_mobile/modules/6_action/provider/action_stormsaver_provider.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class ActionSiteQuestionDetailScreen extends StatefulWidget {
  final String tier2;
  final int index;

  ActionSiteQuestionDetailScreen({
    Key? key,
    required this.tier2,
    required this.index,
  }) : super(key: key);

  @override
  State<ActionSiteQuestionDetailScreen> createState() =>
      _ActionSiteQuestionDetailScreenState();
}

class _ActionSiteQuestionDetailScreenState
    extends State<ActionSiteQuestionDetailScreen> {
  late ActionSiteTierValueProvider _actionSiteTierValueProvider;
  List<Map<String, dynamic>> questions = [];
  String _selectedOption = "";
  final TextEditingController _internalCommentsController = TextEditingController();
  final TextEditingController _publicCommentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _actionSiteTierValueProvider = Provider.of<ActionSiteTierValueProvider>(context, listen: false);
    _actionSiteTierValueProvider.setCurrentIndex(widget.index);
    questions = _actionSiteTierValueProvider.getGroupedQuestions[widget.tier2] ?? [];
    _loadCurrentQuestionData();
  }

  Future<void> _loadCurrentQuestionData() async {
    var currentQuestion = questions[_actionSiteTierValueProvider.getCurrentIndex];
    setState(() {
      _selectedOption = currentQuestion['ANSWER_ID'] == "1" ? "no"
          : currentQuestion['ANSWER_ID'] == "2" ? "yes"
          : currentQuestion['ANSWER_ID'] == "3" ? "na"
          : currentQuestion['ANSWER_ID'] == "4" ? "unknown"
          : currentQuestion['ANSWER_ID'] == null ? ""
          : "";
      _internalCommentsController.text = currentQuestion['INTERNAL_COMMENTS'] ?? "";
      _publicCommentsController.text = currentQuestion['PUBLIC_COMMENTS'] ?? "";
    });
  }

  Future<void> _saveCurrentQuestionData() async {
    var currentQuestion = questions[_actionSiteTierValueProvider.getCurrentIndex];
    setState(() {
      currentQuestion['ANSWER_ID'] = _selectedOption == "no" ? "1"
          : _selectedOption == "yes" ? "2"
          : _selectedOption == "na" ? "3"
          : _selectedOption == "unknown" ? "4"
          : null;
      currentQuestion['INTERNAL_COMMENTS'] = _internalCommentsController.text;
      currentQuestion['PUBLIC_COMMENTS'] = _publicCommentsController.text;
    });
     final response = await ActionService().updateQuestionAnswer(currentQuestion);
     print(response);
    await fetchData();
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();
    await _saveCurrentQuestionData();
    Navigator.pop(context);
  }

  Future<void> _handleNext() async {
    FocusScope.of(context).unfocus();
    await _saveCurrentQuestionData();
    if (_actionSiteTierValueProvider.getCurrentIndex < questions.length - 1) {
      _actionSiteTierValueProvider.setCurrentIndex(_actionSiteTierValueProvider.getCurrentIndex + 1);
      _loadCurrentQuestionData();
    }
  }

  Future<void> _handlePrevious() async {
    FocusScope.of(context).unfocus();
    await _saveCurrentQuestionData();
    if (_actionSiteTierValueProvider.getCurrentIndex > 0) {
      _actionSiteTierValueProvider.setCurrentIndex(_actionSiteTierValueProvider.getCurrentIndex - 1);
      _loadCurrentQuestionData();
    }
  }

  Future<void> fetchData() async {
    try {
      context.loaderOverlay.show();
      var result = await ActionService().siteQuestionApi(questions[0]["ACTION_ID"], _actionSiteTierValueProvider.getCurrentPage);
      List<dynamic> items = result["Items"];
      bool lastPage = result["IsLastPage"] ?? false;

      Map<String, List<Map<String, dynamic>>> groupedQuestion = {};

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
      _actionSiteTierValueProvider.setCurrentPage(_actionSiteTierValueProvider.getCurrentPage + 1);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _actionSiteTierValueProvider.setIsLoading(false);
      context.loaderOverlay.hide();
    }
  }
  String? _mapOptionToAnswerId(String option) {
    switch (option) {
      case 'yes':
        return '2';
      case 'no':
        return '1';
      case 'na':
        return '3';
      case 'unknown':
        return '4';
      default:
        return null;
    }
  }
   _onWillPop() async {
    var currentQuestion = questions[_actionSiteTierValueProvider.getCurrentIndex];
    String? mappedAnswerId = _mapOptionToAnswerId(_selectedOption);
    bool hasChanges = (currentQuestion['ANSWER_ID']!=mappedAnswerId);
    if (hasChanges) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('Do you want to save the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _handleSave();
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
    } else {
      Navigator.pop(context);
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
          backgroundColor: _selectedOption == value ? Colors.white : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActionSiteTierValueProvider>(
      builder: (context, provider, child) {
        return PsaScaffold(
          title: '',
          onBackPressed: _onWillPop,
          showHome: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity, // Ensures proper layout
                child: Column(
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
                              "Question ${_actionSiteTierValueProvider.getCurrentIndex + 1}/${questions.length}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffabdbfb),
                          border: Border.all(color: Colors.black, width: 1.0),
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
                                  questions[_actionSiteTierValueProvider.getCurrentIndex]["QUESTION"]!,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            textInputAction: TextInputAction.done,
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
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Public Comments',
                              border: InputBorder.none,
                            ),
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
                    SizedBox(height: 10),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
