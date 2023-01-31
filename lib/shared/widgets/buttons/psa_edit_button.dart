import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaEditButton extends StatelessWidget {
  const PsaEditButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: text == 'Edit' ? Icon(Icons.edit) : Icon(Icons.save),
          onPressed: onTap != null ? () => onTap!() : null,
        ),
      ),
      cupertino: (_, __) => TextButton(
        child: PlatformText(text),
        onPressed: onTap != null ? () => onTap!() : null,
      ),
    );
  }
}
