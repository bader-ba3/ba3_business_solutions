import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../../../controller/cost/cost_center_controller.dart';
import '../../../core/shared/widgets/show_context_menu.dart';
import '../../../model/cost/cost_center_tree.dart';

class MyTreeTile extends StatelessWidget {
  const MyTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.costCenterController,
  });

  final TreeEntry<CostCenterTree> entry;
  final VoidCallback onTap;
  final CostCenterController costCenterController;

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      guide: const IndentGuide.connectingLines(indent: 48),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        child: SizedBox(
          width: 10,
          height: 50,
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              showContextMenu(context, details.globalPosition, costCenterController, entry);
            },
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FolderButton(
                  isOpen: entry.hasChildren ? entry.isExpanded : null,
                  onPressed: entry.hasChildren ? onTap : null,
                ),
                if (costCenterController.editItem != entry.node.id)
                  Text(entry.node.name ?? "error")
                else
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: costCenterController.editCon,
                      onFieldSubmitted: (_) {
                        costCenterController.endRenameChild();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
