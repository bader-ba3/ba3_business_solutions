import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/cost_center_view_model.dart';
import 'package:ba3_business_solutions/model/cost_center_tree.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import '../../model/account_tree.dart';


class AccountTreeView extends StatelessWidget {
   AccountTreeView({super.key});
  var accountController = Get.find<AccountViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tree of Truth"),
        actions: [
          ElevatedButton(
              onPressed: () {
                accountController.treeController?.collapseAll();
              },
              child: Text("-")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                accountController.treeController?.expandAll();
              },
              child: Text("+")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
              Get.to(()=>AddAccount());
              },
              child: Text("add Account")),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(Const.accountsCollection).snapshots(),
          builder: (context, snapshot) {
            return GetBuilder<AccountViewModel>(builder: (controller) {
              return accountController.allCost.isEmpty
                  ? const CircularProgressIndicator()
                  : TreeView<AccountTree>(
                      treeController: accountController.treeController!,
                      nodeBuilder: (BuildContext context, TreeEntry<AccountTree> entry) {
                        return myTreeTile(
                          context: context,
                          key: ValueKey(entry.node),
                          entry: entry,
                          onTap: () {
                            controller.lastIndex = entry.node.id;
                            accountController.treeController?.toggleExpansion(entry.node);
                          },
                        );
                      },
                    );
            });
          }),
    );
  }
   myTreeTile({context,required ValueKey<AccountTree> key,required VoidCallback onTap,required TreeEntry<AccountTree> entry}) {
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
               showContextMenu(context, details.globalPosition, accountController,entry);
             },
             onTap: onTap,
             child: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 FolderButton(
                   isOpen: entry.hasChildren ? entry.isExpanded : null,
                   onPressed: entry.hasChildren ? onTap : null,
                 ),
                 if (accountController.editItem != entry.node.id)
                   Text(entry.node.name ?? "error")
                 else
                   SizedBox(
                     width: 100,
                     child: TextFormField(
                       controller: accountController.editCon,
                       onFieldSubmitted: (_) {
                         accountController.endRenameChild();
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

   void showContextMenu(BuildContext parentContext, Offset tapPosition, AccountViewModel controller,entry) {
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
           value: 'seeDetails',
           child: ListTile(
             leading: Icon(Icons.info_outline),
             title: Text('see Details'),
           ),
         ),
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
       ],
     ).then((value) {
       if (value == 'seeDetails') {
         Get.to(()=>AccountDetails(modelKey: entry.node.id!));
       } else if (value == 'rename') {
         controller.startRenameChild(entry.node.id);
       }else if (value == "add") {
        Get.to(AddAccount(oldParent:entry.node.id));
       }
     });
   }
}



