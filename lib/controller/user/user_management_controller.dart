import 'dart:io';

import 'package:ba3_business_solutions/controller/global/changes_controller.dart';
import 'package:ba3_business_solutions/controller/global/global_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/data/model/user/role_model.dart';
import 'package:ba3_business_solutions/data/model/user/user_model.dart';
import 'package:ba3_business_solutions/view/user_management/pages/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pinput/pinput.dart';

import '../../core/helper/functions/functions.dart';
import '../../data/model/user/card_model.dart';
import 'cards_controller.dart';

enum UserManagementStatus {
  first,
  login,
  block,
  auth,
}

class UserManagementController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  UserManagementController() {
    getAllRole();
    initAllUser();
  }

  initUser([String? userId]) {
    if (userId == null) {
      nameController.clear();
      pinController.clear();
      initAddUserModel = UserModel();
    } else {
      initAddUserModel = UserModel.fromJson(allUserList[userId]!.toJson());
      nameController.text = initAddUserModel?.userName ?? "";
      pinController.text = initAddUserModel?.userPin ?? "";
    }
  }

  Map<String, RoleModel> allRole = {};

  UserManagementStatus? userStatus;
  Map<String, UserModel> allUserList = {};
  String? userPin;
  String? cardNumber;
  UserModel? myUserModel;
  UserModel? initAddUserModel;

  void getAllRole() {
    FirebaseFirestore.instance.collection(AppConstants.roleCollection).get().then((event) {
      allRole.clear();
      for (var element in event.docs) {
        allRole[element.id] = RoleModel.fromJson(element.data());
        WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then(
              (value) => update(),
            );
      }
    });
  }

  void checkUserStatus() async {
    if (userPin != null) {
      FirebaseFirestore.instance.collection(AppConstants.usersCollection).where('userPin', isEqualTo: userPin).get().then((value) async {
        if (userPin == null) {
          userStatus = UserManagementStatus.first;
          Get.offAll(() => const LoginView());
        } else if (value.docs.isNotEmpty) {
          if (userStatus != UserManagementStatus.login) {
            myUserModel = UserModel.fromJson(value.docs.first.data());
            userStatus = UserManagementStatus.login;
            Get.put(GlobalController(), permanent: true);
            Get.put(ChangesController(), permanent: true);
            update();
          }
        } else if (value.docs.isEmpty) {
          if (Get.currentRoute != "/LoginView") {
            userStatus = UserManagementStatus.first;
            Get.offAll(() => const LoginView());
          } else {
            Get.snackbar("error", "not matched");
          }
          userPin = null;
          cardNumber = null;
        } else {
          userStatus = null;
        }
        update();
      });
    } else if (cardNumber != null) {
      FirebaseFirestore.instance.collection("Cards").where('cardId', isEqualTo: cardNumber).get().then((value) {
        if (cardNumber == null) {
          userStatus = UserManagementStatus.first;
          Get.offAll(() => const LoginView());
        } else if (value.docs.first.data()["isDisabled"]) {
          Get.snackbar("خطأ", "تم إلغاء تفعيل البطاقة");
          userStatus = UserManagementStatus.first;
          Get.offAll(() => const LoginView());
        } else if (value.docs.isNotEmpty) {
          FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(value.docs.first.data()["userId"]).get().then((value0) {
            myUserModel = UserModel.fromJson(value0.data()!);
            userStatus = UserManagementStatus.login;
            Get.put(GlobalController(), permanent: true);
            Get.put(ChangesController(), permanent: true);
            update();
          });
        } else if (value.docs.isEmpty) {
          if (Get.currentRoute != "/LoginView") {
            userStatus = UserManagementStatus.first;
            Get.offAll(() => const LoginView());
          } else {
            Get.snackbar("error", "not matched");
          }
          userPin = null;
          cardNumber = null;
        } else {
          userStatus = null;
        }
        update();
      });
    } else {
      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        userStatus = UserManagementStatus.first;
        Get.offAll(() => const LoginView());
      });
    }
  }

  void initAllUser() {
    FirebaseFirestore.instance.collection(AppConstants.usersCollection).snapshots().listen((event) {
      allUserList.clear();
      for (var element in event.docs) {
        allUserList[element.id] = UserModel.fromJson(element.data());
      }
      update();
    });
  }

  void addUser() {
    initAddUserModel?.userId ??= generateId(RecordType.user);
    initAddUserModel?.userStatus ??= AppConstants.userStatusOnline;
    FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(initAddUserModel?.userId).set(initAddUserModel!.toJson());
  }

  RoleModel? roleModel;

  void addRole() {
    roleModel?.roleId ??= generateId(RecordType.role);
    FirebaseFirestore.instance.collection(AppConstants.roleCollection).doc(roleModel?.roleId).set(roleModel!.toJson(), SetOptions(merge: true));
    update();
  }

  void startTimeReport({required String userId, DateTime? customDate}) {
    customDate ??= DateTime.now();
    // UserTimeRecord model = UserTimeRecord(date: date, time: time.toString(), timestamp: startTime,totalTime:0);
    FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(userId).set({
      "userDateList": FieldValue.arrayUnion(
        [customDate],
      ),
    }, SetOptions(merge: true));
    FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(userId).set({
      "userStatus": AppConstants.userStatusAway,
    }, SetOptions(merge: true));
  }

  void sendTimeReport({required String userId, int? customTime}) {
    DateTime model = allUserList[userId]!.userDateList!.last;
    customTime ??= DateTime.now().difference(model).inSeconds;
    // Get.snackbar("title", DateTime.now().difference(model).inSeconds.toString());
    FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(userId).update({
      "userTimeList": [...?allUserList[userId]!.userTimeList, customTime],
    });
    FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(userId).set({
      "userStatus": AppConstants.userStatusOnline,
    }, SetOptions(merge: true));
  }

  void logInTime() {
    try {
      FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(myUserModel!.userId).update({
        "logInDateList": FieldValue.arrayUnion([Timestamp.now().toDate()]),
        "userStatus": AppConstants.userStatusOnline,
      });
    } on Exception catch (e) {
      Get.snackbar("Error", "جرب طفي التطبيق ورجاع شغلو او تأكد من اتصال النت  $e \n");
    }
  }

  void logOutTime() {
    try {
      FirebaseFirestore.instance.collection(AppConstants.usersCollection).doc(myUserModel!.userId).update({
        "logOutDateList": FieldValue.arrayUnion([Timestamp.now().toDate()]),
        "userStatus": AppConstants.userStatusOnline,
      });
    } on Exception catch (e) {
      Get.snackbar("Error", "جرب طفي التطبيق ورجاع شغلو او تأكد من اتصال النت  $e \n");
    }
  }
}

