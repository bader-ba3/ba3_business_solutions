import 'package:ba3_business_solutions/controller/cost/cost_center_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/model/cost/cost_center_tree.dart';
import 'package:ba3_business_solutions/view/cost_center/widgets/my_tree_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

class CostCenterView extends StatelessWidget {
  const CostCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    var costCenterController = Get.find<CostCenterController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tree of Truth"),
        actions: [
          ElevatedButton(
              onPressed: () {
                costCenterController.treeController?.collapseAll();
              },
              child: const Text("-")),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                costCenterController.treeController?.expandAll();
              },
              child: const Text("+")),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                var con = TextEditingController();
                Get.defaultDialog(content: TextFormField(controller: con), actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        costCenterController.addChild(name: con.text);
                      },
                      child: const Text("yes"))
                ]);
              },
              child: const Text("add root children")),
          const HorizontalSpace(20),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(AppConstants.costCenterCollection).snapshots(),
          builder: (context, snapshot) {
            return GetBuilder<CostCenterController>(builder: (controller) {
              return costCenterController.allCost.isEmpty
                  ? const CircularProgressIndicator()
                  : TreeView<CostCenterTree>(
                      treeController: costCenterController.treeController!,
                      nodeBuilder: (BuildContext context, TreeEntry<CostCenterTree> entry) {
                        return MyTreeTile(
                          key: ValueKey(entry.node),
                          entry: entry,
                          costCenterController: costCenterController,
                          onTap: () {
                            controller.lastIndex = entry.node.id;
                            costCenterController.treeController?.toggleExpansion(entry.node);
                          },
                        );
                      },
                    );
            });
          }),
    );
  }
}
