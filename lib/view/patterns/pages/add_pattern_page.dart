import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_window_title_bar.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widget/add_pattern_bottom_buttons.dart';
import '../widget/colors_picker.dart';

class AddPatternPage extends StatelessWidget {
  const AddPatternPage({super.key});

  @override
  Widget build(BuildContext context) {
    PatternController patternController = Get.find<PatternController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          const CustomWindowTitleBar(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(patternController.editPatternModel!.patId != null ? patternController.editPatternModel!.patName! : "إنشاء نمط"),
              ),
              body: GetBuilder<PatternController>(
                builder: (patternController) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      children: [
                        const VerticalSpace(20),
                        Wrap(spacing: 20, alignment: WrapAlignment.spaceBetween, runSpacing: 10, children: [
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
                                          onChanged: (_) {
                                            // patternController.editPatternModel?.patPrimary = _;
                                          },
                                        ),
                                      ),
                                    ),
                                    // if (patternController.editPatternModel?.patPrimary != null) Icon(Icons.check),
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
                                  // if (patternController.editPatternModel?.patSecondary != null) Icon(Icons.check),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(
                            width: Get.width * 0.45,
                            child: Row(
                              children: [
                                const SizedBox(width: 100, child: Text("النوع :")),
                                Container(
                                  width: (Get.width * 0.45) - 100,
                                  height: AppConstants.constHeightTextField,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButton(
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      alignment: Alignment.center,
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      value: patternController.typeController.text.isEmpty
                                          ? AppConstants.invoiceTypeSales
                                          : patternController.typeController.text,
                                      items: const [
                                        DropdownMenuItem(
                                          value: AppConstants.invoiceTypeSales,
                                          child: Center(
                                            child: Text(
                                              "مبيع",
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: AppConstants.invoiceTypeBuy,
                                          child: Center(child: Text("شراء", textDirection: TextDirection.rtl)),
                                        ),
                                        DropdownMenuItem(
                                          value: AppConstants.invoiceTypeAdd,
                                          child: Center(child: Text("إدخال", textDirection: TextDirection.rtl)),
                                        ),
                                        DropdownMenuItem(
                                          value: AppConstants.invoiceTypeChange,
                                          child: Center(child: Text("تبديل مستودعي", textDirection: TextDirection.rtl)),
                                        ),
                                        DropdownMenuItem(
                                          value: AppConstants.invoiceTypeSalesWithPartner,
                                          child: Center(child: Text("مبيعات مع شريك", textDirection: TextDirection.rtl)),
                                        ),
                                      ],
                                      onChanged: (_) {
                                        patternController.typeController.text = _!;
                                        patternController.editPatternModel?.patType = _;
                                        if (patternController.typeController.text == AppConstants.invoiceTypeAdd) {
                                          patternController.editPatternModel?.patPrimary = null;
                                          patternController.primaryController.clear();
                                        }
                                        patternController.update();
                                      }),
                                ),
                              ],
                            ),
                          ),
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
                                      onChanged: (_) {
                                        // patternController.editPatternModel?.patStore = _;
                                      },
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
                                  // if (patternController.editPatternModel?.patGiftAccount != null) Icon(Icons.check)
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
                                  // if (patternController.editPatternModel?.patSecGiftAccount != null) Icon(Icons.check)
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
                                    onChanged: (_) {
                                      // patternController.editPatternModel?.patStore = _;
                                    },
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: ((Get.width * 0.45) / 2) - 5,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 100, child: Text("نسبة الشريك :")),
                                      Expanded(
                                        child: CustomTextFieldWithoutIcon(
                                          controller: patternController.patPartnerRatio,
                                          onSubmitted: (text) async {},
                                          onChanged: (_) {
                                            patternController.editPatternModel?.patPartnerRatio = double.tryParse(_) ?? 0.0;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const HorizontalSpace(10),
                                SizedBox(
                                  width: ((Get.width * 0.45) / 2) - 5,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 100, child: Text("عمولة التحويل :")),
                                      Expanded(
                                        child: CustomTextFieldWithoutIcon(
                                          controller: patternController.patPartnerCommission,
                                          onSubmitted: (text) async {},
                                          onChanged: (_) {
                                            patternController.editPatternModel?.patPartnerCommission = double.tryParse(_) ?? 0.0;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ]),
                        const VerticalSpace(40),
                        ColorsPicker(patternController: patternController),
                        const VerticalSpace(40),
                        AddPatternBottomButtons(patternController: patternController),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
