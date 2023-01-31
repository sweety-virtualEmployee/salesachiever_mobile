class HomeMenuItem {
  HomeMenuItem({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.hasChild,
    this.onTap,
    this.selected,
    this.accessCode
  });

  String key;
  String title;
  String subtitle;
  String image;
  bool hasChild;
  Function? onTap;
  bool? selected;
  int? accessCode;
}
