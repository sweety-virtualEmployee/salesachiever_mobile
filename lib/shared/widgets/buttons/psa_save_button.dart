import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaSaveButton extends StatelessWidget {
  const PsaSaveButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: Icon(
            Icons.save,
          ),
          onPressed: () => onTap(),
        ),
      ),
      cupertino: (_, __) => TextButton(
        child: Text('Save'),
        onPressed: () => onTap(),
      ),
    );
  }
}
