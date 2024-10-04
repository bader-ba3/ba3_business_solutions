import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_view_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../controller/invoice/invoice_pluto_edit_view_model.dart';
import '../../../core/shared/widgets/new_Pluto.dart';
import '../../bonds/pages/bond_details_view.dart';
import '../../bonds/widget/bond_record_pluto_view_model.dart';
import '../../invoices/pages/new_invoice_view.dart';

class AccountDetails extends StatelessWidget {
  // final String modelKey;
  final List<String> listDate, modelKey;

  const AccountDetails(
      {super.key, required this.modelKey, required this.listDate});

  // var accountController = Get.find<AccountViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountViewModel>(initState: (state) {
      print(modelKey);
      Get.find<AccountViewModel>().getAllBondForAccount(modelKey, listDate);
    }, builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomPlutoGridWithAppBar(
                title:
                    "حركات ${getAccountNameFromId(modelKey.last)} من تاريخ  ${listDate.first}  إلى تاريخ  ${listDate.last}",
                type: AppStrings.typeAccountView,
                onLoaded: (e) {},
                onSelected: (p0) {
                  if ((p0.row?.cells["id"]?.value
                          .toString()
                          .startsWith("bon") ??
                      false)) {
                    Get.to(
                      () => BondDetailsView(
                        oldId: p0.row?.cells["id"]?.value,
                        bondType: getBondEnumFromType(
                            p0.row?.cells["نوع السند"]?.value),
                      ),
                      binding: BindingsBuilder(() {
                        Get.lazyPut(() => BondRecordPlutoViewModel(
                            getBondEnumFromType(
                                p0.row?.cells["نوع السند"]?.value)));
                      }),
                    );
                  }
                  if ((p0.row?.cells["id"]?.value
                          .toString()
                          .startsWith("inv") ??
                      false)) {
                    Get.to(
                      () => InvoiceView(
                        billId: p0.row?.cells["id"]?.value,
                        patternId: p0.row?.cells["نوع السند"]?.value,
                      ),
                      binding: BindingsBuilder(() {
                        Get.lazyPut(() => InvoicePlutoViewModel());
                      }),
                    );
                  }
                  if ((p0.row?.cells["id"]?.value
                          .toString()
                          .startsWith("entry") ??
                      false)) {
                    // Get.to(
                    //       () => EntryBondDetailsView(
                    //     oldId: p0.row?.cells["id"]?.value,
                    //   ),
                    // );
                  }
                  if ((p0.row?.cells["id"]?.value
                          .toString()
                          .startsWith("chuq") ??
                      false)) {
                    // Get.to(
                    //       () => Cheque(
                    //     oldId: p0.row?.cells["id"]?.value,
                    //   ),
                    // );
                  }
                },
                // modelList: controller.currentViewAccount,
                modelList:
                    controller.accountList[modelKey.last]?.accRecord ?? [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "مدين :",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        formatDecimalNumberWithCommas(controller.debitValue),
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 32),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "دائن :",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 24),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        formatDecimalNumberWithCommas(controller.creditValue),
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 32),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        formatDecimalNumberWithCommas(controller.searchValue),
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 32),
                      ),
                    ],
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
