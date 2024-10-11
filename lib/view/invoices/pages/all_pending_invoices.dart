import 'package:ba3_business_solutions/controller/invoice/invoice_view_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/Widgets/new_pluto.dart';
import '../../../controller/invoice/discount_pluto_edit_view_model.dart';
import '../../../controller/invoice/invoice_pluto_edit_view_model.dart';
import 'new_invoice_view.dart';

class AllPendingInvoice extends StatelessWidget {
  const AllPendingInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceViewModel>(builder: (controller) {
      return controller.invoiceModel.values
              .where(
                (e) => e.invIsPending!,
              )
              .isEmpty
          ? Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text("لا يوجد فواتيير غير مأكدة"),
              ),
            )
          : CustomPlutoGridWithAppBar(
              title: "جميع الفواتير",
              onLoaded: (e) {},
              type: AppConstants.globalTypeInvoice,
              onSelected: (p0) {
                Get.to(
                  () => InvoiceView(
                    billId: p0.row?.cells["الرقم التسلسلي"]?.value,
                    patternId: p0.row?.cells["النمط"]?.value,
                  ),
                  binding: BindingsBuilder(() {
                    Get.lazyPut(() => InvoicePlutoViewModel());
                    Get.lazyPut(() => DiscountPlutoViewModel());
                  }),
                );
              },
              modelList: controller.invoiceModel.values
                  .where(
                    (e) => e.invIsPending!,
                  )
                  .toList(),
            );
    });
  }
}
/* FilteringDataGrid<GlobalModel>(
        title: "كل الفواتير الغير مؤكدة",
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
          final a = await compute<({List<dynamic> a,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.a
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey(), value: order.affectedId()),
              ...order!.toMap().entries.map((mapEntry) {
                if (int.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<int>(columnName: mapEntry.key, value: int.parse(mapEntry.value.toString()));
                } else if (double.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<double>(columnName: mapEntry.key, value: double.parse(mapEntry.value.toString()));
                }else if(DateTime.tryParse(mapEntry.value.toString())!=null){
                  return DataGridCell<DateTime>(columnName: mapEntry.key, value: DateTime.parse(mapEntry.value.toString()));
                }else{
                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
                }
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(a: data.values.where((e) => e.invIsPending!,).toList(),isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;
        },
      ),*/
