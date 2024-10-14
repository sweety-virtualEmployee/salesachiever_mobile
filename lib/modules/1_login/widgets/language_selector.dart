import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/languages.dart';
import 'package:salesachiever_mobile/modules/1_login/screens/language_screen.dart';



class LanguageSelector extends StatefulWidget {
  final String localeId;
  final Function onLanguageChanged;

  const LanguageSelector(
      {Key? key, required this.localeId, required this.onLanguageChanged})
      : super(key: key);

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? selectedLocale;

  @override
  void initState() {
    selectedLocale = widget.localeId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        child: Row(
          children: [
            Text(
              'Language: ${languages.firstWhere((element) => element['localeId'] == selectedLocale)['locale'] ?? ''}',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  platformPageRoute(
                    context: context,
                    builder: (BuildContext context) => LanguageScreen(),
                  ),
                );

                if (result != null && result != '') {
                  setState(() {
                    selectedLocale = result;
                  });

                  widget.onLanguageChanged(selectedLocale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
