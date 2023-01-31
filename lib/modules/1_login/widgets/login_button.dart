import 'package:flutter/widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_button.dart';

class LoginButton extends StatelessWidget {
  final Function onTap;

  const LoginButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PsaButton(
          onTap: onTap,
        )
      ],
    );
  }
}
