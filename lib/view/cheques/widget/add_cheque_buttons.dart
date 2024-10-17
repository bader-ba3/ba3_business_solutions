import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_controller.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_controller.dart';
import 'package:ba3_business_solutions/controller/global/global_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/view/entry_bond/pages/entry_bond_details_view.dart';
import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/bond/bond_controller.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/utils/generate_id.dart';
import '../../../data/model/bond/bond_record_model.dart';
import '../../../data/model/bond/entry_bond_record_model.dart';
import '../../../data/model/global/global_model.dart';
import '../../bonds/pages/bond_details_view.dart';
import '../../bonds/widget/bond_record_pluto_view_model.dart';

class AddChequeButtons extends StatelessWidget {
  const AddChequeButtons({
    super.key,
    required this.secondaryController,
    required this.numberController,
    required this.codeController,
    required this.allAmountController,
    required this.bankController,
    required this.chequeType,
    required this.primaryController,
    required this.controller,
  });

  final TextEditingController secondaryController;
  final TextEditingController numberController;
  final TextEditingController codeController;
  final TextEditingController allAmountController;
  final TextEditingController bankController;
  final String chequeType;
  final TextEditingController primaryController;
  final ChequeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          onPressed: () async {
            if (double.tryParse(controller.initModel?.cheqAllAmount ?? "a") == null) {
              Get.snackbar("خطأ", "يرجى كتابة قيمة الشيك ");
            } else if (controller.initModel?.cheqName?.isEmpty ?? true) {
              Get.snackbar("خطأ", "يرجى كتابة رقم الشيك ");
            } else if (controller.initModel?.cheqDate?.isEmpty ?? true) {
              Get.snackbar("خطأ", "يرجى كتابة تاريخ الشيك ");
            } else if (controller.initModel?.cheqCode?.isEmpty ?? true) {
              Get.snackbar("خطأ", "يرجى كتابة رمز الشيك");
            } else if (getAccountIdFromText(secondaryController.text) == '') {
              Get.snackbar("خطأ", "يرجى كتابة المعلومات");
            } else {
              hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewCheques).then((value) {
                if (value) {
                  String des = "سند قيد مولد من شيك رقم ${numberController.text}";
                  if (controller.initModel!.cheqId == null) {
                    controller.addCheque(GlobalModel(
                        globalType: AppConstants.globalTypeCheque,
                        cheqDeuDate: controller.initModel!.cheqDeuDate,
                        cheqDate: controller.initModel!.cheqDate,
                        entryBondCode: getNextEntryBondCode().toString(),
                        entryBondId: generateId(RecordType.entryBond),
                        cheqCode: codeController.text,
                        cheqId: generateId(RecordType.cheque),
                        cheqAllAmount: allAmountController.text,
                        cheqBankAccount: getAccountIdFromText(bankController.text),
                        cheqName: "${getGlobalTypeFromEnum(chequeType)} ${numberController.text}",
                        cheqPrimeryAccount: getAccountIdFromText(primaryController.text),
                        cheqSecoundryAccount: getAccountIdFromText(secondaryController.text),
                        cheqStatus: AppConstants.chequeStatusNotPaid,
                        cheqType: chequeType,
                        cheqRemainingAmount: allAmountController.text,
                        entryBondRecord: [
                          EntryBondRecordModel(
                              "01", double.tryParse(allAmountController.text) ?? 0, 0, getAccountIdFromText(primaryController.text), des),
                          EntryBondRecordModel(
                              "02", 0, double.tryParse(allAmountController.text) ?? 0, getAccountIdFromText(secondaryController.text), des),
                        ]));
                  } else {
                    controller.addCheque(GlobalModel(
                        globalType: AppConstants.globalTypeCheque,
                        cheqDeuDate: controller.initModel!.cheqDeuDate,
                        cheqDate: controller.initModel!.cheqDate,
                        entryBondCode: controller.initModel!.entryBondCode,
                        entryBondId: controller.initModel!.entryBondId,
                        cheqCode: codeController.text,
                        cheqId: controller.initModel!.cheqId,
                        cheqAllAmount: allAmountController.text,
                        cheqBankAccount: getAccountIdFromText(bankController.text),
                        cheqName: getGlobalTypeFromEnum(chequeType) + numberController.text,
                        cheqPrimeryAccount: getAccountIdFromText(primaryController.text),
                        cheqSecoundryAccount: getAccountIdFromText(secondaryController.text),
                        cheqStatus: AppConstants.chequeStatusNotPaid,
                        cheqType: chequeType,
                        cheqRemainingAmount: allAmountController.text,
                        entryBondRecord: [
                          EntryBondRecordModel(
                              "01", double.tryParse(allAmountController.text) ?? 0, 0, getAccountIdFromText(primaryController.text), des),
                          EntryBondRecordModel(
                              "02", 0, double.tryParse(allAmountController.text) ?? 0, getAccountIdFromText(secondaryController.text), des),
                        ]));
                  }
                }
              });
            }
          },
          title: controller.initModel!.cheqId == null ? "إضافة" : "تعديل",
          iconData: controller.initModel!.cheqId == null ? Icons.add : Icons.edit,
          color: controller.initModel!.cheqId == null ? null : Colors.green,
        ),
        if (controller.initModel?.cheqId != null) ...[
          const SizedBox(
            width: 50,
          ),
          AppButton(
            onPressed: () {
              confirmDeleteWidget().then((value) {
                if (value) {
                  hasPermissionForOperation(AppConstants.roleUserDelete, AppConstants.roleViewCheques).then((value) {
                    if (value) {
                      var globalController = Get.find<GlobalController>();
                      globalController.deleteGlobal(controller.initModel!);
                    }
                  });
                }
              });
            },
            title: "حذف",
            iconData: Icons.delete_outline,
            color: Colors.red,
          ),
          const SizedBox(
            width: 50,
          ),
          AppButton(
            onPressed: () {
              // print(controller.initModel!.entryBondId);
              Get.to(() => EntryBondDetailsView(
                    oldId: controller.initModel!.entryBondId,
                  ));
            },
            title: "السند",
            iconData: Icons.view_list_outlined,
          ),
          const SizedBox(
            width: 50,
          ),
          AppButton(
            onPressed: () async {
              if (controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid) {
                String des = controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid
                    ? "سند دفع ${controller.initModel?.cheqName}"
                    : "سند ارجاع قيمة  ${controller.initModel?.cheqName}";
                List<BondRecordModel> bondRecord = [];
                List<EntryBondRecordModel> entryBondRecord = [];
                if (controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid) {
                  bondRecord.add(
                      BondRecordModel("00", 0, double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, getAccountIdFromText("اوراق الدفع"), des));
                  bondRecord
                      .add(BondRecordModel("01", double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, 0, getAccountIdFromText("المصرف"), des));
                } else {
                  bondRecord
                      .add(BondRecordModel("00", 0, double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, getAccountIdFromText("المصرف"), des));
                  bondRecord.add(
                      BondRecordModel("01", double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, 0, getAccountIdFromText("اوراق الدفع"), des));
                }
                for (var element in bondRecord) {
                  entryBondRecord.add(EntryBondRecordModel.fromJson(element.toJson()));
                }
                GlobalController globalViewModel = Get.find<GlobalController>();
                String bondId = generateId(RecordType.bond);
                await globalViewModel.addGlobalBond(
                  GlobalModel(
                    bondId: bondId,
                    globalType: AppConstants.globalTypeBond,
                    bondDate: DateTime.now().toString(),
                    bondRecord: bondRecord,
                    bondCode: Get.find<BondController>().getNextBondCode(type: AppConstants.bondTypeDebit),
                    entryBondRecord: entryBondRecord,
                    bondDescription: des,
                    bondType: AppConstants.bondTypeDebit,
                    bondTotal: "0",
                  ),
                );
                await controller.addCheque(GlobalModel(
                    bondId: bondId,
                    globalType: AppConstants.globalTypeCheque,
                    cheqDeuDate: controller.initModel!.cheqDeuDate,
                    cheqDate: controller.initModel!.cheqDate,
                    entryBondCode: controller.initModel!.entryBondCode,
                    entryBondId: controller.initModel!.entryBondId,
                    cheqCode: codeController.text,
                    cheqId: controller.initModel!.cheqId,
                    cheqAllAmount: allAmountController.text,
                    cheqBankAccount: getAccountIdFromText(bankController.text),
                    cheqName: getGlobalTypeFromEnum(chequeType) + numberController.text,
                    cheqPrimeryAccount: getAccountIdFromText(primaryController.text),
                    cheqSecoundryAccount: getAccountIdFromText(secondaryController.text),
                    cheqStatus: AppConstants.chequeStatusPaid,
                    cheqType: chequeType,
                    cheqRemainingAmount: allAmountController.text,
                    entryBondRecord: [
                      EntryBondRecordModel(
                          "01", double.tryParse(allAmountController.text) ?? 0, 0, getAccountIdFromText(primaryController.text), des),
                      EntryBondRecordModel(
                          "02", 0, double.tryParse(allAmountController.text) ?? 0, getAccountIdFromText(secondaryController.text), des),
                    ]));
              } else {}
            },
            title: controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid ? "دفع" : "ارجاع",
            color: controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid ? Colors.black : Colors.red,
            iconData: controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid ? Icons.paid : Icons.real_estate_agent_outlined,
          ),
          const SizedBox(
            width: 50,
          ),
          AppButton(
            onPressed: () {
              Get.to(
                () => BondDetailsView(
                  oldId: controller.initModel!.bondId,
                  bondType: AppConstants.bondTypeDebit,
                ),
                binding: BindingsBuilder(() {
                  Get.lazyPut(() => BondRecordPlutoViewModel(AppConstants.bondTypeDebit));
                }),
              );
            },
            title: "سند الدفع",
            iconData: Icons.view_list_outlined,
          ),
        ]
      ],
    );
  }
}
