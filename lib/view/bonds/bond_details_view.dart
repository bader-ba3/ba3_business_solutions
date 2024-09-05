import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/Dialogs/SearchAccuntTextDialog.dart';
import 'package:ba3_business_solutions/Widgets/Bond_Record_Pluto_View_Model.dart';
import 'package:ba3_business_solutions/Widgets/CustomPlutoShortCut.dart';
import 'package:ba3_business_solutions/Widgets/Custom_Pluto_With_Edite.dart';
import 'package:ba3_business_solutions/Widgets/GetAccountEnterPlutoAction.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Services/Get_Date_From_String.dart';
import '../../controller/account_view_model.dart';
import '../../utils/confirm_delete_dialog.dart';
import '../entry_bond/entry_bond_details_view.dart';
import '../invoices/widget/custom_TextField.dart';
import '../widget/CustomWindowTitleBar.dart';

class BondDetailsView extends StatefulWidget {
  const BondDetailsView({
    Key? key,
    required this.bondType,
    this.oldId,
  }) : super(key: key);

  final String? oldId;
  final String bondType;

  @override
  _BondDetailsViewState createState() => _BondDetailsViewState();
}

class _BondDetailsViewState extends State<BondDetailsView> {
  var bondController = Get.find<BondViewModel>();
  var globalController = Get.find<GlobalViewModel>();
  var plutoBondController = Get.find<BondRecordPlutoViewModel>();
  bool isDebitOrCredit=true;
  @override
  void initState() {
    super.initState();
    bondController.initPage(oldId: widget.oldId, type: widget.bondType);
    bondController.lastBondOpened = widget.oldId;
    isDebitOrCredit = widget.bondType == Const.bondTypeCredit || widget.bondType == Const.bondTypeDebit;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GetBuilder<BondViewModel>(builder: (controller) {
              return Scaffold(
                appBar: AppBar(centerTitle: true, title: Text((getBondTypeFromEnum(bondController.tempBondModel.bondType.toString()))), leading: const BackButton(), actions: [
                  IconButton(
                      onPressed: () {
                        bondController.bondNextOrPrev(widget.bondType, true);
                        setState(() {});
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_right)),
                  SizedBox(
                    width: 100,
                    child: CustomTextFieldWithoutIcon(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSubmitted: (_) {
                        controller.getBondByCode(widget.bondType, _);
                      },
                      controller: controller.codeController,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        bondController.bondNextOrPrev(widget.bondType, false);
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_left)),
                ]),
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: Get.width,
                          child: Wrap(
                            spacing: 20,
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 10,
                            children: [
                              SizedBox(
                                width: Get.width * 0.45,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 100, child: Text("البيان")),
                                    Expanded(
                                      child: CustomTextFieldWithoutIcon(controller: controller.noteController),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 100, child: Text("تاريخ السند : ", style: TextStyle())),
                                    Expanded(
                                      child: CustomTextFieldWithIcon(
                                        controller: controller.dateController,
                                        onSubmitted: (text) async {
                                          controller.dateController.text = getDateFromString(text);
                                          controller.update();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isDebitOrCredit)
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "الحساب : ",
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomTextFieldWithIcon(
                                          controller: controller.debitOrCreditController,
                                          onSubmitted: (text) async {
                                            controller.debitOrCreditController.text = await searchAccountTextDialog(text) ?? "";
                                            // invoiceController.getAccountComplete();
                                            // invoiceController.changeSecAccount();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(child: GetBuilder<BondRecordPlutoViewModel>(builder: (controller) {
                          return CustomPlutoWithEdite(
                            controller: controller,
                            shortCut: customPlutoShortcut(GetAccountEnterPlutoGridAction(controller, "bondRecAccount")),
                            onRowSecondaryTap: (event) {
                              if (event.cell.column.field == "bondRecId") {
                                Get.defaultDialog(title: "تأكيد الحذف", content: const Text("هل انت متأكد من حذف هذا العنصر"), actions: [
                                  AppButton(
                                      title: "نعم",
                                      onPressed: () {
                                        controller.clearRowIndex(event.rowIdx);
                                      },
                                      iconData: Icons.check),
                                  AppButton(
                                    title: "لا",
                                    onPressed: () {
                                      Get.back();
                                    },
                                    iconData: Icons.clear,
                                    color: Colors.red,
                                  ),
                                ]);
                              }
                            },
                            onChanged: (event) {
                              if (event.column.field == "bondRecDebitAmount") {
                                controller.updateCellValue("bondRecDebitAmount", extractNumbersAndCalculate(event.row.cells["bondRecDebitAmount"]?.value));
                                if (widget.bondType != Const.bondTypeDebit && widget.bondType != Const.bondTypeCredit) {
                                  if ((double.tryParse(event.row.cells["bondRecCreditAmount"]?.value) ?? 0) > 0) {
                                    controller.updateCellValue("bondRecCreditAmount", "");
                                  }
                                }
                              } else if (event.column.field == "bondRecCreditAmount") {
                                controller.updateCellValue("bondRecCreditAmount", extractNumbersAndCalculate(event.row.cells["bondRecCreditAmount"]?.value));
                                if (widget.bondType != Const.bondTypeDebit && widget.bondType != Const.bondTypeCredit) {
                                  if ((double.tryParse(event.row.cells["bondRecDebitAmount"]?.value) ?? 0) > 0) {
                                    controller.updateCellValue("bondRecDebitAmount", "");
                                  }
                                }
                              }
                            },
                          );
                        })),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<BondRecordPlutoViewModel>(builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 350,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "المجموع",
                                        )),
                                    Container(
                                        width: 120,
                                        color: controller.checkIfBalancedBond(
                                          isDebit: widget.bondType == Const.bondTypeDebit
                                              ? true
                                              : widget.bondType == Const.bondTypeCredit
                                                  ? false
                                                  : null,
                                        )
                                            ? Colors.green
                                            : Colors.red,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            controller
                                                .calcDebitTotal(
                                                  isDebit: widget.bondType == Const.bondTypeDebit
                                                      ? true
                                                      : widget.bondType == Const.bondTypeCredit
                                                          ? false
                                                          : null,
                                                )
                                                .toStringAsFixed(2),
                                            style: const TextStyle(color: Colors.white, fontSize: 18))),
                                    const SizedBox(width: 10),
                                    Container(
                                        width: 120,
                                        color: controller.checkIfBalancedBond(
                                          isDebit: widget.bondType == Const.bondTypeDebit
                                              ? true
                                              : widget.bondType == Const.bondTypeCredit
                                                  ? false
                                                  : null,
                                        )
                                            ? Colors.green
                                            : Colors.red,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            controller
                                                .calcCreditTotal(
                                                  isDebit: widget.bondType == Const.bondTypeDebit
                                                      ? true
                                                      : widget.bondType == Const.bondTypeCredit
                                                          ? false
                                                          : null,
                                                )
                                                .toStringAsFixed(2),
                                            style: const TextStyle(color: Colors.white, fontSize: 18))),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 350,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 100, child: Text("الفرق")),
                                    Container(
                                        width: 250,
                                        color: controller.checkIfBalancedBond(
                                          isDebit: widget.bondType == Const.bondTypeDebit
                                              ? true
                                              : widget.bondType == Const.bondTypeCredit
                                                  ? false
                                                  : null,
                                        )
                                            ? Colors.green
                                            : Colors.red,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            controller
                                                .getDefBetweenCreditAndDebt(
                                                  isDebit: widget.bondType == Const.bondTypeDebit
                                                      ? true
                                                      : widget.bondType == Const.bondTypeCredit
                                                          ? false
                                                          : null,
                                                )
                                                .toStringAsFixed(2),
                                            style: const TextStyle(color: Colors.white, fontSize: 18))),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                        const Divider(),
                        Wrap(
                          spacing: 10,
                          runSpacing: 20,
                          children: [
                            AppButton(
                                title: bondController.isNew ? "إضافة" : "تعديل",
                                onPressed: () {
                                  bool isDebitBond = widget.bondType == Const.bondTypeDebit;
                                  bool isCreditBond = widget.bondType == Const.bondTypeCredit;
                                  bool isBalancedBond = plutoBondController.checkIfBalancedBond(isDebit: isDebitBond ? true : (isCreditBond ? false : null));
                                  bool hasValidAccount = getAccountIdFromText(controller.debitOrCreditController.text) != "";
                                  bool isDateValid = DateTime.tryParse(bondController.dateController.text) != null;
                                  bool isDebitOrCreditWithAccount = (isDebitOrCredit) && hasValidAccount;

                                  bool isValidBondForSave = (plutoBondController
                                              .handleSaveAll(
                                                isCredit: isDebitBond ? false : (isCreditBond ? true : null),
                                                account: controller.debitOrCreditController.text,
                                              )
                                              .length >
                                          1) &&
                                      isDateValid;

                                  if ((isDebitOrCreditWithAccount && isValidBondForSave) || (!isDebitOrCredit && isBalancedBond && isValidBondForSave)) {
                                    if (bondController.isNew) {
                                      checkPermissionForOperation(Const.roleUserWrite, Const.roleViewBond).then((value) async {
                                        if (value) {
                                          await globalController.addGlobalBond(GlobalModel(
                                              bondCode: controller.codeController.text,
                                              bondDate: bondController.dateController.text,
                                              bondRecord: plutoBondController.handleSaveAll(
                                                isCredit: widget.bondType == Const.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == Const.bondTypeDebit
                                                    ? false
                                                    : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              entryBondRecord: plutoBondController.handleSaveAllForEntry(
                                                isCredit: widget.bondType == Const.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == Const.bondTypeDebit
                                                    ? false
                                                    : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              bondDescription: bondController.noteController.text,
                                              bondType: widget.bondType,
                                              bondTotal: "0"));
                                          //bondController.postOneBond(isNew, withLogger: true);
                                          bondController.isNew = false;
                                          controller.isEdit = false;
                                        }
                                      });
                                    } else {
                                      checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewBond).then((value) async {
                                        if (value) {
                                          bondController.isNew = false;
                                          controller.isEdit = false;
                                          await globalController.updateGlobalBond(GlobalModel(
                                              entryBondCode: controller.tempBondModel.entryBondCode,
                                              entryBondRecord: plutoBondController.handleSaveAllForEntry(
                                                isCredit: widget.bondType == Const.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == Const.bondTypeDebit
                                                    ? false
                                                    : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              bondCode:controller.tempBondModel.bondCode,
                                              globalType: Const.globalTypeBond,
                                              entryBondId:controller.tempBondModel.entryBondId,
                                              bondDate: bondController.dateController.text,
                                              bondRecord: plutoBondController.handleSaveAll(
                                                isCredit: widget.bondType == Const.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == Const.bondTypeDebit
                                                    ? false
                                                    : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              bondId: controller.tempBondModel.bondId,
                                              bondDescription: bondController.noteController.text,
                                              bondType: widget.bondType,
                                              bondTotal: "0"));
                                          // await globalController.updateGlobalBond(bondController.tempBondModel);
                                          // bondController.updateBond(modelKey: widget.oldModelKey, withLogger: true);
                                        }
                                      });
                                    }
                                  } else {
                                    Get.snackbar("خطأ", "يرجى مراجعة السند", icon: const Icon(Icons.error_outline_outlined));
                                  }
                                },
                                iconData: bondController.isNew ? Icons.add : Icons.edit),
                            AppButton(
                                title: "جديد",
                                onPressed: () {
                                  controller.initPage(type: widget.bondType);
                                },
                                iconData: Icons.new_label_outlined),
                            if (!bondController.isNew && controller.bondModel.originId == null) ...[
                              AppButton(
                                title: "حذف",
                                onPressed: () async {
                                  confirmDeleteWidget().then((value) {
                                    if (value) {
                                      checkPermissionForOperation(Const.roleUserDelete, Const.roleViewBond).then((value) async {
                                        if (value) {
                                          globalController.deleteGlobal(bondController.tempBondModel);
                                          Get.back();
                                          controller.update();
                                        }
                                      });
                                    }
                                  });
                                },
                                iconData: Icons.delete_outline,
                                color: Colors.red,
                              ),
                              AppButton(
                                  title: "السند",
                                  onPressed: () {
                                    Get.to(() => EntryBondDetailsView(
                                          oldId: controller.tempBondModel.entryBondId,
                                        ));
                                    // EntryBond
                                  },
                                  iconData: Icons.file_open_outlined)
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
/*         return SfDataGrid(
                                    horizontalScrollPhysics: NeverScrollableScrollPhysics(),
                                    verticalScrollPhysics: BouncingScrollPhysics(),
                                    source: bondController.recordDataSource,
                                    allowEditing: controller.bondModel.originId == null,
                                    selectionMode: SelectionMode.singleDeselect,
                                    editingGestureType: EditingGestureType.tap,
                                    navigationMode: GridNavigationMode.cell,
                                    columnWidthMode: ColumnWidthMode.fill,
                                    controller: bondController.dataGridController,
                                    allowSwiping: controller.bondModel.originId == null,
                                    swipeMaxOffset: 200,
                                    onSwipeStart: (swipeStartDetails) {
                                      if (swipeStartDetails.swipeDirection == DataGridRowSwipeDirection.endToStart) {
                                        return false;
                                      }
                                      if (swipeStartDetails.rowIndex == bondController.tempBondModel.bondRecord?.length || bondController.tempBondModel.bondRecord?.length == 1) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
                                      return GestureDetector(
                                          onTap: () {
                                            controller.deleteOneRecord(rowIndex);
                                            controller.initPage(bondController.tempBondModel.bondType);
                                          },
                                          child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                                    },
                                    columns: <GridColumn>[
                                      gridColumnItem(label: "الرمز التسلسلي", name: Const.rowBondId),
                                      gridColumnItem(label: 'الحساب', name: Const.rowBondAccount),
                                      gridColumnItem(label: ' مدين', name: Const.rowBondDebitAmount),
                                      gridColumnItem(label: ' دائن', name: Const.rowBondCreditAmount),
                                      gridColumnItem(label: "البيان", name: Const.rowBondDescription),
                                    ],
                                  );*/

///-------------------------
/*plutoBondController.checkIfBalancedBond(
                                            isDebit: widget.bondType == Const.bondTypeDebit
                                                ? true
                                                : widget.bondType == Const.bondTypeCredit
                                                    ? false
                                                    : null,
                                          ) &&
                                          plutoBondController
                                                  .handleSaveAll(
                                                    isCredit: widget.bondType == Const.bondTypeDebit
                                                        ? false
                                                        : widget.bondType == Const.bondTypeCredit
                                                            ? true
                                                            : null,
                                                    account: controller.debitOrCreditController.text,
                                                  )
                                                  .length >
                                              1 &&
                                          DateTime.tryParse(bondController.dateController.text) != null*/
//-----------------
/*       if ((widget.bondType == Const.bondTypeDebit || widget.bondType == Const.bondTypeCredit && getAccountIdFromText(controller.debitOrCreditController.text) != "") ||
                                      (widget.bondType != Const.bondTypeDebit || widget.bondType != Const.bondTypeCredit) &&
                                          (plutoBondController.checkIfBalancedBond(
                                                isDebit: widget.bondType == Const.bondTypeDebit
                                                    ? true
                                                    : widget.bondType == Const.bondTypeCredit
                                                        ? false
                                                        : null,
                                              ) &&
                                              plutoBondController
                                                      .handleSaveAll(
                                                        isCredit: widget.bondType == Const.bondTypeDebit
                                                            ? false
                                                            : widget.bondType == Const.bondTypeCredit
                                                                ? true
                                                                : null,
                                                        account: controller.debitOrCreditController.text,
                                                      )
                                                      .length >
                                                  1 &&
                                              DateTime.tryParse(bondController.dateController.text) != null))*/
