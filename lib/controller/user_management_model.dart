import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
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

import '../model/global_model.dart';

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
    FirebaseFirestore.instance.collection(Const.usersCollection).where('userPin', isEqualTo: userPin).snapshots().listen((value) {
      print('From Cache: ${value.metadata.isFromCache}');
      // if (value.metadata.isFromCache) {
      //   userStatus = null;
      //   Get.defaultDialog(barrierDismissible: false, title: "you are offline", middleText: "plz reconnect to the internet", actions: [
      //     ElevatedButton(
      //         onPressed: () {
      //           Get.back();
      //           checkUserStatus();
      //         },
      //         child: Text("Retry"))
      //   ]);
      // } else

        if (userPin == null) {
        userStatus = UserManagementStatus.first;
        Get.offAll(() => LoginView());
      } else if (value.docs.isNotEmpty) {
        print(value.docs.first.data());
        myUserModel = UserModel.fromJson(value.docs.first.data());
        userStatus = UserManagementStatus.login;
        Get.offAll(() => HomeView());
      } else if (value.docs.isEmpty) {
        if (Get.currentRoute != "/LoginView") {
          userStatus = UserManagementStatus.first;
          Get.offAll(() => LoginView());
        } else {
          Get.snackbar("error", "not matched");
        }
        userPin = null;
      } else {
        userStatus = null;
      }
      update();
    });
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

  bool checkAllAccount(List<GlobalModel>bondList) {
    List<String>finalList=[];
    bondList.forEach((e) {
      e.bondRecord?.forEach((element) {
        if(getAccountIdFromText(element.bondRecAccount)==""){
          finalList.add(element.bondRecAccount!);
        }
      });
    });
    if(finalList.isEmpty) {
    return true;
    }else{
      Get.defaultDialog(middleText: "some account is not defind",cancel: Column(
        children: [
          for(var i=0;i<finalList.length;i++)
            Text(finalList[i]),
          ElevatedButton(onPressed: (){Get.back();}, child: Text("ok"))
        ],
      ));
      return false;
    }
  }

  void addBond(List<GlobalModel> bondList) {
    BondViewModel bondController=Get.find<BondViewModel>();
    bondList.forEach((element) {
      bondController.fastAddBond(oldBondCode: element.bondCode,bondId:element.bondId ,originId: null, total: double.parse("0.00"), record: element.bondRecord!,bondDate: element.bondDate,bondType: element.bondType);
    });
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
  if (userRole?[page]?.contains(role)??false) {
    print("same");
    return true;
  }
  else {
    print("you need to evelotion");
    var a = await Get.defaultDialog(
        barrierDismissible: false,
        title: "احتاج الاذن"+"\n"+"ل "+getRoleNameFromEnum(role.toString())+"\n"+"في "+getPageNameFromEnum(page.toString()),
        content: Pinput(
            keyboardType : TextInputType.number,
          defaultPinTheme: PinTheme(width: 50, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blue.shade400.withOpacity(0.5))),
          length: 6,
          onCompleted: (_) {
            FirebaseFirestore.instance.collection("users").where('userPin', isEqualTo: _).get().then((value) {
              if (value.docs.isEmpty) {
                Get.snackbar("خطأ", "الحساب غير موجود");
              } else {
                Map<String, List<String>>? newUserRole=userManagementViewController.allRole[value.docs.first.data()['userRole']]?.roles;
                print(page);
                print(newUserRole?[page]);
                print(role);
                if (newUserRole?[page]?.contains(role)??false) {
                  Get.back(result: "ok");
                  Get.snackbar("", "تمت المصادقة");
                  print("scss");
                }
                else {
                  Get.snackbar("خطأ", "هذا الحساب غير مصرح له بالقيام بهذه العملية");
                  print("not permission to do this process");
                }
              }
            });
          },
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.back(result: "no");
              },
              child: Text("cancel"))
        ]);
    print(a);
    if (a == "ok") {
      return true;
    } else {
      return false;
    }
  }
}
