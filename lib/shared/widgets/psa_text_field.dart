import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaTextField extends StatelessWidget {
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Function? onEditingComplete;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;

  PsaTextField({
    Key? key,
    this.placeholder,
    this.keyboardType,
    this.isPassword = false,
    this.onEditingComplete,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => TextField(
        controller: controller,
        onEditingComplete: () => onEditingComplete!(),
        style: TextStyle(
          color: Color(0xFF666666),
        ),
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          isDense: true,
          hintText: placeholder,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDFDFDF)),
          ),
          hintStyle: TextStyle(
            color: Color(0xFFAFAFAF),
          ),
        ),
        textInputAction: textInputAction,
      ),
      cupertino: (_, __) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            CupertinoTextField(
              onEditingComplete: () => onEditingComplete!(),
              controller: controller,
              autocorrect: false,
              keyboardType: keyboardType,
              obscureText: isPassword,
              placeholder: placeholder,
              style: TextStyle(
                color: Color(0xFF666666),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
              ),
              textInputAction: textInputAction,
            ),
          ],
        ),
      ),
    );
  }
}
