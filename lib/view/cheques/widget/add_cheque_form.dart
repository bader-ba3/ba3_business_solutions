import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cheque/cheque_controller.dart';
import '../widget/text_form.dart';

class AddChequeForm extends StatefulWidget {
  const AddChequeForm(
      {super.key,
      required this.controller,
      required this.secondaryController,
      required this.numberController,
      required this.codeController,
      required this.allAmountController,
      required this.bankController,
      required this.chequeType,
      required this.primaryController});

  final TextEditingController secondaryController;
  final TextEditingController numberController;
  final TextEditingController codeController;
  final TextEditingController allAmountController;
  final TextEditingController bankController;
  final String chequeType;
  final TextEditingController primaryController;
  final ChequeController controller;

  @override
  State<AddChequeForm> createState() => _AddChequeFormState();
}

class _AddChequeFormState extends State<AddChequeForm> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 20,
      children: [
        SizedBox(
          width: Get.width * .45,
          height: 40,
          child: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text("تاريخ التحرير"),
              ),
              Expanded(
                child: DatePicker(
                  initDate: widget.controller.initModel?.cheqDate,
                  onSubmit: (_) {
                    widget.controller.initModel?.cheqDate = _.toString().split(" ").first;
                    print(_);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: Get.width * .45,
          height: 40,
          child: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text("تاريخ الاستحقاق"),
              ),
              Expanded(
                child: DatePicker(
                  initDate: widget.controller.initModel?.cheqDeuDate,
                  onSubmit: (_) {
                    widget.controller.initModel!.cheqDeuDate = _.toString().split(" ").first;
                    setState(() {});
                    print(_);
                  },
                ),
              ),
            ],
          ),
        ),
        TextForm(text: "رقم الشيك", controller: widget.numberController, onChanged: (_) => widget.controller.initModel?.cheqName = _),
        TextForm(
            text: "قيمة الشيك",
            controller: widget.allAmountController,
            onChanged: (_) {
              if (double.tryParse(_) != null) {
                widget.controller.initModel?.cheqAllAmount = _;
              } else {
                if (_ != "") {
                  Get.snackbar("خطأ", "يرجى كتابة رقم");
                }
              }
            }),
        TextForm(
          text: "الحساب",
          controller: widget.primaryController,
          onFieldSubmitted: (value) async {
            var a = await widget.controller.getAccountComplete(value, AppConstants.accountTypeDefault);
            widget.primaryController.text = a;
            widget.controller.initModel?.cheqPrimeryAccount = a;
          },
        ),
        TextForm(
          text: "دفع إلى",
          controller: widget.secondaryController,
          onFieldSubmitted: (value) async {
            var a = await widget.controller.getAccountComplete(
                value, widget.chequeType == AppConstants.chequeTypeCatch ? AppConstants.accountTypeDefault : AppConstants.accountTypeDefault);
            widget.secondaryController.text = a;
            widget.controller.initModel?.cheqSecoundryAccount = a;
          },
        ),
        TextForm(
          text: "حساب البنك",
          controller: widget.bankController,
          onFieldSubmitted: (value) async {
            var a = await widget.controller.getAccountComplete(value, AppConstants.accountTypeDefault);
            widget.bankController.text = a;
            widget.controller.initModel?.cheqBankAccount = a;
          },
        ),
      ],
    );
  }
}
