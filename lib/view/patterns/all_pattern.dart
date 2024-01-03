import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';

import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_details.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../accounts/acconts_view.dart';

class AllPattern extends StatelessWidget {
  const AllPattern({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<PatternViewModel>().clearController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patterns"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.to(PatternDetails());
              },
              child: Text("Add New"))
        ],
      ),
      body: GetBuilder<PatternViewModel>(
        builder: (patternController) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: SfDataGrid(
                    onCellTap: (details) {
                      if (details.rowColumnIndex.rowIndex != 0) {
                        var stId = (patternController.recordViewDataSource?.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells().firstWhere((element) => element.columnName == Const.patId).value);
                        Get.to(PatternDetails(
                          oldKey: stId,
                        ));
                      }
                      // patternController.selectPattern(details);
                      // // print(details.rowColumnIndex.toString());
                    },
                    columns: <GridColumn>[
                      GridColumnItem(label: "ID", name: Const.patId),
                      GridColumnItem(label: Const.patCode, name: Const.patCode),
                      GridColumnItem(label: Const.patPrimary, name: Const.patPrimary),
                      GridColumnItem(label: Const.patName, name: Const.patName),
                      GridColumnItem(label: Const.patType, name: Const.patType),
                    ],
                    source: patternController.recordViewDataSource!,
                    allowEditing: false,
                    selectionMode: SelectionMode.none,
                    editingGestureType: EditingGestureType.tap,
                    navigationMode: GridNavigationMode.cell,
                    columnWidthMode: ColumnWidthMode.fill,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
