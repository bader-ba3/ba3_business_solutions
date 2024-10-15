import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../core/helper/functions/functions.dart';

class UserTimeView extends StatelessWidget {
  const UserTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل الدوام"),
      ),
      body: GetBuilder<UserManagementController>(builder: (logic) {
        print(logic.allUserList[logic.myUserModel!.userId!]?.logInDateList
            ?.lastOrNull);
        return Column(
          children: [
            Item(
              "تسجيل الحضور",
              () {
                logic.logInTime();
                logic.update();
              },
            ),
            Item(
              "تسجيل المغادرة",
              color: Colors.red,
              () {
                logic.logOutTime();
                logic.update();
              },
            ),
            if (logic.allUserList[logic.myUserModel!.userId!]?.logInDateList
                    ?.lastOrNull !=
                null) ...[
              const Text(
                "اخر تسحيل دخول",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Item(
                formatDateTimeFromString(logic
                    .allUserList[logic.myUserModel?.userId ?? '']!
                    .logInDateList!
                    .last
                    .toString()),
                () {},
                color: Colors.green,
              )
            ],
            if (logic.allUserList[logic.myUserModel?.userId ?? '']
                    ?.logOutDateList?.lastOrNull !=
                null) ...[
              const Text(
                "اخر تسحيل خروج",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Item(
                formatDateTimeFromString(logic
                    .allUserList[logic.myUserModel?.userId ?? '']!
                    .logOutDateList!
                    .last
                    .toString()),
                () {},
                color: Colors.black,
              )
            ]
          ],
        );
      }),
    );
  }
}

Widget Item(text, onTap, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color ?? Colors.white)),
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          )),
    ),
  );
}
