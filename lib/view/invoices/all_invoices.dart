import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
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

import '../../controller/pattern_model_view.dart';
import '../../controller/sellers_view_model.dart';
import '../../model/global_model.dart';
import '../../utils/logger.dart';
import '../widget/filtering_data_grid.dart';
import 'invoice_view.dart';

class AllInvoice extends StatelessWidget {
  const AllInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
    RxMap<String, GlobalModel>data = invoiceViewModel.invoiceModel;
    return Scaffold(
      body: FilteringDataGrid<GlobalModel>(
        title: "الفواتير",
        constructor: GlobalModel(),
        dataGridSource: data,
        globalType: Const.globalTypeInvoice,
        onCellTap: (index,id,init) {
          GlobalModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => InvoiceView(
            billId: model.invId!,
            patternId: "",
          ));
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          print("from invoice View");
          final a = await compute<({List<dynamic> a,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.a
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey(), value: order.affectedId()),
              ...order!.toAR().entries.map((mapEntry) {

                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());

              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(a: data.values.toList(),isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource!.dataGridRows =a;
          return infoDataGridSource;
        },
      ),
    );
  }
}
