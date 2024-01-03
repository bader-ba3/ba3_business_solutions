import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // SizedBox(
        //   height: 20,
        // ),
        Center(
            child: Text(
              "Ba3 Business Solutions",
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
            )),
        // SizedBox(
        //   height: 200,
        // ),
        Center(
            child: Text(
              "Write your Pin Code",
          style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
        )),
        GetBuilder<UserManagementViewModel>(builder: (controller) {
          return Pinput(
              length: 6,
              onCompleted: (_) {
                print(_);
                controller.userPin = _;
                controller.checkUserStatus();
              },
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(200, 238, 253, 1),
                  border: Border.all(color: Color.fromRGBO(140, 140, 140, 1)),
                  borderRadius: BorderRadius.circular(20),
                ),
              ));
        }),
        // SizedBox(
        //   height: 300,
        // ),
      ]),
    );
  }
}
