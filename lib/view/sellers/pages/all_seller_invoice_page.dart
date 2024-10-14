import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/view/sellers/pages/add_seller_page.dart';
import 'package:ba3_business_solutions/view/sellers/pages/seller_targets_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/invoice/discount_pluto_edit_view_model.dart';
import '../../../controller/invoice/invoice_pluto_edit_view_model.dart';
import '../../../controller/seller/target_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../../core/shared/widgets/grid_column_item.dart';
import '../../../core/utils/date_range_picker.dart';
import '../../invoices/pages/new_invoice_view.dart';

class AllSellerInvoicePage extends StatelessWidget {
  final String? oldKey;

  const AllSellerInvoicePage({super.key, this.oldKey});

  @override
  Widget build(BuildContext context) {
    SellersController controller = Get.find<SellersController>();
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text("سجل مبيعات: ${controller.allSellers[oldKey]?.sellerName ?? ""}"),
                actions: [
                  const Text("فلتر"),
                  const SizedBox(
                    width: 20,
                  ),
                  DateRangePicker(
                    onSubmit: (dates) {
                      controller.dateRange = dates;
                      controller.filter(dates, oldKey);
                    },
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        controller.dateRange = null;
                        controller.initSellerPage(oldKey);
                        controller.update();
                      },
                      child: const Text("افراغ الفلتر")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => AddSellerPage(
                              oldKey: oldKey,
                            ));
                      },
                      child: const Text("تعديل")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.find<TargetController>().initSeller(oldKey!);
                        Get.to(() => SellerTargetPage(sellerId: oldKey!));
                      },
                      child: const Text("التارغيت")),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              body: controller.allSellers.isEmpty
                  ? const CircularProgressIndicator()
                  : StreamBuilder(
                      stream: controller.allSellers.stream,
                      builder: (context, snapshot) {
                        return GetBuilder<SellersController>(builder: (controller) {
                          if (controller.dateRange == null) {
                            controller.initSellerPage(oldKey);
                          }
                          return SfDataGrid(
                            onCellTap: (DataGridCellTapDetails details) {
                              if (details.rowColumnIndex.rowIndex != 0) {
                                final rowIndex = details.rowColumnIndex.rowIndex - 1;
                                var rowData = controller.recordViewDataSource[rowIndex];
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
                              }
                            },
                            columns: <GridColumn>[
                              GridColumn(
                                visible: false,
                                allowEditing: false,
                                columnName: AppConstants.rowSellerAllInvoiceInvId,
                                label: const Text('ID'),
                              ),
                              gridColumnItem(
                                label: "قيمة الفاتورة",
                                name: AppConstants.rowSellerAllInvoiceAmount,
                                color: Colors.blue.shade700,
                                fontSize: 18,
                              ),
                              gridColumnItem(
                                label: "تاريخ الفاتورة",
                                name: AppConstants.rowSellerAllInvoiceAmount,
                                color: Colors.blue.shade700,
                                fontSize: 18,
                              ),
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
