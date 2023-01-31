import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/elements/psa_progress_indicator.dart';

class DialogLoader {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showPlatformDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0x66FFFFFF),
            borderRadius: BorderRadius.all(
              new Radius.circular(8.0),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PsaProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
