import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_chart_widget1.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/account/account_controller.dart';
import '../../core/helper/functions/functions.dart';
import '../../core/utils/hive.dart';
import '../../model/account/account_model.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: Get.width / 4,
          height: Get.width / 4,
          child: GetBuilder<AccountController>(builder: (accountController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "الحسابات الرئيسية",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              accountController.setBalance(HiveDataBase.mainAccountModelBox.values.toList());
                              accountController.update();
                            },
                            icon: const Icon(Icons.refresh)),
                        IconButton(
                            onPressed: () async {
                              TextEditingController nameController = TextEditingController();
                              List<AccountModel> accountList = [];
                              await Get.defaultDialog(
                                  title: "اكتب اسم الحساب",
                                  content: StatefulBuilder(builder: (context, setstate) {
                                    return SizedBox(
                                      height: MediaQuery.sizeOf(context).width / 4,
                                      width: MediaQuery.sizeOf(context).width / 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: TextFormField(
                                                textDirection: TextDirection.rtl,
                                                decoration:
                                                    const InputDecoration(hintText: "اكتب اسم الحساب او رقمه", hintTextDirection: TextDirection.rtl),
                                                onChanged: (_) {
                                                  accountList = getAccountModelsFromName(_);
                                                  // print(accountList);
                                                  setstate(() {});
                                                },
                                                controller: nameController,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                                child: accountList.isEmpty
                                                    ? const Center(
                                                        child: Text("لا يوجد نتائج"),
                                                      )
                                                    : ListView.builder(
                                                        itemCount: accountList.length,
                                                        itemBuilder: (context, index) {
                                                          AccountModel model = accountList[index];
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
                                        ),
                                      ),
                                    );
                                  }));
                              accountController.update();
                            },
                            icon: const Icon(Icons.add)),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: HiveDataBase.mainAccountModelBox.values.toList().length,
                      itemBuilder: (context, index) {
                        AccountModel model = HiveDataBase.mainAccountModelBox.values.toList()[index];

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onSecondaryTapDown: (details) {
                              dashboardContextMenu(context, details.globalPosition, model.accId!, accountController);
                            },
                            onLongPressStart: (details) {
                              dashboardContextMenu(context, details.globalPosition, model.accId!, accountController);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: Get.width / 4,
                                    child: Text(
                                      model.accName.toString(),
                                      style: const TextStyle(fontSize: 22),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                SizedBox(
                                  width: Get.width / 4,
                                  child: Text(
                                    formatDecimalNumberWithCommas(model.finalBalance ?? 0),
                                    // model.accId!,
                                    style: const TextStyle(fontSize: 22),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(clipBehavior: Clip.hardEdge, borderRadius: BorderRadius.circular(25), child: DashboardChartWidget1()),
        ),
      ],
    );
  }
}
