import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/patterns/widget/partner_ratio_commission.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/pattern/pattern_model_view.dart';
import 'add_pattern_type.dart';

class AddPatternForm extends StatelessWidget {
  const AddPatternForm({super.key, required this.patternController});

  final PatternController patternController;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 20, alignment: WrapAlignment.spaceBetween, runSpacing: 10, children: [
      SizedBox(
        width: Get.width * 0.45,
        child: Row(
          children: [
            const SizedBox(width: 100, child: Text("الاختصار :")),
            Expanded(
              child: CustomTextFieldWithoutIcon(
                controller: patternController.nameController,
                onChanged: (value) {
                  patternController.editPatternModel?.patName = value;
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: Get.width * 0.45,
        child: Row(
          children: [
            const SizedBox(width: 100, child: Text("الاسم :")),
            Expanded(
              child: CustomTextFieldWithoutIcon(
                controller: patternController.fullNameController,
                onChanged: (value) {
                  patternController.editPatternModel?.patFullName = value;
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: Get.width * 0.45,
        child: Row(
          children: [
            const SizedBox(width: 100, child: Text("الرمز :")),
            Expanded(
              child: CustomTextFieldWithoutIcon(
                controller: patternController.codeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  patternController.editPatternModel?.patCode = value;
                },
              ),
            ),
          ],
        ),
      ),
      if (patternController.editPatternModel?.patType != AppConstants.invoiceTypeChange) ...[
        SizedBox(
          width: Get.width * 0.45,
          child: IgnorePointer(
            ignoring: patternController.typeController.text == AppConstants.invoiceTypeAdd,
            child: Row(
              children: [
                const SizedBox(width: 100, child: Text("الدائن")),
                Expanded(
                  child: Container(
                    foregroundDecoration: patternController.typeController.text == AppConstants.invoiceTypeAdd
                        ? BoxDecoration(color: Colors.grey.withOpacity(0.5))
                        : null,
                    child: CustomTextFieldWithIcon(
                      controller: patternController.primaryController,
                      onSubmitted: (text) async {
                        var account = await getAccountComplete(text);
                        patternController.update();
                        if (account.isNotEmpty) {
                          patternController.editPatternModel?.patPrimary = account;
                          patternController.primaryController.text = account;
                          patternController.update();
                        }
                      },
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 0.45,
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text("المدين")),
              Expanded(
                child: CustomTextFieldWithIcon(
                  controller: patternController.secondaryController,
                  onSubmitted: (text) async {
                    var account = await getAccountComplete(text);
                    patternController.update();
                    if (account.isNotEmpty) {
                      patternController.editPatternModel?.patSecondary = account;
                      patternController.secondaryController.text = account;
                      patternController.update();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
      AddPatternType(patternController: patternController),
      if (patternController.editPatternModel?.patType == AppConstants.invoiceTypeChange)
        SizedBox(
          width: Get.width * 0.45,
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text("المستودع الجديد:")),
              Expanded(
                child: CustomTextFieldWithIcon(
                  controller: patternController.storeNewController,
                  onSubmitted: (text) async {
                    var store = await patternController.getStoreComplete(text);
                    if (store.isNotEmpty) {
                      patternController.editPatternModel?.patNewStore = store;
                      patternController.storeNewController.text = store;
                      patternController.update();
                    }
                  },
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ),
      if (patternController.editPatternModel?.patType != AppConstants.invoiceTypeChange) ...[
        SizedBox(
          width: Get.width * 0.45,
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text("حساب الهدايا ")),
              Expanded(
                child: CustomTextFieldWithIcon(
                  controller: patternController.giftAccountController,
                  onSubmitted: (text) async {
                    var a = await getAccountComplete(text);
                    patternController.update();
                    if (a.isNotEmpty) {
                      patternController.editPatternModel?.patGiftAccount = a;
                      patternController.giftAccountController.text = a;
                      patternController.update();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: Get.width * 0.45,
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text("حساب  المقابل الهدايا ")),
              Expanded(
                child: CustomTextFieldWithIcon(
                  controller: patternController.secgiftAccountController,
                  onSubmitted: (text) async {
                    var a = await getAccountComplete(text);
                    patternController.update();
                    if (a.isNotEmpty) {
                      patternController.editPatternModel?.patSecGiftAccount = a;
                      patternController.secgiftAccountController.text = a;
                      patternController.update();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
      SizedBox(
        width: Get.width * 0.45,
        child: Row(
          children: [
            const SizedBox(width: 100, child: Text("المستودع :")),
            Expanded(
              child: CustomTextFieldWithIcon(
                controller: patternController.storeEditController,
                onSubmitted: (text) async {
                  var a = await patternController.getStoreComplete(text);
                  if (a.isNotEmpty) {
                    patternController.editPatternModel?.patStore = a;
                    patternController.storeEditController.text = a;
                    patternController.update();
                  }
                },
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
      if (patternController.editPatternModel?.patType == AppConstants.invoiceTypeSalesWithPartner) ...[
        SizedBox(
          width: (Get.width * 0.45),
          child: Row(
            children: [
              const SizedBox(width: 100, child: Text("حساب مرابح الشريك :")),
              Expanded(
                child: CustomTextFieldWithIcon(
                  controller: patternController.patPartnerAccountFee,
                  onSubmitted: (text) async {
                    var a = await getAccountComplete(text);

                    patternController.update();
                    if (a.isNotEmpty) {
                      patternController.editPatternModel?.patPartnerFeeAccount = a;
                      patternController.patPartnerAccountFee.text = a;
                      patternController.update();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        PartnerRatioCommission(patternController: patternController),
      ],
    ]);
  }
}
