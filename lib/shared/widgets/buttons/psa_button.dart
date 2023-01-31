import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaButton extends StatelessWidget {
  const PsaButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      cupertino: (_, __) => CupertinoElevatedButtonData(
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => onTap(context),
      ),
      material: (_, __) => MaterialElevatedButtonData(
        child: Text(
          'Login',
          // style: TextStyle(color: Colors.white),
        ),
        onPressed: () => onTap(context),
      ),
    );
  }
}
