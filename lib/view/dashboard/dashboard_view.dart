import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_chart_widget1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/account_view_model.dart';
import '../../model/account_model.dart';
import '../../utils/hive.dart';

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
                            onPressed: () {
                              int i = 0;
                              // HiveDataBase.accountModelBox.deleteFromDisk();
                              HiveDataBase.globalModelBox.deleteFromDisk();
              /*                FirebaseFirestore.instance.collection(Const.accountsCollection).get().then((value) {

                                AccountModel model=AccountModel();

                                model=AccountModel.fromJson((value.docs.last.data() ));
                                HiveDataBase.accountModelBox.put(model.accId, model);
                                print(value.docs.length);
                              },);*/
                              // print(HiveDataBase.accountModelBox.values.map((e) => e.toJson(),).toList());

              /*                HiveDataBase.accountModelBox.values
                                  .where(
                                (element) => *//*element.accIsParent != true&&*//*element.accId=="acc1725318978879576",
                              )
                                  .forEach((element) {
                             *//*   if (getAccountIdFromText(element.accParentId!) != '') {
                                  if (i == 0) {
                                    //acc1725319203402595
                                    print(element.toJson());

                                    // HiveDataBase.accountModelBox.put(getAccountIdFromText(element.accParentId!), element..accChild.add(element.accId!));
                                    *//**//*       FirebaseFirestore.instance.collection(Const.accountsCollection).doc(getAccountIdFromText(element.accParentId!)).set({
                                        "accChild": FieldValue.arrayUnion([element.accId!])
                                      }, SetOptions(merge: true));
                                      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set({
                                        "accParentId": getAccountIdFromText(element.accParentId!)
                                      }, SetOptions(merge: true));*//**//*
                                    print(element.toJson());
                                    i++;
                                  }
                                }*//*
                              });*/

                              // print();
                            },
                            /*  onPressed: () async {
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
            */ /*                print(accountController.accountList.length);
                              accountController.accountList.forEach(
                                (key, value) async{

                                  print(getAccountNameFromId(key));
                                  print(getAccountBalanceFromId(key));
                                 await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(key).set({"finalBalance": getAccountBalanceFromId(key)}, SetOptions(merge: true));
                                },
                              );*/ /*
                            },*/
                            child: Text("إضافة حساب ")),
                        SizedBox(
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
                                    (accountController.accountList[model.accId]?.finalBalance ?? 0).toStringAsFixed(2),
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
          child: ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Colors.red.shade700,
            ),
            title: Text('حذف'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'details') {
        /*Get.to(() => AccountDetails(modelKey: id));*/
      } else if (value == 'delete') {
        HiveDataBase.mainAccountModelBox.delete(id);
        accountController.update();
      }
    });
  }
}
