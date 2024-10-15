import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/warranty/warranty_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../invoices/widget/custom_Text_field.dart';

class WarrantyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WarrantyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    WarrantyController warrantyController = Get.find<WarrantyController>();
    return AppBar(
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
            padding: const EdgeInsets.all(5),
            child: const Icon(
              Icons.close,
              color: Colors.red,
              size: 16,
            )),
      ),
      title: Text(warrantyController.billId == "1" ? "فاتورة الضمان" : "تفاصيل فاتورة الضمان"),
      actions: [
        SizedBox(
          height: AppConstants.constHeightTextField,
          child: Row(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        warrantyController.invNextOrPrev(warrantyController.invCodeController.text, true);
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_right)),
                  // const Text("Invoice Code : "),
                  SizedBox(
                      width: Get.width * 0.10,
                      child: CustomTextFieldWithoutIcon(
                        isNumeric: true,
                        controller: warrantyController.invCodeController,
                        onSubmitted: (text) {
                          warrantyController.getInvByInvCode(
                            text,
                          );
                        },
                      )),
                  IconButton(
                      onPressed: () {
                        warrantyController.invNextOrPrev(warrantyController.invCodeController.text, false);

                        // invoiceController.nextInv(widget.patternModel!.patId!, invoiceController.invCodeController.text);
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_left)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // This gives you the default AppBar height.
}
