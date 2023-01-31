import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/psa_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.node,
  }) : super(key: key);

  final FocusScopeNode node;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFAFA),
        borderRadius: BorderRadius.all(
          new Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PsaTextField(
              placeholder: 'UserName',
              keyboardType: TextInputType.text,
              onEditingComplete: () => node.nextFocus(),
            ),
            PsaTextField(
              placeholder: 'Password',
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              onEditingComplete: () => node.nextFocus(),
            ),
            PsaTextField(
              placeholder: 'Url',
              keyboardType: TextInputType.url,
              onEditingComplete: () => node.nextFocus(),
            ),
            PsaTextField(
              placeholder: 'DB Name',
              keyboardType: TextInputType.text,
              onEditingComplete: () => node.nextFocus(),
            ),
          ],
        ),
      ),
    );
  }
}
