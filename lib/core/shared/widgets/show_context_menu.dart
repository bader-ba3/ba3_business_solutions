import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import '../../../controller/cost/cost_center_controller.dart';
import '../../../model/cost/cost_center_tree.dart';

void showContextMenu(
  BuildContext parentContext,
  Offset tapPosition,
  CostCenterController controller,
  final TreeEntry<CostCenterTree> entry,
) {
  showMenu(
    context: parentContext,
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
  ).then((value) {
    if (value == 'rename') {
      controller.startRenameChild(entry.node.id);
    } else if (value == 'delete') {
      controller.removeChild(parent: entry.parent?.node.id, id: entry.node.id);
    } else if (value == "add") {
      var con = TextEditingController();
      Get.defaultDialog(content: TextFormField(controller: con), actions: [
        ElevatedButton(
            onPressed: () {
              Get.back();
              controller.addChild(parent: entry.node.id, name: con.text);
            },
            child: const Text("yes"))
      ]);
    }
  });
}
