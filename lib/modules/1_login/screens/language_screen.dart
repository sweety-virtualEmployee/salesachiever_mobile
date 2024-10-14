import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/data/languages.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: '',
      showHome: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (BuildContext _context, int index) {
            return InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: PlatformText(languages[index]['locale'] ?? ''),
              ),
              onTap: () => Navigator.pop(context, languages[index]['localeId']),
            );
          },
          itemCount: languages.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
