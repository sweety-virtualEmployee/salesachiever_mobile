import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaProgressIndicator extends StatelessWidget {
  const PsaProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformCircularProgressIndicator();
  }
}
