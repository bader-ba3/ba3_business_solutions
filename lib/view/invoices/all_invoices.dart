import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/const.dart';
import '../../Widgets/new_Pluto.dart';
import 'invoice_view.dart';

class AllInvoice extends StatelessWidget {
  const AllInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceViewModel>(
      builder: (controller) {
        return  CustomPlutoGrid(
          title: "جميع الفواتير",
          type:Const.globalTypeInvoice,

          onLoaded: (e){
          },
          onSelected: (p0) {
            Get.to(() => InvoiceView(
              billId:p0.row?.cells["الرقم التسلسلي"]?.value,
              patternId: "",
            ));
          },
          modelList: controller.invoiceModel.values.toList(),

        );
      }
    );
  }
}

/* FilteringDataGrid<GlobalModel>(
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
          final a = await compute<({List<dynamic> invoiceModel,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.invoiceModel
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey(), value: order.affectedId()),
              ...order!.toMap().entries.map((mapEntry) {

                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());

              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(invoiceModel: data.values.toList(),isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;
        },
      )*/