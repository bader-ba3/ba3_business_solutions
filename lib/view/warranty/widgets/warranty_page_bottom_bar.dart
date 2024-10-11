import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/invoice_view_model.dart';
import '../../../controller/print/print_view_model.dart';
import '../../../controller/user/user_management_model.dart';
import '../../../controller/warranty/warranty_controller.dart';
import '../../../controller/warranty/warranty_pluto_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../model/global/global_model.dart';
import '../../invoices/pages/new_invoice_view.dart';

class WarrantyPageBottomBar extends StatelessWidget {
  const WarrantyPageBottomBar({
    super.key,
    required this.plutoEditViewModel,
    required this.warrantyController,
  });

  final WarrantyPlutoViewModel plutoEditViewModel;
  final WarrantyController warrantyController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 20,
        children: [
          AppButton(
              title: 'جديد',
              onPressed: () async {
                checkPermissionForOperation(AppConstants.roleUserWrite,
                        AppConstants.roleViewInvoice)
                    .then((value) {
                  if (value) {
                    warrantyController.getInit();
                    warrantyController.update();
                    plutoEditViewModel.getRows([]);
                    plutoEditViewModel.update();
                  }
                });
              },
              iconData: Icons.create_new_folder_outlined),
          if (warrantyController.isNew)
            AppButton(
                title: "إضافة",
                onPressed: () async {
                  plutoEditViewModel.handleSaveAll();
                  warrantyController.updateInvoice(isAdd: true, done: false);
                },
                iconData: Icons.add_chart_outlined),
          if (warrantyController.isNew == false) ...[
            AppButton(
                title: "تعديل",
                onPressed: () async {
                  plutoEditViewModel.handleSaveAll();
                  checkPermissionForOperation(AppConstants.roleUserUpdate,
                          AppConstants.roleViewInvoice)
                      .then((value) async {
                    if (value) {
                      warrantyController.updateInvoice(
                          isAdd: false, done: false);
                    }
                  });
                },
                iconData: Icons.edit_outlined),
            if (!(warrantyController.initModel.done ?? true))
              AppButton(
                iconData: Icons.done_all,
                color: Colors.green,
                title: 'تسليم',
                onPressed: () async {
                  plutoEditViewModel.handleSaveAll();

                  checkPermissionForOperation(AppConstants.roleUserAdmin,
                          AppConstants.roleViewInvoice)
                      .then((value) async {
                    if (value) {
                      warrantyController.updateInvoice(
                          isAdd: false, done: true);
                    }
                  });
                },
              ),
            AppButton(
              iconData: Icons.print_outlined,
              title: 'طباعة',
              onPressed: () async {
                plutoEditViewModel.handleSaveAll();

                PrintViewModel printViewModel = Get.find<PrintViewModel>();
                printViewModel.printFunction(GlobalModel(),
                    warrantyModel: warrantyController.initModel);
              },
            ),
            AppButton(
                title: "E-Invoice",
                onPressed: () {
                  showEInvoiceDialog(
                      mobileNumber:
                          warrantyController.initModel.customerPhone ?? "",
                      invId: warrantyController.initModel.invId!);
                },
                iconData: Icons.link),
            AppButton(
              iconData: Icons.delete_outline,
              color: Colors.red,
              title: 'حذف',
              onPressed: () async {
                confirmDeleteWidget().then((value) {
                  if (value) {
                    checkPermissionForOperation(AppConstants.roleUserDelete,
                            AppConstants.roleViewInvoice)
                        .then((value) async {
                      if (value) {
                        warrantyController.deleteInvoice();
                        Get.back();
                      }
                    });
                  }
                });
              },
            )
          ]
        ],
      ),
    );
  }
}
