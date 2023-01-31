import 'package:flutter/widgets.dart';

class EntityListItemWidget extends StatefulWidget {
  final dynamic entity;
  final Function refresh;
  final bool isSelectable;
  final bool isEditable;

  const EntityListItemWidget({
    Key? key,
    required this.entity,
    required this.refresh,
    this.isSelectable = false,
    this.isEditable = false, contact,
  })  : assert(entity != null),
        super(key: key);

  @override
  EntityListItemWidgetState createState() => EntityListItemWidgetState();
}

class EntityListItemWidgetState<T extends EntityListItemWidget>
    extends State<T> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
