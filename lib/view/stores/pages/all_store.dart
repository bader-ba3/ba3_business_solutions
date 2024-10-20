import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/grid_column_item.dart';
import 'store_details.dart';

class AllStore extends StatelessWidget {
  const AllStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المستودعات"),
          actions: const [
            // ElevatedButton(
            //     onPressed: () {
            //       Get.to(AddStore());
            //     },
            //     child: Text("add"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<StoreController>(builder: (storeController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SfDataGrid(
                    horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                    verticalScrollPhysics: const BouncingScrollPhysics(),
                    controller: storeController.storeDataGridController,
                    onCellTap: (details) {
                      if (details.rowColumnIndex.rowIndex != 0) {
                        var stId = (storeController.storeDataGridSource?.dataGridRows[details.rowColumnIndex.rowIndex - 1]
                            .getCells()
                            .firstWhere((element) => element.columnName == AppConstants.stId)
                            .value);

                        Get.to(() => StoreDetails(
                              oldKey: stId,
                            ));
                      }
                    },
                    columns: <GridColumn>[
                      GridColumn(visible: false, allowEditing: false, columnName: "stId", label: const Text('ID')),
                      gridColumnItem(label: "الرمز", name: AppConstants.stCode),
                      gridColumnItem(label: "الاسم", name: AppConstants.stName),
                    ],
                    source: storeController.storeDataGridSource!,
                    allowEditing: false,
                    selectionMode: SelectionMode.none,
                    editingGestureType: EditingGestureType.tap,
                    navigationMode: GridNavigationMode.cell,
                    columnWidthMode: ColumnWidthMode.fill,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
