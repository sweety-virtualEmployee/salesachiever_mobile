import 'package:flutter/material.dart';

class PsaLinkButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const PsaLinkButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: new Text(
          text,
          style: TextStyle(color: Colors.indigo),
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }
}
