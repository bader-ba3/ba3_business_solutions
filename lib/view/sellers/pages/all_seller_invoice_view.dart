import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/view/sellers/pages/add_seller.dart';
import 'package:ba3_business_solutions/view/sellers/pages/seller_targets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/shared/widgets/CustomWindowTitleBar.dart';
import '../../../controller/invoice/discount_pluto_edit_view_model.dart';
import '../../../controller/invoice/invoice_pluto_edit_view_model.dart';
import '../../../core/utils/date_range_picker.dart';
import '../../invoices/pages/new_invoice_view.dart';

class AllSellerInvoice extends StatelessWidget {
  final String? oldKey;

  AllSellerInvoice({super.key, this.oldKey});

  List<DateTime>? dateRange = [];

  @override
  Widget build(BuildContext context) {
    SellersViewModel controller = Get.find<SellersViewModel>();
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                    "سجل مبيعات: ${controller.allSellers[oldKey]?.sellerName ?? ""}"),
                actions: [
                  const Text("فلتر"),
                  const SizedBox(
                    width: 20,
                  ),
                  DateRangePicker(
                    onSubmit: (_) {
                      dateRange = _;
                      controller.filter(_, oldKey);
                    },
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        dateRange = null;
                        controller.initSellerPage(oldKey);
                        controller.update();
                      },
                      child: const Text("افراغ الفلتر")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => AddSeller(
                              oldKey: oldKey,
                            ));
                      },
                      child: const Text("تعديل")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => SellerTarget(
                              sellerId: oldKey!,
                            ));
                      },
                      child: const Text("التارغيت")),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              body: controller.allSellers.isEmpty
                  ? const CircularProgressIndicator()
                  :
                  // String model = controller.allAccounts.keys.toList()[index];
                  // AccountModel accountModel=controller.accountListMyId[model]!;
                  StreamBuilder(
                      stream: controller.allSellers.stream,
                      builder: (context, snapshot) {
                        return GetBuilder<SellersViewModel>(
                            builder: (controller) {
                          if (dateRange == null) {
                            controller.initSellerPage(oldKey);
                          }
                          return SfDataGrid(
                            onCellTap: (DataGridCellTapDetails details) {
                              if (details.rowColumnIndex.rowIndex != 0) {
                                final rowIndex =
                                    details.rowColumnIndex.rowIndex - 1;
                                var rowData =
                                    controller.recordViewDataSource[rowIndex];
                                String model = rowData.getCells()[0].value;
                                print('Tapped Row Data: $model');
                                Get.to(
                                  () => InvoiceView(
                                    billId: model,
                                    patternId: '',
                                  ),
                                  binding: BindingsBuilder(() {
                                    Get.lazyPut(() => InvoicePlutoViewModel());
                                    Get.lazyPut(() => DiscountPlutoViewModel());
                                  }),
                                );
                                // logger(
                                //     newData: ChequeModel(
                                //       cheqId: model,
                                //     ),
                                //     transfersType: TransfersType.read);
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                  visible: false,
                                  allowEditing: false,
                                  columnName:
                                      AppStrings.rowSellerAllInvoiceInvId,
                                  label: const Text('ID')),
                              // GridColumnItem(label: "الرمز التسلسلي", name: Const.rowSellerAllInvoiceInvId),
                              GridColumnItem(
                                  label: "قيمة الفاتورة",
                                  name: AppStrings.rowSellerAllInvoiceAmount),
                              GridColumnItem(
                                  label: "تاريخ الفاتورة",
                                  name: AppStrings.rowSellerAllInvoiceAmount),
                            ],
                            source: controller.recordViewDataSource,
                            allowEditing: false,
                            selectionMode: SelectionMode.none,
                            editingGestureType: EditingGestureType.tap,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.fill,
                          );
                        });
                      }),
            ),
          ),
        ),
      ],
    );
  }
}

GridColumn GridColumnItem({required label, name}) {
  return GridColumn(
      allowEditing: false,
      columnName: name,
      label: Container(
          color: Colors.blue.shade700,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            label.toString(),
          )));
}
