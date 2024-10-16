import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_controller.dart';
import '../../../controller/invoice/search_controller.dart';
import '../../../core/shared/dialogs/Account_Option_Dialog.dart';
import '../../../core/utils/hive.dart';

void dashboardContextMenu(BuildContext context, Offset tapPosition, String id, AccountController accountController) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      tapPosition.dx + 1.0,
      tapPosition.dy * 1.0,
    ),
    items: [
      PopupMenuItem(
        onTap: () {
          Get.find<SearchViewController>().initController(accountForSearch: getAccountNameFromId(id));
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => const AccountOptionDialog(),
          );
        },
        value: 'details',
        child: ListTile(
          leading: Icon(
            Icons.search,
            color: Colors.blue.shade300,
          ),
          title: const Text('عرض الحركات'),
        ),
      ),
      PopupMenuItem(
        value: 'delete',
        onTap: () {
          HiveDataBase.mainAccountModelBox.delete(id);
          accountController.update();
        },
        child: ListTile(
          leading: Icon(
            Icons.remove_circle_outline,
            color: Colors.red.shade700,
          ),
          title: const Text('حذف'),
        ),
      ),
    ],
  );
}
