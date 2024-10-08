import 'dart:ui';

import 'package:ba3_business_solutions/core/bindings/bindings.dart';
import 'package:ba3_business_solutions/core/styling/app_themes.dart';
import 'package:ba3_business_solutions/view/user_management/pages/account_management_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/app_strings.dart';
import 'core/helper/init_app/init_app.dart';

void main() async {
  await initializeApp();

  runApp(const MyApp());
}

const Color backGroundColor = Color(0xffE6E6E6);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GetBinding(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      locale: const Locale("ar"),
      title: AppStrings.appTitle,
      theme: AppThemes.defaultTheme,
      home: const UserManagement(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad
      };
}
