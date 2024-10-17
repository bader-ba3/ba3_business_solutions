import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../../../data/model/cost/cost_center_tree.dart';

void showContextMenu(
  BuildContext context,
  Offset tapPosition,

  final TreeEntry<CostCenterTree> entry,
) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      tapPosition.dx + 1.0,
      tapPosition.dy + 1.0,
    ),
    items: [
      const PopupMenuItem(
        value: 'add',
        child: ListTile(
          leading: Icon(Icons.copy),
          title: Text('add Child'),
        ),
      ),
      const PopupMenuItem(
        value: 'rename',
        child: ListTile(
          leading: Icon(Icons.copy),
          title: Text('rename'),
        ),
      ),
      const PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.copy),
          title: Text('delete Child'),
        ),
      ),
    ],
  );
}
