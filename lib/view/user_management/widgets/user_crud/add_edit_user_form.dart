import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEditUserForm extends StatelessWidget {
  const AddEditUserForm({
    super.key,
    required this.userManagementViewController,
    required this.sellerViewController,
  });

  final UserManagementController userManagementViewController;
  final SellersController sellerViewController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 300,
          child: Row(
            children: [
              const SizedBox(width: 70, child: Text("اسم الحساب")),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                  controller: userManagementViewController.nameController,
                  onChanged: (_) {
                    userManagementViewController.initAddUserModel?.userName = _;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          child: Row(
            children: [
              const SizedBox(width: 70, child: Text("كلمة السر")),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  controller: userManagementViewController.pinController,
                  onChanged: (_) {
                    userManagementViewController.initAddUserModel?.userPin = _;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          child: Row(
            children: [
              const SizedBox(width: 70, child: Text("الصلاحيات")),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: DropdownButton<String>(
                    icon: const SizedBox(),
                    value: userManagementViewController.initAddUserModel?.userRole,
                    items:
                        userManagementViewController.allRoles.values.map((e) => DropdownMenuItem(value: e.roleId, child: Text(e.roleName!))).toList(),
                    onChanged: (_) {
                      userManagementViewController.initAddUserModel?.userRole = _;
                      userManagementViewController.update();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          child: Row(
            children: [
              const SizedBox(width: 70, child: Text("البائع")),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: DropdownButton<String>(
                    icon: const SizedBox(),
                    value: userManagementViewController.initAddUserModel?.userSellerId,
                    items: sellerViewController.allSellers.keys
                        .toList()
                        .map((e) => DropdownMenuItem(
                            value: sellerViewController.allSellers[e]?.sellerId,
                            child: Text(sellerViewController.allSellers[e]?.sellerName ?? "error")))
                        .toList(),
                    onChanged: (_) {
                      userManagementViewController.initAddUserModel?.userSellerId = _;
                      userManagementViewController.update();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
