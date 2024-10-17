import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/view/cheques/widget/add_cheque_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/functions/functions.dart';
import '../../../data/model/global/global_model.dart';
import '../widget/add_cheque_buttons.dart';

class AddCheque extends StatefulWidget {
  final String? modelKey;

  const AddCheque({super.key, this.modelKey});

  @override
  State<AddCheque> createState() => _AddChequeState();
}

class _AddChequeState extends State<AddCheque> {
  var chequeController = Get.find<ChequeController>();

  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var codeController = TextEditingController();
  var allAmountController = TextEditingController();
  var primaryController = TextEditingController()..text = getAccountNameFromId("اوراق الدفع");
  var secondaryController = TextEditingController();
  var bankController = TextEditingController()..text = getAccountNameFromId("المصرف");
  var chequeType;

  @override
  void initState() {
    super.initState();
    if (widget.modelKey == null) {
      chequeController.initModel = GlobalModel();
      print(DateTime.now().toString().split(" ")[0]);
      chequeController.initModel!.cheqDate = DateTime.now().toString().split(" ")[0];
      chequeType = AppConstants.chequeTypeList[0];
      chequeController.initModel?.cheqType = AppConstants.chequeTypeList[0];
      if (chequeController.allCheques.isNotEmpty) {
        codeController.text = (int.parse(chequeController.allCheques.values.last.cheqCode ?? "0") + 1).toString();
      } else {
        codeController.text = "1";
      }
      chequeController.initModel?.cheqCode = codeController.text;
    } else {
      chequeController.initModel = chequeController.allCheques[widget.modelKey];
      initPage();
    }
  }

  void initPage() {
    numberController.text = chequeController.initModel?.cheqName ?? "";
    codeController.text = chequeController.initModel?.cheqCode ?? "";
    allAmountController.text = chequeController.initModel?.cheqAllAmount ?? "";
    primaryController.text = getAccountNameFromId(chequeController.initModel?.cheqPrimeryAccount ?? "");
    secondaryController.text = getAccountNameFromId(chequeController.initModel?.cheqSecoundryAccount ?? "");
    bankController.text = getAccountNameFromId(chequeController.initModel?.cheqBankAccount ?? "");
    chequeType = chequeController.initModel?.cheqType;
  }

  @override
  void dispose() {
    numberController.clear();
    codeController.clear();
    allAmountController.clear();
    primaryController.clear();
    secondaryController.clear();
    bankController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<ChequeController>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.initModel?.cheqName ?? "شيك جديد"),
            toolbarHeight: 100,
            actions: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: controller.initModel!.cheqStatus == AppConstants.chequeStatusPaid
                              ? Colors.green.shade200
                              : controller.initModel!.cheqStatus == AppConstants.chequeStatusNotPaid
                                  ? Colors.red.shade200
                                  : controller.initModel!.cheqStatus == AppConstants.chequeStatusNotAllPaid
                                      ? Colors.orange.shade200
                                      : Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("الحالة: "),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(getChequeStatusFromEnum(controller.initModel!.cheqStatus ?? AppConstants.chequeStatusNotPaid)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("الرمز التسلسلي:"),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: codeController,
                          onChanged: (_) => controller.initModel?.cheqCode = _,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text("النوع: "),
                    StatefulBuilder(builder: (context, setstae) {
                      return DropdownButton<String>(
                        value: chequeType,
                        items: AppConstants.chequeTypeList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(getChequeTypeFromEnum(e)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setstae(() {
                            chequeType = value;
                          });
                          controller.initModel?.cheqType = value;
                        },
                      );
                    }),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  AddChequeForm(
                      controller: controller,
                      secondaryController: secondaryController,
                      numberController: numberController,
                      codeController: codeController,
                      allAmountController: allAmountController,
                      bankController: bankController,
                      chequeType: chequeType,
                      primaryController: primaryController),
                  const VerticalSpace(20),
                  const Divider(),
                  const VerticalSpace(20),
                  AddChequeButtons(
                      secondaryController: secondaryController,
                      numberController: numberController,
                      codeController: codeController,
                      allAmountController: allAmountController,
                      bankController: bankController,
                      chequeType: chequeType,
                      primaryController: primaryController,
                      controller: controller),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
