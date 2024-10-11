import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/warranty/warranty_controller.dart';
import '../../../core/utils/date_picker.dart';
import '../../invoices/widget/custom_TextField.dart';

class WarrantyPageTopBar extends StatelessWidget {
  const WarrantyPageTopBar({
    super.key,
    required this.warrantyController,
  });

  final WarrantyController warrantyController;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: Get.width - 20,
        child: Wrap(
          spacing: 20,
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 10,
          children: [
            SizedBox(
              width: Get.width * 0.45,
              child: Row(
                children: [
                  const SizedBox(
                      width: 100,
                      child: Text("تاريخ الفاتورة : ", style: TextStyle())),
                  Expanded(
                    child: DatePicker(
                      initDate: warrantyController.dateController,
                      onSubmit: (_) {
                        warrantyController.dateController =
                            _.toString().split(".")[0];

                        warrantyController.update();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width * 0.45,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 100, child: Text("رقم الجوال : ")),
                  Expanded(
                    child: CustomTextFieldWithoutIcon(
                        controller: warrantyController.mobileNumberController),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width * 0.45,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "اسم الزبون : ",
                    ),
                  ),
                  Expanded(
                    child: CustomTextFieldWithIcon(
                        controller: warrantyController.customerNameController,
                        onSubmitted: (text) async {},
                        onIconPressed: () {}),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width * 0.45,
              child: Row(
                children: [
                  const SizedBox(width: 100, child: Text("البيان")),
                  Expanded(
                    child: CustomTextFieldWithoutIcon(
                        controller: warrantyController.noteController),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
