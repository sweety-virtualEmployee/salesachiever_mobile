import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaCameraButton extends StatelessWidget {
  const PsaCameraButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: PlatformWidget(
        material: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.camera_alt_outlined,
          ),
        ),
        cupertino: (_, __) => Icon(
          CupertinoIcons.camera,
        ),
      ),
    );
  }
}
