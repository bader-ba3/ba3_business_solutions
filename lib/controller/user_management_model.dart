import 'dart:io';
import 'dart:typed_data';

import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/model/role_model.dart';
import 'package:ba3_business_solutions/model/user_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/user_management/login_view.dart';
import 'package:ba3_business_solutions/view/home/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../model/card_model.dart';
import '../model/global_model.dart';
import 'cards_view_model.dart';

enum UserManagementStatus {
  first,
  login,
  block,
  auth,
}

class UserManagementViewModel extends GetxController {
  UserManagementViewModel() {
   getAllRole();
   initAllUser();
  }
  Map<String,RoleModel>allRole={};

  UserManagementStatus? userStatus;
  Map<String, UserModel> allUserList = {};
  String? userPin;
  String? cardNumber;
  UserModel? myUserModel;
  UserModel? initAddUserModel;

  void getAllRole(){
    FirebaseFirestore.instance.collection(Const.roleCollection).snapshots().listen((event) {
      allRole.clear();
      for (var element in event.docs) {
        allRole[element.id]=RoleModel.fromJson(element.data());
      }
    });
  }
  void checkUserStatus() async {
    if (userPin != null) {
      FirebaseFirestore.instance.collection(Const.usersCollection).where('userPin', isEqualTo: userPin).snapshots().listen((value) {
        if (userPin == null) {
          userStatus = UserManagementStatus.first;
          Get.offAll(() => LoginView());
        } else if (value.docs.isNotEmpty) {
          myUserModel = UserModel.fromJson(value.docs.first.data());
          userStatus = UserManagementStatus.login;
          Get.put(GlobalViewModel(), permanent: true);
        } else if (value.docs.isEmpty) {
          if (Get.currentRoute != "/LoginView") {
            userStatus = UserManagementStatus.first;
            Get.offAll(() => LoginView());
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
    }else if (cardNumber!=null){
      FirebaseFirestore.instance.collection("Cards").where('cardId', isEqualTo: cardNumber).snapshots().listen((value) {
        if (cardNumber == null) {
          userStatus = UserManagementStatus.first;
          Get.offAll(() => LoginView());
        } else if (value.docs.first.data()["isDisabled"]) {
          Get.snackbar("خطأ", "تم إلغاء تفعيل البطاقة");
          userStatus = UserManagementStatus.first;
          Get.offAll(() => LoginView());
        } else if (value.docs.isNotEmpty) {
          print(value.docs.first.data());
          FirebaseFirestore.instance.collection(Const.usersCollection).doc(value.docs.first.data()["userId"]).get().then((value0) {
          myUserModel = UserModel.fromJson(value0.data()!);
          userStatus = UserManagementStatus.login;
          Get.put(GlobalViewModel(), permanent: true);
          });
        } else if (value.docs.isEmpty) {
          if (Get.currentRoute != "/LoginView") {
            userStatus = UserManagementStatus.first;
            Get.offAll(() => LoginView());
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
    }else{
      print("else");
      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        userStatus = UserManagementStatus.first;
        Get.offAll(() => LoginView());
      });

    }
  }

  void initAllUser() {
    print("admin init");
    FirebaseFirestore.instance.collection(Const.usersCollection).snapshots().listen((event) {
      allUserList.clear();
      for (var element in event.docs) {
        allUserList[element.id] = UserModel.fromJson(element.data());
      }
      update();
    });
  }

  void addUser() {
    initAddUserModel?.userId ??= generateId(RecordType.user);
    FirebaseFirestore.instance.collection(Const.usersCollection).doc(initAddUserModel?.userId).set(initAddUserModel!.toJson());
  }
  RoleModel? roleModel;

  void addRole() {

    roleModel?.roleId??=generateId(RecordType.role);
    FirebaseFirestore.instance.collection(Const.roleCollection).doc(roleModel?.roleId).set(roleModel!.toJson(),SetOptions(merge: true));
    update();
  }



}

getMyUserName() {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.myUserModel?.userName;
}
getMyUserSellerId() {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.myUserModel?.userSellerId;
}
getMyUserUserId() {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.myUserModel?.userId;
}
List? getMyUserFaceId() {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.myUserModel?.userFaceId;
}
getMyUserRole() {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.myUserModel?.userRole;
}
getUserNameById(id) {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.allUserList[id]?.userName;
}
UserModel getUserModelById(id) {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  return userManagementViewController.allUserList[id]!;
}

bool checkPermission(role,page){
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  Map<String, List<String>>? userRole=userManagementViewController.allRole[userManagementViewController.myUserModel?.userRole]?.roles;
  if (userRole?[page]?.contains(role)??false) {
    return true;
  }else{
    return false;
  }
}

Future<bool> checkPermissionForOperation(role,page) async {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  Map<String, List<String>>? userRole=userManagementViewController.allRole[userManagementViewController.myUserModel?.userRole]?.roles;
  String error = "";
  // _ndefWrite();
  if (userRole?[page]?.contains(role)??false) {
    print("same");
    return true;
  }
  else {
    print("you need to evelotion");
    bool init = false;
    bool isNfcAvailable = (Platform.isAndroid||Platform.isIOS)&&await NfcManager.instance.isAvailable();
    var a = await Get.defaultDialog(
        barrierDismissible: false,
        title: "احتاج الاذن"+"\n"+"ل "+getRoleNameFromEnum(role.toString())+"\n"+"في "+getPageNameFromEnum(page.toString()),
        content: StatefulBuilder(
          builder: (context,setstate) {
            if(!init&&isNfcAvailable){
              init = true;
              NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
                List<int> idList = tag.data["ndef"]['identifier'];
                String id ='';
                for(var e in idList){
                  if(id==''){
                    id="${e.toRadixString(16).padLeft(2,"0")}";
                  }else{
                    id="$id:${e.toRadixString(16).padLeft(2,"0")}";
                  }
                }
                var cardId=id.toUpperCase();
                CardsViewModel cardViewController = Get.find<CardsViewModel>();
                if(cardViewController.allCards.containsKey(cardId)){
                  CardModel cardModel = cardViewController.allCards[cardId]!;
                  Map<String, List<String>>? newUserRole=userManagementViewController.allRole[getUserModelById(cardModel.userId).userRole]?.roles;
                  if (newUserRole?[page]?.contains(role)??false) {
                    Get.back(result: true);
                    NfcManager.instance.stopSession();
                  }else{
                    error =  "هذا الحساب غير مصرح له بالقيام بهذه العملية";
                    setstate((){});
                  }
                }else{
                  error="البطاقة غير موجودة";
                  setstate((){});
                }
              });
            }
            return Column(
              children: [
                if(!isNfcAvailable)
                  Column(
                    children: [
                      Pinput(
                        keyboardType : TextInputType.number,
                        defaultPinTheme: PinTheme(width: 50, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue.shade400.withOpacity(0.5))),
                        length: 6,
                        onCompleted: (_) {
                          UserModel? user = userManagementViewController.allUserList.values.toList().firstWhereOrNull((element) => element.userPin==_);
                          if(user!=null){
                            Map<String, List<String>>? newUserRole=userManagementViewController.allRole[user.userRole]?.roles;
                            if (newUserRole?[page]?.contains(role)??false) {
                              Get.back(result: true);
                              NfcManager.instance.stopSession();
                            }else{
                              error =  "هذا الحساب غير مصرح له بالقيام بهذه العملية";
                              setstate((){});
                            }
                          }else{
                          error="الحساب غير موجود";
                          setstate((){});
                          }

                        },
                      ),
                      SizedBox(height: 5,),
                    ],
                  ),
                Text(error,style: TextStyle(fontSize: 22,color: Colors.red),),
                if(error!="")
                SizedBox(height: 5,),
                if(isNfcAvailable)
                Column(children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                ],)
              ],
            );
          }
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text("cancel"))
        ]);

    print("a:"+a.toString());
   return a;
  }
}