import 'package:ba3_business_solutions/controller/pattern/pattern_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/view/statistics/pages/statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/model/account/account_model.dart';

class StatisticsLayout extends StatefulWidget {
  const StatisticsLayout({super.key});

  @override
  State<StatisticsLayout> createState() => _StatisticsLayoutState();
}

class _StatisticsLayoutState extends State<StatisticsLayout> {
  PatternController patternController = Get.find<PatternController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الاحصائيات"),
        ),
        body: Column(
          children: [
            item(
              "إضافة حساب",
              () async {
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
                                  decoration: const InputDecoration(hintText: "اكتب اسم الحساب او رقمه", hintTextDirection: TextDirection.rtl),
                                  onChanged: (_) {
                                    accountList = getAccountModelsFromName(_);
                                    print(accountList);
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
                                                    HiveDataBase.statisticBox.put(model.accId, {
                                                      "accName": model.accName,
                                                      "accId": model.accId,
                                                    });
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
                setState(() {});
              },
            ),
            for (var i in HiveDataBase.statisticBox.values.toList())
              item("معاينة ${i["accName"]}", () {
                hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewStore).then((value) {
                  if (value) {
                    Get.to(() => StatisticsView(accountId: i["accId"]!));
                  }
                });
              }),
          ],
        ),
      ),
    );
  }

  Widget item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ))),
      ),
    );
  }
}
