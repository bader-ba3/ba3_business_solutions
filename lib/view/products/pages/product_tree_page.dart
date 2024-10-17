import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/view/products/pages/add_product_page.dart';
import 'package:ba3_business_solutions/view/products/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../../data/model/product/product_tree.dart';

class ProductTreePage extends StatelessWidget {
  ProductTreePage({super.key});

  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("شجرة المواد"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        productController.treeController?.collapseAll();
                      },
                      child: const Text("-")),
/*                  ElevatedButton(
                      onPressed: () {
                        // productController.correct();
                      },
                      child: Text("-aaaaa")),*/
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        productController.treeController?.expandAll();
                      },
                      child: const Text("+")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        productController.createFolderDialog();
                      },
                      child: const Text("إضافة ملف")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => const AddProductPage());
                      },
                      child: const Text("اضافة حساب")),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              body: GetBuilder<ProductController>(builder: (controller) {
                return productController.allProductTree.isEmpty
                    ? const CircularProgressIndicator()
                    : TreeView<ProductTree>(
                        treeController: productController.treeController!,
                        nodeBuilder: (BuildContext context, TreeEntry<ProductTree> entry) {
                          return myTreeTile(
                            context: context,
                            key: ValueKey(entry.node),
                            entry: entry,
                            onTap: () {
                              controller.lastIndex = entry.node.id;
                              productController.treeController?.toggleExpansion(entry.node);
                            },
                          );
                        },
                      );
              }),
            ),
          ),
        ),
      ],
    );
  }

  myTreeTile({context, required ValueKey<ProductTree> key, required VoidCallback onTap, required TreeEntry<ProductTree> entry}) {
    return TreeIndentation(
      key: key,
      entry: entry,
      guide: const IndentGuide.connectingLines(indent: 48),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        child: SizedBox(
          width: 10,
          height: 50,
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              showContextMenu(context, details.globalPosition, productController, entry);
            },
            onLongPressStart: (details) {
              showContextMenu(context, details.globalPosition, productController, entry);
            },
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FolderButton(
                  isOpen: entry.hasChildren ? entry.isExpanded : null,
                  onPressed: entry.hasChildren ? onTap : null,
                ),
                if (productController.editItem != entry.node.id)
                  Text("${productController.getFullCodeOfProduct(entry.node.id!)} - ${entry.node.name!}")
                else
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      decoration: const InputDecoration(fillColor: Colors.white, filled: true),
                      controller: productController.editCon,
                      onFieldSubmitted: (_) {
                        productController.endRenameChild();
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

  void showContextMenu(BuildContext parentContext, Offset tapPosition, ProductController controller, entry) {
    showMenu(
      context: parentContext,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy * 1.0,
      ),
      items: [
        if (getProductModelFromId(entry.node.id)!.prodIsGroup!)
          PopupMenuItem(
            value: 'adddda',
            child: ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: Text('الازاحة ${getProductModelFromId(entry.node.id)!.prodGroupPad}'),
            ),
          ),
        const PopupMenuItem(
          value: 'seeDetails',
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('عرض حركات'),
          ),
        ),
        if (getProductModelFromId(entry.node.id)!.prodIsGroup!)
          const PopupMenuItem(
            value: 'add',
            child: ListTile(
              leading: Icon(Icons.add_box_outlined),
              title: Text('إضافة مادة'),
            ),
          ),
        if (getProductModelFromId(entry.node.id)!.prodIsGroup!)
          const PopupMenuItem(
            value: 'addFolder',
            child: ListTile(
              leading: Icon(Icons.folder),
              title: Text('إضافة ملف'),
            ),
          ),
        const PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('اعادة تسمية'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'seeDetails') {
        Get.to(() => ProductDetailsPage(oldKey: entry.node.id!));
      } else if (value == 'rename') {
        controller.startRenameChild(entry.node.id);
      } else if (value == "add") {
        Get.to(AddProductPage(oldParent: entry.node.id));
      } else if (value == "addFolder") {
        TextEditingController nameCon = TextEditingController();
        Get.defaultDialog(
            title: "اختر الطريق",
            content: SizedBox(
              height: Get.height / 2,
              width: Get.height / 2,
              child: SizedBox(
                height: 35,
                width: double.infinity,
                child: TextFormField(
                  controller: nameCon,
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    controller.addFolder(nameCon.text, prodParentId: entry.node.id);
                    Get.back();
                  },
                  child: const Text("إضافة")),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("إلغاء")),
            ]);
      }
    });
  }
}
