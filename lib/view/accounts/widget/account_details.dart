import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:ba3_business_solutions/view/entry_bond/entry_bond_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../controller/account_view_model.dart';

class AccountDetails extends StatefulWidget {
  final String modelKey;

  const AccountDetails({super.key, required this.modelKey});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  var accountController = Get.find<AccountViewModel>();
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  List<AccountRecordModel> record = <AccountRecordModel>[];

  @override
  void initState() {
    super.initState();

    accountController.initAccountPage(widget.modelKey);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<AccountViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    print(controller.accountList[widget.modelKey]!.toJson());
                    // controller.accountList[widget.modelKey]!.accChild.add("acc1720547397835219");
                    // HiveDataBase.accountModelBox.put(widget.modelKey, controller.accountList[widget.modelKey]!);
                    // FirebaseFirestore.instance.collection(Const.accountsCollection).doc(widget.modelKey).update(controller.accountList[widget.modelKey]!.toJson());
                    Get.to(AddAccount(modelKey: widget.modelKey));
                  },
                  child: Text("تعديل بطاقة الحساب")),

              const SizedBox(
                width: 20,
              ),
              if (controller.accountList[widget.modelKey]!.accRecord.isEmpty)
              ...[  ElevatedButton(
                    onPressed: () {
                      confirmDeleteWidget().then((value) {
                        if (value) {
                          checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewAccount).then((value) {
                            if (value) {
                              controller.deleteAccount(controller.accountList[widget.modelKey]!, withLogger: true);
                              Get.back();
                            }
                          });
                        }
                      });
                    },
                    child: Text("حذف")),    const SizedBox(
                width: 40,
              ),]
            ],
            title: Text(controller.accountList[widget.modelKey]?.accName ?? "error"),
          ),
          body: Column(
            children: [
              Expanded(
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SfDataGrid(
                      onCellTap: (DataGridCellTapDetails _) {
                        controller.recordDataSource.dataGridRows[_.rowColumnIndex.rowIndex - 1].getCells().forEach((element) {
                          if (element.columnName == Const.rowAccountId) {
                            var value = element.value;
                            Get.to(() => EntryBondDetailsView(
                                  oldId: value,
                                ));
                          }
                        });
                      },
                      source: controller.recordDataSource,
                      allowEditing: false,
                      selectionMode: SelectionMode.none,
                      editingGestureType: EditingGestureType.tap,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: <GridColumn>[
                        GridColumnItem(label: "الحساب", name: Const.rowAccountName),
                        GridColumnItem(label: "التاريخ", name: Const.rowAccountDate),
                        GridColumnItem(label: "النوع", name: Const.rowAccountType),
                        GridColumnItem(label: 'دائن', name: Const.rowAccountTotal),
                        GridColumnItem(label: 'المدين', name: Const.rowAccountTotal2),
                        GridColumnItem(label: ' الحساب بعد العملية', name: Const.rowAccountBalance),
                        GridColumn(
                            visible: false,
                            allowEditing: false,
                            columnName: Const.rowAccountId,
                            label: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ID',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        // GridColumnItem(label: 'الرمز التسلسي للعملية',name: Const.rowAccountId),
                      ],
                    )),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "الرصيد النهائي:",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(controller.getBalance(widget.modelKey).toStringAsFixed(2),
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 24),)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }),
    );
  }

  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: false,
        columnName: name,
        label: Container(
            color: Colors.blue.shade700,
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              label.toString(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            )));
  }
}
