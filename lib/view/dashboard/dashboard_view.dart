import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_chart_widget1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Dialogs/Account_Option_Dialog.dart';
import '../../controller/account_view_model.dart';
import '../../model/account_model.dart';
import '../../utils/hive.dart';
import '../accounts/widget/account_details.dart';
import '../invoices/Controller/Search_View_Controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: Get.width / 4,
          height: Get.width / 4,
          child: GetBuilder<AccountViewModel>(builder: (accountController) {
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
                        ElevatedButton(
                            onPressed: () async {
                              print(Get.find<GlobalViewModel>().allGlobalModel.values
                                  .where(
                                    (element) => element.globalType == Const.globalTypeCheque,
                              )
                                  .toList()
                                  .map(
                                    (e) => e.toFullJson(),
                              )
                                  .toList());
                            },
                        /*      onPressed: () async {
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
                                                  accountList = getAccountModelFromName(_);
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

                            ///رفع الرصيد النهائي للحسابات
                             print(accountController.accountList.length);
                              // accountController.accountList.forEach(
                              //   (key, value) async{
                              //
                              //     print(getAccountNameFromId(key));
                              //     print(getAccountBalanceFromId(key));
                              //    await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(key).set({"finalBalance": getAccountBalanceFromId(key)}, SetOptions(merge: true));
                              //   },
                              // );
                            },*/
                            child: const Text("إضافة حساب ")),
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
                              showContextMenu(context, details.globalPosition, model.accId!, accountController);
                            },
                            onLongPressStart: (details) {
                              showContextMenu(context, details.globalPosition, model.accId!, accountController);
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
                                    model.finalBalance?.toStringAsFixed(2)??"0.00",
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

  void showContextMenu(BuildContext parentContext, Offset tapPosition, String id, AccountViewModel accountController) {
    showMenu(
      context: parentContext,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy * 1.0,
      ),
      items: [
        PopupMenuItem(
          onTap: (){
            Get.find<SearchViewController>().initController(accountForSearch: getAccountNameFromId(id));
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => const AccountOptionDialog(),
            );
          },
          value: 'details',
          child: ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.blue.shade300,
            ),
            title: Text('عرض الحركات'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          onTap: (){
            HiveDataBase.mainAccountModelBox.delete(id);
            accountController.update();
          },
          child: ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Colors.red.shade700,
            ),
            title: Text('حذف'),
          ),
        ),
      ],
    );
  }
}