getMyUserName() {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.myUserModel?.userName;
}

getCurrentUserSellerId() {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.myUserModel?.userSellerId;
}

getMyUserUserId() {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.myUserModel?.userId;
}

List? getMyUserFaceId() {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.myUserModel?.userFaceId;
}

getMyUserRole() {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.myUserModel?.userRole;
}

getUserNameById(id) {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.allUserList[id]?.userName;
}

UserModel getUserModelById(id) {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  return userManagementViewController.allUserList[id]!;
}

bool checkPermission(role, page) {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  Map<String, List<String>>? userRole = userManagementViewController.allRole[userManagementViewController.myUserModel?.userRole]?.roles;
  if (userRole?[page]?.contains(role) ?? false) {
    return true;
  } else {
    return false;
  }
}

bool checkMainPermission(role) {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  Map<String, List<String>>? userRole = userManagementViewController.allRole[userManagementViewController.myUserModel?.userRole]?.roles;
  if (userRole?[role]?.isNotEmpty ?? false) {
    return true;
  } else {
    return false;
  }
}

Future<bool> hasPermissionForOperation(role, page) async {
  UserManagementController userManagementViewController = Get.find<UserManagementController>();
  Map<String, List<String>>? userRole = userManagementViewController.allRole[userManagementViewController.myUserModel?.userRole]?.roles;
  String error = "";
  // _ndefWrite();
  if (userRole?[page]?.contains(role) ?? false) {
    print("same");
    return true;
  } else {
    print("you need to evelotion");
    bool init = false;
    bool isNfcAvailable = (Platform.isAndroid || Platform.isIOS) && await NfcManager.instance.isAvailable();
    var a = await Get.defaultDialog(
        barrierDismissible: false,
        title: "احتاج الاذن\nل ${getRoleNameFromEnum(role.toString())}\nفي ${getPageNameFromEnum(page.toString())}",
        content: StatefulBuilder(builder: (context, setstate) {
          if (!init && isNfcAvailable) {
            init = true;
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
              CardsController cardViewController = Get.find<CardsController>();
              if (cardViewController.allCards.containsKey(cardId)) {
                CardModel cardModel = cardViewController.allCards[cardId]!;
                Map<String, List<String>>? newUserRole = userManagementViewController.allRole[getUserModelById(cardModel.userId).userRole]?.roles;
                if (newUserRole?[page]?.contains(role) ?? false) {
                  Get.back(result: true);
                  NfcManager.instance.stopSession();
                } else {
                  error = "هذا الحساب غير مصرح له بالقيام بهذه العملية";
                  setstate(() {});
                }
              } else {
                error = "البطاقة غير موجودة";
                setstate(() {});
              }
            });
          }
          return Column(
            children: [
              if (!isNfcAvailable)
                Column(
                  children: [
                    Pinput(
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue.shade400.withOpacity(0.5))),
                      length: 6,
                      obscureText: true,
                      onCompleted: (_) {
                        UserModel? user =
                            userManagementViewController.allUserList.values.toList().firstWhereOrNull((element) => element.userPin == _);
                        if (user != null) {
                          Map<String, List<String>>? newUserRole = userManagementViewController.allRole[user.userRole]?.roles;
                          if (newUserRole?[page]?.contains(role) ?? false) {
                            Get.back(result: true);
                            NfcManager.instance.stopSession();
                          } else {
                            error = "هذا الحساب غير مصرح له بالقيام بهذه العملية";
                            setstate(() {});
                          }
                        } else {
                          error = "الحساب غير موجود";
                          setstate(() {});
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              Text(
                error,
                style: const TextStyle(fontSize: 22, color: Colors.red),
              ),
              if (error != "")
                const SizedBox(
                  height: 5,
                ),
              if (isNfcAvailable)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
            ],
          );
        }),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text("cancel"))
        ]);

    print("a:$a");
    return a;
  }
}
