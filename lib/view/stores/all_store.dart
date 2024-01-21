import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/view/stores/add_store.dart';
import 'package:ba3_business_solutions/view/stores/store_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Const/const.dart';
import '../accounts/acconts_view.dart';

class AllStore extends StatelessWidget {
  AllStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl ,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المستودعات"),
          actions: [
            // ElevatedButton(
            //     onPressed: () {
            //       Get.to(AddStore());
            //     },
            //     child: Text("add"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<StoreViewModel>(builder: (storeController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Flexible(
                //       flex: 1,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           const Flexible(flex: 2, child: Text("Store Name :")),
                //           Flexible(flex: 3, child: customTextFieldWithoutIcon(storeController.nameController, true)),
                //         ],
                //       ),
                //     ),
                //     Flexible(
                //       flex: 1,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           const Flexible(flex: 2, child: Text("Store code :")),
                //           Flexible(flex: 3, child: customTextFieldWithoutIcon(storeController.codeController, true)),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 25,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     ElevatedButton(
                //         style: ButtonStyle(
                //           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                //         ),
                //         onPressed: () {
                //           storeController.addNewStore(storeController.initStoreModel());
                //         },
                //         child: const Text("Add")),
                //     ElevatedButton(
                //         style: ButtonStyle(
                //           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                //           mouseCursor: MaterialStateProperty.all<MouseCursor>(storeController.idController.text == "" ? SystemMouseCursors.forbidden : SystemMouseCursors.click),
                //         ),
                //         onPressed: () {
                //           if (storeController.idController.text != "") {
                //             storeController.editStore(storeController.initStoreModel());
                //           }
                //         },
                //         child: const Text("Edit")),
                //     ElevatedButton(
                //         style: ButtonStyle(
                //           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                //         ),
                //         onPressed: () {
                //           storeController.clearController();
                //           storeController.getNewCode();
                //         },
                //         child: const Text("New")),
                //     ElevatedButton(
                //         style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                //           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                //           mouseCursor: MaterialStateProperty.all<MouseCursor>(storeController.idController.text == "" ? SystemMouseCursors.forbidden : SystemMouseCursors.click),
                //         ),
                //         onPressed: () {
                //           if (storeController.idController.text != "") {
                //             storeController.deleteStore(storeController.initStoreModel());
                //           }
                //         },
                //         child: const Text("Delete")),
                //   ],
                // ),
                // const SizedBox(
                //   height: 25,
                // ),
                Expanded(
                  child: SfDataGrid(
                    controller: storeController.storeDataGridController,
                    onCellTap: (details) {
                      if (details.rowColumnIndex.rowIndex != 0) {
                        var stId = (storeController.recordViewDataSource?.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells().firstWhere((element) => element.columnName == Const.stId).value);
                        Get.to(StoreDetails(
                          oldKey: stId,
                        ));
                      }
                    },
                    columns: <GridColumn>[
                      GridColumn(
                          visible: false,
                          allowEditing: false,
                          columnName: "stId",
                          label: const Text('ID'
                          )),
                      GridColumnItem(
                        label: "الرمز",
                        name: Const.stCode,
                      ),
                      GridColumnItem(label: "الاسم", name: Const.stName),
                    ],
                    source: storeController.recordViewDataSource!,
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
