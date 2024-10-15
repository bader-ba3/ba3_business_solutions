import 'package:ba3_business_solutions/controller/invoice/invoice_controller.dart';
import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/discount_pluto_edit_controller.dart';
import '../../../controller/invoice/invoice_pluto_edit_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/shared/Widgets/new_pluto.dart';
import 'new_invoice_view.dart';

class AllInvoice extends StatelessWidget {
  const AllInvoice({super.key, required this.listDate, required this.productName});

  final List<String> listDate;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع الفواتير",
        type: AppConstants.globalTypeInvoice,
        onLoaded: (e) {},
        onSelected: (p0) {
          print(p0.row?.cells["الرقم التسلسلي"]?.value);
          Get.to(
            () => InvoiceView(
              billId: p0.row?.cells["الرقم التسلسلي"]?.value,
              patternId: p0.row?.cells["النمط"]?.value,
            ),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => InvoicePlutoController());
              Get.lazyPut(() => DiscountPlutoController());
            }),
          );
          /*   Get.to(() => InvoiceView(
                billId: p0.row?.cells["الرقم التسلسلي"]?.value,
                patternId: "",
              ));*/
        },
        modelList: controller.invoiceModel.values.where(
          (element) {
            if (!HiveDataBase.getWithFree() && getPatTypeFromId(element.patternId!) == AppConstants.invoiceTypeBuy) {
              return element.invRecords!.where(
                (element) {
                  return getProductModelFromId(element.invRecProduct)?.prodIsLocal == false;
                },
              ).isEmpty;
            } else {
              return true;
            }
          },
        ).where(
          (element) {
            if (productName != null && productName != "") {
              return listDate.contains((element.invDate?.split(" ")[0] ?? "")) &&
                  (element.invRecords
                          ?.where(
                            (invRecord) => invRecord.invRecProduct == productName,
                          )
                          .isNotEmpty ??
                      false);
            } else {
              return listDate.contains((element.invDate?.split(" ")[0] ?? ""));
            }
          },
        ).toList(),
      );
    });
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
