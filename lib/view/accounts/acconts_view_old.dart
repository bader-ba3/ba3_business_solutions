import 'package:ba3_business_solutions/controller/account_view_model.dart';

import 'package:ba3_business_solutions/model/account_model.dart';

import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/accounts/account_tree_view.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Const/const.dart';

class AccountsViewOLD extends StatelessWidget {
  const AccountsViewOLD({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<AccountViewModel>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الحسابات"),
          // actions: [
          //   ElevatedButton(
          //       onPressed: () {
          //         Get.to(() => AddAccount());
          //       },
          //       child: Text("Add New Account")),
          //   ElevatedButton(
          //       onPressed: () {
          //         Get.to(() => AccountTreeView());
          //       },
          //       child: Text("tree view")),
          // ],
        ),
        body:
            // String model = controller.allAccounts.keys.toList()[index];
            // AccountModel accountModel=controller.accountListMyId[model]!;
            StreamBuilder(
                stream: controller.accountList.stream,
                builder: (context, snapshot) {
                  if (controller.accountList.isEmpty) {
                    return Center(child: Text("لا يوجد لديك حسابات بعد"),);
                  } else {
                    return GetBuilder<AccountViewModel>(builder: (controller) {
                      controller.initAccountViewPage();
                      return SfDataGrid(
                        onCellTap: (DataGridCellTapDetails details) {
                          final rowIndex = details.rowColumnIndex.rowIndex - 1;
                          var rowData = controller.recordViewDataSource[rowIndex];
                          String model = rowData.getCells()[0].value;
                          logger(newData: AccountModel(accId: model), transfersType: TransfersType.read);
                          Get.to(() => AccountDetails(modelKey: model));
                        },
                        columns: <GridColumn>[
                          GridColumn(
                              visible: false,
                              allowEditing: false,
                              columnName: Const.rowViewAccountId,
                              label: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                                  color: Colors.grey,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'ID',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          // GridColumnItem(label: "id", name: Const.rowViewAccountId),
                          GridColumnItem(label: "رقم المستخدم", name: Const.rowViewAccountCode),
                          GridColumnItem(label: 'اسم المستخدم', name: Const.rowViewAccountName),
                          GridColumnItem(label: 'رصيد المستخدم', name: Const.rowViewAccountBalance),
                          GridColumnItem(label: 'عدد الحركات', name: Const.rowViewAccountLength),
                        ],
                        source: controller.recordViewDataSource,
                        allowEditing: false,
                        selectionMode: SelectionMode.multiple,
                        selectionManager: SelectionManagerBase(),
                        onSelectionChanged: (addedRows, removedRows) {
                          print(addedRows);
                          print(removedRows);
                        },
                        editingGestureType: EditingGestureType.tap,
                        navigationMode: GridNavigationMode.cell,
                        columnWidthMode: ColumnWidthMode.fill,
                      );
                    });
                  }
                }),
      ),
    );
  }
}

GridColumn GridColumnItem({required label, name}) {
  return GridColumn(
      allowEditing: false,
      columnName: name,
      label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            label.toString(),
          )));
}
