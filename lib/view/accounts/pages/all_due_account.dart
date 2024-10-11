import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_view_model.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../controller/invoice/invoice_pluto_edit_view_model.dart';
import '../../../core/shared/widgets/new_pluto.dart';
import '../../invoices/pages/new_invoice_view.dart';

class AllDueAccount extends StatelessWidget {
  final List<String> modelKey;

  const AllDueAccount({super.key, required this.modelKey});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountViewModel>(initState: (state) {
      // Get.find<AccountViewModel>().getAllBondForAccount(modelKey, );
      Get.find<AccountViewModel>().getAllDusAccount(
        modelKey, /*listDate*/
      );
    }, builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomPlutoGridWithAppBar(
                title: "مستحقات ${getAccountNameFromId(modelKey.last)}",
                type: AppConstants.typeAccountDueView,
                onLoaded: (e) {},
                onSelected: (p0) {
                  Get.to(
                    () => InvoiceView(
                      billId: p0.row?.cells["id"]?.value,
                      patternId: p0.row?.cells["نوع الفاتورة"]?.value,
                    ),
                    binding: BindingsBuilder(() {
                      Get.lazyPut(() => InvoicePlutoViewModel());
                    }),
                  );
                },
                // modelList: controller.currentViewAccount,
                modelList: controller.accountList[modelKey.last]?.accRecord
                        .where(
                          (element) => element.balance! > 0,
                        )
                        .toList() ??
                    [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "المجموع :",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    formatDecimalNumberWithCommas(
                        controller.accountList[modelKey.last]?.finalBalance ??
                            0.0),
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
