import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';

import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/cheque_model.dart';

import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/utils/see_details.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:ba3_business_solutions/view/cheques/add_cheque.dart';
import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Const/const.dart';
import '../../utils/date_range_picker.dart';

class AllSellerInvoice extends StatelessWidget {
  final String? oldKey;

  AllSellerInvoice({super.key, this.oldKey});
  List<DateTime>? dateRange;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SellersViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(oldKey ?? "new"),
        actions: [
          Text("Filter"),
          SizedBox(
            width: 20,
          ),
          DateRangePicker(
            onSubmit: (_) {
              dateRange = _;
              controller.filter(_, oldKey);
            },
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                dateRange = null;
                controller.initSellerPage(oldKey);
                controller.update();
              },
              child: Text("Clear")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => AddSeller(
                      oldKey: oldKey,
                    ));
              },
              child: Text("edit")),
        ],
      ),
      body: controller.allSellers.isEmpty
          ? CircularProgressIndicator()
          :
          // String model = controller.allAccounts.keys.toList()[index];
          // AccountModel accountModel=controller.accountListMyId[model]!;
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection(Const.sellersCollection).doc(oldKey).collection(Const.recordCollection).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return GetBuilder<SellersViewModel>(builder: (controller) {
                    if (dateRange == null) controller.initSellerPage(oldKey);
                    return SfDataGrid(
                      onCellTap: (DataGridCellTapDetails details) {
                        if (details.rowColumnIndex.rowIndex != 0) {
                          final rowIndex = details.rowColumnIndex.rowIndex - 1;
                          var rowData = controller.recordViewDataSource[rowIndex];
                          String model = rowData.getCells()[0].value;
                          print('Tapped Row Data: $model');
                          seeDetails(model);
                          // logger(
                          //     newData: ChequeModel(
                          //       cheqId: model,
                          //     ),
                          //     transfersType: TransfersType.read);
                        }
                      },
                      columns: <GridColumn>[
                        GridColumnItem(label: "الرمز التسلسلي", name: Const.rowSellerAllInvoiceInvId),
                        GridColumnItem(label: "قيمة الفاتورة", name: Const.rowSellerAllInvoiceAmount),
                        GridColumnItem(label: "تاريخ الفاتورة", name: Const.rowSellerAllInvoiceAmount),
                      ],
                      source: controller.recordViewDataSource,
                      allowEditing: false,
                      selectionMode: SelectionMode.none,
                      editingGestureType: EditingGestureType.tap,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.fill,
                    );
                  });
                }
              }),
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
