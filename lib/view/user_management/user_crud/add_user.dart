import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/user_model.dart';
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
      userManagementViewController.initAddUserModel = userManagementViewController.allUserList[widget.oldKey];
      nameController.text = userManagementViewController.initAddUserModel?.userName ?? "";
      pinController.text = userManagementViewController.initAddUserModel?.userPin ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.initAddUserModel?.userName ?? "مستخدم جديد"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              // SizedBox(
              //     height: 40,
              //     width: 90,
              //     child: DropdownButton<String>(
              //       value: controller.initAddUserModel?.userRole,
              //       items: roleMap.keys.toList().map((e) => DropdownMenuItem(value: roleMap[e], child: Text(e.toString()))).toList(),
              //       onChanged: (_) {
              //         controller.initAddUserModel?.userRole = _;
              //         controller.update();
              //       },
              //     )),
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
                    controller.addUser();
                  },
                  child: Text("add"))
            ],
          ),
        ),
      );
    });
  }
}
