import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_controller.dart';
import '../../../core/utils/hive.dart';
import '../../../data/model/account/account_model.dart';

class SearchAccountWidget extends StatelessWidget {
  const SearchAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        await Get.defaultDialog(
            title: "اكتب اسم الحساب",
            content: SizedBox(
              height: MediaQuery.sizeOf(context).width / 4,
              width: MediaQuery.sizeOf(context).width / 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<AccountController>(builder: (accountController) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                              hintText: "اكتب اسم الحساب او رقمه", hintTextDirection: TextDirection.rtl),
                          onChanged: (accountName) {
                            accountController.searchAccounts(accountName);
                          },
                          controller: accountController.nameController,
                        ),
                      ),
                      const VerticalSpace(),
                      Expanded(
                          child: accountController.accounts.isEmpty
                              ? const Center(
                                  child: Text("لا يوجد نتائج"),
                                )
                              : ListView.builder(
                                  itemCount: accountController.accounts.length,
                                  itemBuilder: (context, index) {
                                    AccountModel model = accountController.accounts[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                          onTap: () {
                                            HiveDataBase.mainAccountModelBox.put(model.accId, model);
                                            Get.back();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${model.accName}   ${model.accCode}",
                                              textDirection: TextDirection.rtl,
                                            ),
                                          )),
                                    );
                                  },
                                ))
                    ],
                  );
                }),
              ),
            ));
      },
    );
  }
}
