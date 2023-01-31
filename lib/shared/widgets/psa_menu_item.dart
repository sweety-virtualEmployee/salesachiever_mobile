import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_star_button.dart';

class PsaMenuItem extends StatelessWidget {
  PsaMenuItem({
    required this.title,
    this.image,
    this.subtitle,
    required this.onTap,
    this.hasChild = true,
    this.selected = false,
    this.showFavoriteIcon = false,
    this.isFavourite = false,
    this.onTapFavourite,
  });

  final String title;
  final String? image;
  final String? subtitle;
  final Function onTap;
  final bool hasChild;
  final bool selected;
  final bool showFavoriteIcon;
  final bool isFavourite;
  final Function? onTapFavourite;

  Widget? _getLeadingWidget(String? imageUrl) =>
      imageUrl != null ? Image.asset(imageUrl) : null;

  Widget? _getTrailingWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        showFavoriteIcon
            ? PsaStarButton(isSelected: isFavourite, onTap: onTapFavourite)
            : Container(),
        hasChild
            ? Icon(
                context.platformIcons.rightChevron,
                size: 20,
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      leading: _getLeadingWidget(image),
      title: Text(title),
      trailing: _getTrailingWidget(context),
      contentPadding: image != null
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(horizontal: 8),
      onTap: () => onTap(),
    );
  }
}
