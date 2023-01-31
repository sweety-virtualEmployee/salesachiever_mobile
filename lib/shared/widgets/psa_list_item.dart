import 'package:flutter/material.dart';

class PsaListItem extends StatelessWidget {
  PsaListItem({
    required this.title,
    this.icon,
    this.widget,
  });

  final String title;
  final String? icon;
  final Widget? widget;

  Widget? _getIcon(String? iconUrl) =>
      iconUrl != null ? Image.asset(iconUrl) : null;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: _getIcon(icon),
      contentPadding:
          icon != null ? const EdgeInsets.only(right: 12, left: 0) : null,
      trailing: widget,
    );
  }
}
