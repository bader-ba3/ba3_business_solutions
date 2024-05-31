import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../utils/logger.dart';
import '../widget/filtering_data_grid.dart';

class AllAccount extends StatelessWidget {
  const AllAccount({super.key});

  @override
  Widget build(BuildContext context) {
    AccountViewModel accountViewModel = Get.find<AccountViewModel>();
    RxMap<String, AccountModel> data = accountViewModel.accountList;
    return Scaffold(
      body: FilteringDataGrid<AccountModel>(
        title: "الحسابات",
        constructor: AccountModel(),
        dataGridSource: data,
        onCellTap: (index,id,init) {
          AccountModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => AccountDetails(
            initFun:init,
            modelKey: model.accId!,
          ));
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          final a = await compute<({IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.isolateViewModel.accountList.values.toList()
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey()!, value: order.affectedId()),
              ...order!.toAR().entries.map((mapEntry) {
                if (int.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<int>(columnName: mapEntry.key, value: int.parse(mapEntry.value.toString()));
                } else if (double.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<double>(columnName: mapEntry.key, value: double.parse(double.parse(mapEntry.value.toString()).toStringAsFixed(2)));
                }else if(DateTime.tryParse(mapEntry.value.toString())!=null){
                  return DataGridCell<DateTime>(columnName: mapEntry.key, value: DateTime.parse(mapEntry.value.toString()));
                }else{
                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
                }
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;
        },
      ),
    );
  }
}
