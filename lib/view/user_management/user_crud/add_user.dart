import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/user_model.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/time_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Map<String, String> roleMap = {
//   "Read": Const.roleUserRead,
//   "Write": Const.roleUserWrite,
//   "Update": Const.roleUserUpdate,
//   "Delete": Const.roleUserDelete,
//   "Admin": Const.roleUserAdmin,
// };

class AddUserView extends StatefulWidget {
  final String? oldKey;
  const AddUserView({super.key, this.oldKey});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  SellersViewModel sellerViewController = Get.find<SellersViewModel>();
  TextEditingController nameController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.oldKey == null) {
      userManagementViewController.initAddUserModel = UserModel();
    } else {
      userManagementViewController.initAddUserModel = UserModel.fromJson(userManagementViewController.allUserList[widget.oldKey]!.toJson());
      nameController.text = userManagementViewController.initAddUserModel?.userName ?? "";
      pinController.text = userManagementViewController.initAddUserModel?.userPin ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementViewModel>(builder: (controller) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(controller.initAddUserModel?.userName ?? "مستخدم جديد"),
            actions: [
              if(controller.initAddUserModel?.userId!=null)
              ElevatedButton(onPressed: (){
                Get.to(()=>TimeDetails(oldKey: controller.initAddUserModel!.userId!,name:controller.initAddUserModel!.userName! ,));
              }, child: Text("البريك")),
              SizedBox(width: 20,),
            ],
          ),
          body: Center(
            child: ListView(
              shrinkWrap: true,
            //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("اسم الحساب"),
                SizedBox(
                    height: 100,
                    width: 200,
                    child: TextFormField(
                      controller: nameController,
                      onChanged: (_) {
                        controller.initAddUserModel?.userName = _;
                      },
                    )),
                SizedBox(
                  height: 75,
                ),
                Text("كلمة السر"),
                SizedBox(
                    height: 100,
                    width: 200,
                    child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                      controller: pinController,
                      onChanged: (_) {
                        controller.initAddUserModel?.userPin = _;
                      },
                    )),
                SizedBox(
                  height: 75,
                ),
                Text("الصلاحيات"),
                SizedBox(
                    height: 40,
                    width: 100,
                    child: DropdownButton<String>(
                      value: controller.initAddUserModel?.userRole,
                      items: userManagementViewController.allRole.values.map((e) => DropdownMenuItem(value: e.roleId,child: Text(e.roleName!))).toList(),
                      onChanged: (_) {
                        controller.initAddUserModel?.userRole = _;
                        controller.update();
                      },
                    )),
                SizedBox(
                  height: 75,
                ),
                Text("البائع"),
                SizedBox(
                    height: 40,
                    width: 90,
                    child: DropdownButton<String>(
                      value: controller.initAddUserModel?.userSellerId,
                      items: sellerViewController.allSellers.keys.toList().map((e) => DropdownMenuItem(value: sellerViewController.allSellers[e]?.sellerId, child: Text(sellerViewController.allSellers[e]?.sellerName??"error"))).toList(),
                      onChanged: (_) {
                        controller.initAddUserModel?.userSellerId = _;
                        controller.update();
                      },
                    )),
                SizedBox(
                  height: 75,
                ),
                ElevatedButton(
                    onPressed: () {
                      if(nameController.text.isEmpty){
                        Get.snackbar("خطأ", "يرجى كتابة الاسم");
                      }else if(pinController.text.length!=6){
                        Get.snackbar("خطأ", "يرجى كتابة كلمة السر");
                      }else if(controller.initAddUserModel?.userSellerId==null){
                        Get.snackbar("خطأ", "يرجى اختيار البائع");
                      }else if(controller.initAddUserModel?.userRole==null){
                          Get.snackbar("خطأ", "يرجى اختيار الصلاحيات");
                      }
                      else {
                        controller.addUser();
                      }
                    },
                    child: Text(controller.initAddUserModel?.userId ==null ?"إضافة":"تعديل"))
              ],
            ),
          ),
        ),
      );
    });
  }
}
