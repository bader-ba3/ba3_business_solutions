import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/controller/global/global_controller.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_controller.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/data/model/bond/bond_record_model.dart';
import 'package:ba3_business_solutions/data/model/bond/entry_bond_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/global/global_model.dart';
import '../../../view/invoices/pages/new_invoice_view.dart';
import '../../styling/app_colors.dart';
import '../widgets/option_text_widget.dart';

class BondDebitDialog extends StatelessWidget {
  BondDebitDialog({
    super.key,
  });

  final PatternController patternController = Get.find<PatternController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backGroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GetBuilder<InvoiceController>(initState: (state) {
            Get.find<InvoiceController>().invoiceForSearch = null;
            Get.find<InvoiceController>().totalPaidFromPartner = TextEditingController();
          }, builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('حساب فاتورة اجلة'),
                const SizedBox(height: 15),
                OptionTextWidget(
                  title: "رقم الفاتورة :  ",
                  controller: TextEditingController(),
                  onSubmitted: (text) async {
                    controller.searchInvoice(text);
                    // controller.productForSearchController.text = await searchProductTextDialog(controller.productForSearchController.text)??"";
                    controller.update();
                  },
                ),
                OptionTextWithoutIconWidget(
                  title: "القيمة الواصلة :  ",
                  controller: controller.totalPaidFromPartner,
                  onSubmitted: (text) async {
                    controller.totalPaidFromPartner.text = text;
                    // controller.update();
                  },
                ),
                if (controller.invoiceForSearch != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: Color(
                                patternController.patternModel[controller.invoiceForSearch!.patternId]?.patColor! ??
                                    00000)
                            .withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "نمط الفاتورة:",
                                style: TextStyle(fontSize: 16),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                patternController.patternModel[controller.invoiceForSearch!.patternId!]!.patFullName ??
                                    "error",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "رقم الفاتورة:",
                                style: TextStyle(fontSize: 18),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Text(
                              controller.invoiceForSearch!.invPartnerCode.toString(),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "تاريخ الفاتورة:",
                                style: TextStyle(fontSize: 18),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Text(
                              controller.invoiceForSearch!.invDate.toString().split(" ")[0],
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "مجموع الفاتورة:",
                                style: TextStyle(fontSize: 18),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Text(
                              controller.invoiceForSearch!.invTotalPartner!.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 170,
                              child: Text(
                                "مجموع الفاتورة الكلي:",
                                style: TextStyle(fontSize: 18),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Text(
                              controller.invoiceForSearch!.invTotal!.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                AppButton(
                  title: "موافق",
                  iconData: Icons.check,
                  onPressed: () async {
                    if (controller.invoiceForSearch != null &&
                        double.tryParse(controller.totalPaidFromPartner.text) != null) {
                      String des =
                          "سند دفع مولد من عملية تسديد فاتورة رقم${controller.invoiceForSearch!.invPartnerCode} - ${patternController.patternModel[controller.invoiceForSearch!.patternId]!.patFullName}:${controller.invoiceForSearch!.invCode!}";
                      List<BondRecordModel> bondRecord = [];
                      List<EntryBondRecordModel> entryBondRecord = [];

                      bondRecord.add(BondRecordModel("00", 0, double.parse(controller.totalPaidFromPartner.text),
                          getAccountIdFromText("المصرف"), des));
                      bondRecord.add(BondRecordModel(
                          "01",
                          0,
                          controller.invoiceForSearch!.invTotal! - double.parse(controller.totalPaidFromPartner.text),
                          patternController.patternModel[controller.invoiceForSearch!.patternId]!.patPartnerFeeAccount!,
                          des));
                      bondRecord.add(BondRecordModel(
                          "02",
                          double.parse(controller.totalPaidFromPartner.text) +
                              (controller.invoiceForSearch!.invTotal! -
                                  double.parse(controller.totalPaidFromPartner.text)),
                          0,
                          patternController.patternModel[controller.invoiceForSearch!.patternId]!.patSecondary!,
                          des));
                      // bondRecord.add(BondRecordModel("03", controller.invoiceForSearch!.invTotal! - double.parse(controller.totalPaidFromPartner.text), 0, patternController.patternModel[controller.invoiceForSearch!.patternId]!.patSecondary!, des));

                      for (var element in bondRecord) {
                        entryBondRecord.add(EntryBondRecordModel.fromJson(element.toJson()));
                      }

                      GlobalController globalViewModel = Get.find<GlobalController>();
                      // print(GlobalModel(bondCode: Get.find<BondViewModel>().getNextBondCode(type: Const.bondTypeDebit), bondDate: DateTime.now().toIso8601String(), bondRecord: bondRecord, entryBondRecord: entryBondRecord, bondDescription: des, bondType: Const.bondTypeDebit, bondTotal: "0")
                      //     .toFullJson());bon1726403858683038
                      globalViewModel.updateGlobalInvoice(controller.invoiceForSearch!..invIsPaid = true);
                      await globalViewModel.addGlobalBond(
                        GlobalModel(
                          bondRecord: bondRecord,
                          bondCode: Get.find<BondController>().getNextBondCode(type: AppConstants.bondTypeDebit),
                          entryBondRecord: entryBondRecord,
                          bondDescription: des,
                          bondType: AppConstants.bondTypeDebit,
                          bondTotal: "0",
                        ),
                      );
                      Get.back();

                      // controller.invoiceForSearch!.entryBondRecord!.add(EntryBondRecordModel(controller.invoiceForSearch!.entryBondRecord.length + 1, bondRecCreditAmount, bondRecDebitAmount, bondRecAccount, bondRecDescription))
                    }
                    // Get.to(() => AllInvoice(listDate: getDatesBetween(DateTime.parse(controller.startDateForSearchController.text), DateTime.parse(controller.endDateForSearchController.text)), productName: getProductIdFromName(controller.productForSearchController.text)));
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
