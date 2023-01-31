import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PsaStarButton extends StatelessWidget {
  final bool isSelected;
  final Function? onTap;

  const PsaStarButton({
    Key? key,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(
          isSelected ? Icons.star : Icons.star_border,
          color: Colors.blue,
          size: 30,
        ),
      ),
    );
  }
}
