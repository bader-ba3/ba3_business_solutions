import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/controller/global/global_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/shared/dialogs/SearchAccuntTextDialog.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_pluto_short_cut.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_pluto_with_edite.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:ba3_business_solutions/view/bonds/widget/bond_record_pluto_view_model.dart';
import 'package:ba3_business_solutions/view/bonds/widget/get_account_enter_pluto_action.dart';
import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_controller.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/services/Get_Date_From_String.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../entry_bond/pages/entry_bond_details_view.dart';
import '../../invoices/widget/custom_Text_field.dart';

class BondDetailsView extends StatefulWidget {
  const BondDetailsView({
    super.key,
    required this.bondType,
    this.oldId,
  });

  final String? oldId;
  final String bondType;

  @override
  _BondDetailsViewState createState() => _BondDetailsViewState();
}

class _BondDetailsViewState extends State<BondDetailsView> {
  var bondController = Get.find<BondController>();
  var globalController = Get.find<GlobalController>();
  var plutoBondController = Get.find<BondRecordPlutoViewModel>();
  bool isDebitOrCredit = true;

  @override
  void initState() {
    super.initState();
    print(widget.oldId);
    bondController.initPage(oldId: widget.oldId, type: widget.bondType);
    bondController.lastBondOpened = widget.oldId;
    isDebitOrCredit = widget.bondType == AppConstants.bondTypeCredit || widget.bondType == AppConstants.bondTypeDebit;
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
            child: GetBuilder<BondController>(builder: (controller) {
              return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text((getBondTypeFromEnum(bondController.tempBondModel.bondType.toString()))),
                    leading: const BackButton(),
                    actions: [
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
                                controller.updateCellValue(
                                    "bondRecDebitAmount", extractNumbersAndCalculate(event.row.cells["bondRecDebitAmount"]?.value));
                                if (widget.bondType != AppConstants.bondTypeDebit && widget.bondType != AppConstants.bondTypeCredit) {
                                  if ((double.tryParse(event.row.cells["bondRecCreditAmount"]?.value) ?? 0) > 0) {
                                    controller.updateCellValue("bondRecCreditAmount", "");
                                  }
                                }
                              } else if (event.column.field == "bondRecCreditAmount") {
                                controller.updateCellValue(
                                    "bondRecCreditAmount", extractNumbersAndCalculate(event.row.cells["bondRecCreditAmount"]?.value));
                                if (widget.bondType != AppConstants.bondTypeDebit && widget.bondType != AppConstants.bondTypeCredit) {
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
                                          isDebit: widget.bondType == AppConstants.bondTypeDebit
                                              ? true
                                              : widget.bondType == AppConstants.bondTypeCredit
                                                  ? false
                                                  : null,
                                        )
                                            ? Colors.green
                                            : Colors.red,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            controller
                                                .calcDebitTotal(
                                                  isDebit: widget.bondType == AppConstants.bondTypeDebit
                                                      ? true
                                                      : widget.bondType == AppConstants.bondTypeCredit
                                                          ? false
                                                          : null,
                                                )
                                                .toStringAsFixed(2),
                                            style: const TextStyle(color: Colors.white, fontSize: 18))),
                                    const SizedBox(width: 10),
                                    Container(
                                        width: 120,
                                        color: controller.checkIfBalancedBond(
                                          isDebit: widget.bondType == AppConstants.bondTypeDebit
                                              ? true
                                              : widget.bondType == AppConstants.bondTypeCredit
                                                  ? false
                                                  : null,
                                        )
                                            ? Colors.green
                                            : Colors.red,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            controller
                                                .calcCreditTotal(
                                                  isDebit: widget.bondType == AppConstants.bondTypeDebit
                                                      ? true
                                                      : widget.bondType == AppConstants.bondTypeCredit
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
                                          isDebit: widget.bondType == AppConstants.bondTypeDebit
                                              ? true
                                              : widget.bondType == AppConstants.bondTypeCredit
                                                  ? false
                                                  : null,
                                        )
                                            ? Colors.green
                                            : Colors.red,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            controller
                                                .getDefBetweenCreditAndDebt(
                                                  isDebit: widget.bondType == AppConstants.bondTypeDebit
                                                      ? true
                                                      : widget.bondType == AppConstants.bondTypeCredit
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
                                  bool isDebitBond = widget.bondType == AppConstants.bondTypeDebit;
                                  bool isCreditBond = widget.bondType == AppConstants.bondTypeCredit;
                                  bool isBalancedBond =
                                      plutoBondController.checkIfBalancedBond(isDebit: isDebitBond ? true : (isCreditBond ? false : null));
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

                                  if ((isDebitOrCreditWithAccount && isValidBondForSave) ||
                                      (!isDebitOrCredit && isBalancedBond && isValidBondForSave)) {
                                    if (bondController.isNew) {
                                      checkPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewBond).then((value) async {
                                        if (value) {
                                          await globalController.addGlobalBond(GlobalModel(
                                              bondCode: controller.codeController.text,
                                              bondDate: bondController.dateController.text,
                                              bondRecord: plutoBondController.handleSaveAll(
                                                isCredit: widget.bondType == AppConstants.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == AppConstants.bondTypeDebit
                                                        ? false
                                                        : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              entryBondRecord: plutoBondController.handleSaveAllForEntry(
                                                isCredit: widget.bondType == AppConstants.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == AppConstants.bondTypeDebit
                                                        ? false
                                                        : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              bondDescription: bondController.noteController.text,
                                              bondType: widget.bondType,
                                              bondTotal: "0"));
                                          bondController.isNew = false;
                                          controller.isEdit = false;
                                        }
                                      });
                                    } else {
                                      checkPermissionForOperation(AppConstants.roleUserUpdate, AppConstants.roleViewBond).then((value) async {
                                        if (value) {
                                          bondController.isNew = false;
                                          controller.isEdit = false;
                                          GlobalModel newGlobal = GlobalModel(
                                              entryBondCode: controller.tempBondModel.entryBondCode,
                                              entryBondRecord: plutoBondController.handleSaveAllForEntry(
                                                isCredit: widget.bondType == AppConstants.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == AppConstants.bondTypeDebit
                                                        ? false
                                                        : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              bondCode: controller.tempBondModel.bondCode,
                                              globalType: AppConstants.globalTypeBond,
                                              entryBondId: controller.tempBondModel.entryBondId,
                                              bondDate: bondController.dateController.text,
                                              bondRecord: plutoBondController.handleSaveAll(
                                                isCredit: widget.bondType == AppConstants.bondTypeCredit
                                                    ? true
                                                    : widget.bondType == AppConstants.bondTypeDebit
                                                        ? false
                                                        : null,
                                                account: controller.debitOrCreditController.text,
                                              ),
                                              bondId: controller.tempBondModel.bondId,
                                              bondDescription: bondController.noteController.text,
                                              bondType: widget.bondType,
                                              bondTotal: "0");
                                          sendEmailWithPdfAttachment(newGlobal, true, update: true, invoiceOld: controller.tempBondModel);
                                          await globalController.updateGlobalBond(newGlobal);
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
                                      checkPermissionForOperation(AppConstants.roleUserDelete, AppConstants.roleViewBond).then((value) async {
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
