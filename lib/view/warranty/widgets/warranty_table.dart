import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controller/warranty/warranty_pluto_view_model.dart';
import '../../../core/shared/widgets/Custom_Pluto_With_Edite.dart';
import '../../../core/shared/widgets/custom_pluto_short_cut.dart';
import '../../../core/shared/widgets/get_product_enter_short_cut.dart';
import '../../invoices/pages/new_invoice_view.dart';

class WarrantyTable extends StatelessWidget {
  const WarrantyTable({
    super.key,
    required this.warrantyPlutoViewModel,
  });

  final WarrantyPlutoViewModel warrantyPlutoViewModel;

  @override
  Widget build(BuildContext context) {
    return CustomPlutoWithEdite(
      evenRowColor: Colors.redAccent,
      controller: warrantyPlutoViewModel,
      shortCut: customPlutoShortcut(GetProductEnterPlutoGridAction(
          warrantyPlutoViewModel, "invRecProduct")),
      onRowSecondaryTap: (event) {
        if (event.cell.column.field == "invRecId") {
          Get.defaultDialog(
              title: "تأكيد الحذف",
              content: const Text("هل انت متأكد من حذف هذا العنصر"),
              actions: [
                AppButton(
                    title: "نعم",
                    onPressed: () {
                      warrantyPlutoViewModel.clearRowIndex(event.rowIdx);
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
      onChanged: (PlutoGridOnChangedEvent event) async {},
    );
  }
}
