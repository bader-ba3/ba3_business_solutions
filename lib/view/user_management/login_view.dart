import 'dart:io';

import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pinput/pinput.dart';

import '../../Const/const.dart';
import '../../controller/cards_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool? isNfcAvailable;
  UserManagementViewModel userViewController = Get.find<UserManagementViewModel>();

  @override
  void initState() {
    super.initState();
    Future.sync(() async {
      isNfcAvailable = (Platform.isAndroid || Platform.isIOS) && await NfcManager.instance.isAvailable();
      setState(() {});
      if (isNfcAvailable!) {
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          List<int> idList = tag.data["ndef"]['identifier'];
          String id = '';
          for (var e in idList) {
            if (id == '') {
              id = e.toRadixString(16).padLeft(2, "0");
            } else {
              id = "$id:${e.toRadixString(16).padLeft(2, "0")}";
            }
          }
          var cardId = id.toUpperCase();
          CardsViewModel cardViewController = Get.find<CardsViewModel>();
          if (cardViewController.allCards.containsKey(cardId)) {
            userViewController.cardNumber = cardId;
            userViewController.checkUserStatus();
          } else {
            Get.snackbar("خطأ", "البطاقة غير موجودة");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        WindowTitleBarBox(child: MoveWindow()),

        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              "Ba3 Business Solutions",
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            )),
            // SizedBox(
            //   height: 200,
            // ),
            Center(
                child: Text(
              "تسجيل الدخول الى ${Const.dataName}",
              style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
            )),

            Column(
              children: [
                const Center(
                    child: Text(
                  "ادخل الرقم السري الخاص بك",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 75,
                  child: GetBuilder<UserManagementViewModel>(builder: (controller) {
                    return controller.userStatus != UserManagementStatus.login
                        ? isNfcAvailable ?? false
                            ? const Text("يرجى تقريب بطاقة الدخول")
                            : Pinput(
                                length: 6,
                                onCompleted: (_) {
                                  print(_);
                                  controller.userPin = _;
                                  controller.checkUserStatus();
                                },
                                defaultPinTheme: PinTheme(
                                  width: 56,
                                  height: 56,
                                  textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(200, 238, 253, 1),
                                    border: Border.all(color: const Color.fromRGBO(140, 140, 140, 1)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ))
                        : Stack(
                            children: [
                              SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.black.withOpacity(0.7),
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                child: SizedBox(
                                    width: 80,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.black.withOpacity(0.05),
                                    )),
                              ),
                            ],
                          );
                  }),
                ),
                GetBuilder<UserManagementViewModel>(
                  builder: (controller) {
                    if (Get.isRegistered<GlobalViewModel>()) {
                      GlobalViewModel globalModel = Get.find<GlobalViewModel>();
                      return Obx(
                        () {
                          return Text("${globalModel.count} / ${globalModel.allCountOfInvoice}");
                        },
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ],
        ))
        // SizedBox(
        //   height: 20,
        // ),

        // SizedBox(
        //   height: 300,
        // ),
      ]),
    );
  }
}
