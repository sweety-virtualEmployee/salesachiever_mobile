import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PsaMainMenuItem extends StatelessWidget {
  PsaMainMenuItem({
    required this.title,
    required this.image,
    this.subtitle,
    required this.onTap,
    this.hasChild = true,
    this.selected = false,
  });

  final String title;
  final String image;
  final String? subtitle;
  final Function onTap;
  final bool hasChild;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    print(title);
    return title=="Email us"?SizedBox():ListTile(
      selected: selected,
      leading: Image.asset(
        image,
      ),
      title: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
              child: PlatformText(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            /*if (subtitle != null)
              PlatformText(
                subtitle ?? '',
                style: TextStyle(fontSize: 12),
              ),*/
          ],
        ),
      ),
      trailing: hasChild ? Icon(context.platformIcons.rightChevron) : null,
      contentPadding: const EdgeInsets.only(right: 8),
      onTap: () {
        onTap();
      },
    );
  }
}
